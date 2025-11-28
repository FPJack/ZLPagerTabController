//
//  ZLPagerTabBar.m
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import "ZLPagerTabBar.h"
@interface ZLTabBarItemLabel()
@property (nonatomic,assign)BOOL isSegmentedControlStyle;
@end
@implementation ZLTabBarItemLabel
- (UILabel *)frontLabel {
    if (!_frontLabel) {
        _frontLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectZero];
        maskView.backgroundColor = UIColor.whiteColor;
        _frontLabel.maskView = maskView;
    }
    return _frontLabel;
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (_frontLabel) {
        self.frontLabel.font = font;
    }
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    if (_frontLabel) {
        self.frontLabel.textAlignment = textAlignment;
    }
}
- (void)setText:(NSString *)text {
    [super setText:text];
    if (_frontLabel) {
        self.frontLabel.text = text;
    }
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    if (_frontLabel) {
        self.frontLabel.attributedText = attributedText;
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_frontLabel) {
        [self addSubview:self.frontLabel];
        self.frontLabel.frame = self.bounds;
        
    }
}
@end

@implementation ZLRTLTabBarCollectionView
- (UIUserInterfaceLayoutDirection)effectiveUserInterfaceLayoutDirection {
    return  [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute];
}
- (void)reloadData {
    [super reloadData];
}
@end
@implementation ZLRTLTabBarCollectionViewFlowLayout
- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return  [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:UIView.appearance.semanticContentAttribute] == UIUserInterfaceLayoutDirectionRightToLeft;
}
@end
@interface ZLTabBarCell()
@property (nonatomic,weak) ZLTabBarCellModel *model;
@end
@implementation ZLTabBarCell
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = UIStackView.new;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.spacing = self.titleImageSpace;
        _stackView.tag = 1001;
//        self.contentView.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.2];
        [self.contentView addSubview:_stackView];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.stackView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
            [self.stackView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];
    }
    return _stackView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ZLTabBarItemLabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.tag = 1002;
        [self.stackView addArrangedSubview:_titleLabel];
    }
    return _titleLabel;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.tag = 1003;
        [self.stackView addArrangedSubview:_imageView];
    }
    return _imageView;
}
- (void)setModel:(ZLTabBarCellModel *)model {
    _model = model;
    if (model.isSelected) {
        if (_titleLabel) {
            self.titleLabel.hidden = (model.selectTitle ?: @"").length == 0 && model.selectAttributedText == nil;
        }
        if (_imageView) {
            self.imageView.hidden = model.selectedImage == nil;
        }
    }else {
        if (_titleLabel) {
            self.titleLabel.hidden = (model.title ?: @"").length == 0 && model.attributedText == nil;
        }
        if (_imageView) {
            self.imageView.hidden = model.image == nil;
        }
    }
}
@end


@interface ZLPagerTabBar ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (readwrite, nonatomic,strong) UIView * selectedBar;
@property (nonatomic,strong,readwrite)UIView *extraView;
@property (nonatomic,assign,readwrite)UICollectionView *collectionView;
@property (nonatomic,assign,readwrite) NSInteger currentIndex;
@property (nonatomic,strong,readwrite) NSArray<ZLTabBarCellModel *> *items;


@property (nonatomic) BOOL shouldUpdateButtonBarView;
@property (nonatomic,assign)CGFloat minInterItemSpacing;
@property (nonatomic,assign) ZLTabBarViewAlignment innerAlignment;


@end
@implementation ZLPagerTabBar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.selectedBar.layer.cornerRadius = 1;
//        self.selectedBar.layer.masksToBounds = YES;
        self.alignment = ZLTabBarViewAlignmentCenter;
        self.minItemSpacing = 10;
        self.backgroundColor = UIColor.whiteColor;
        _contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectedBarAlignment = ZLSelectedBarAlignmentBottomCenter;
        self.shouldUpdateButtonBarView = YES;
    }
    return self;
}
- (void)setAlignment:(ZLTabBarViewAlignment)alignment {
    _alignment = alignment;
    self.innerAlignment = alignment;
}
- (void)setMinItemSpacing:(CGFloat)minItemSpacing {
    _minItemSpacing = minItemSpacing;
    [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.minInterItemSpacing = minItemSpacing;
    }];
    self.minInterItemSpacing = minItemSpacing;
}
- (CGFloat)minInterItemSpacing {
    if (_minInterItemSpacing <= 0) {
        _minInterItemSpacing = self.minItemSpacing;
    }
    return _minInterItemSpacing;
}

- (NSArray<ZLTabBarCellModel *> *)reloadCellItems {
    if (![self.dataSource respondsToSelector:@selector(tabBarItemsForPagerTabBar:)]) return nil;
    NSMutableArray *items = NSMutableArray.array;
    [[self.dataSource tabBarItemsForPagerTabBar:self] enumerateObjectsUsingBlock:^(ZLTabBarCellItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZLTabBarCellModel *cellModel = [obj convertToCellModel];
        cellModel.items = items;
        cellModel.pagerTabBar = self;
        cellModel.isSelected = idx == self.currentIndex;
        cellModel.minInterItemSpacing = self.minInterItemSpacing;
        if (cellModel.cellClass) {
            [self.collectionView registerClass:cellModel.cellClass forCellWithReuseIdentifier:cellModel.cellReuseIdentifier];
        }
        if (cellModel.cellNib) {
            [self.collectionView registerNib:cellModel.cellNib forCellWithReuseIdentifier:cellModel.cellReuseIdentifier];
        }
        [items addObject:cellModel];
    }];
    return items;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = ZLRTLTabBarCollectionViewFlowLayout.new;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[ZLRTLTabBarCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = UIColor.whiteColor;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZLTabBarCell class] forCellWithReuseIdentifier:@"ZLTabBarCell"];
        collectionView.scrollEnabled = YES;
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:collectionView];
        UIEdgeInsets contentInset = self.contentInset;
        collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:contentInset.top],
            [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:contentInset.left],
            [collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-contentInset.bottom],
            [collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-contentInset.right]
        ]];
        
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (UIView *)selectedBar {
    if (!_selectedBar) {
        _selectedBar = [[UIView alloc] init];
        _selectedBar.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.5];
        [self.collectionView addSubview:self.selectedBar];

    }
    return _selectedBar;
}
- (UIView *)extraView {
    if (!_extraView) {
        _extraView = UIView.new;
        _extraView.backgroundColor = UIColor.redColor;
        [self.collectionView insertSubview:_extraView atIndex:0];
    }
    return _extraView;
}
- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    UICollectionView *collectionView = self.collectionView;
    [collectionView removeFromSuperview];
    [self removeConstraints:collectionView.constraints];
    [self addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor constant:contentInset.top],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:contentInset.left],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-contentInset.bottom],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-contentInset.right]
    ]];
    [self adjustTabBarViewLayout];
}
- (void)reloadTabBarView {
    self.items = nil;
    self.minInterItemSpacing = 0;
    self.items = [self reloadCellItems];
    [self adjustTabBarViewLayout];
}
- (void)adjustTabBarViewLayout {
    [self layoutIfNeeded];
    [self layoutSubviews];
    ZLTabBarViewAlignment alignment = self.innerAlignment;
    if (alignment == ZLTabBarViewAlignmentSpaceAround
        || alignment == ZLTabBarViewAlignmentSpaceEvenly
        || alignment == ZLTabBarViewAlignmentAutoFillEqualWidth) {
        __block CGFloat totalWidth = 0;
        [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.availableFillEqualWidth = 0;
            totalWidth +=  obj.getShowWidth;
        }];
        CGFloat minInterItemSpacing = self.minItemSpacing;
        CGFloat allSpace = (self.items.count - 1) * minInterItemSpacing;
        CGFloat sWidth = self.collectionView.bounds.size.width;
        if (totalWidth + allSpace < sWidth) {
            if (alignment == ZLTabBarViewAlignmentAutoFillEqualWidth) {
                CGFloat availableSpace = sWidth - allSpace;
                CGFloat itemWidth = availableSpace / self.items.count;
                __block BOOL isEqalueWidth = YES;
                [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.getShowWidth > itemWidth) {
                        isEqalueWidth = NO;
                        *stop = YES;
                    }
                }];
                if (isEqalueWidth) {
                    [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.availableFillEqualWidth = itemWidth;
                    }];
                }else {
                    //内部自动调整布局方式
                    self.innerAlignment = ZLTabBarViewAlignmentSpaceAround;
                    [self adjustTabBarViewLayout];
                    return;
                }
            }else {
                CGFloat availableSpace = sWidth - totalWidth;
                CGFloat interItemSpacing = availableSpace / (alignment == ZLTabBarViewAlignmentSpaceEvenly ? self.items.count + 1 : self.items.count);
                self.minInterItemSpacing = interItemSpacing;
            }
        }else {
            self.minInterItemSpacing = minInterItemSpacing;
        }
        [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.minInterItemSpacing = self.minInterItemSpacing;
        }];
        [self.collectionView reloadData];
    }else if (alignment == ZLTabBarViewAlignmentFillEqualWidth) {
        CGFloat minInterItemSpacing = self.minItemSpacing;
        CGFloat allSpace = (self.items.count - 1) * minInterItemSpacing;
        CGFloat sWidth = self.collectionView.bounds.size.width;
        CGFloat equalWidth = (sWidth - allSpace) / self.items.count;
        self.minInterItemSpacing = minInterItemSpacing;
        [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.availableFillEqualWidth = equalWidth;
            obj.minInterItemSpacing = self.minInterItemSpacing;
            obj.itemWidth = equalWidth;
            obj.selectItemWidth = equalWidth;
        }];
        [self.collectionView reloadData];
    }else {
        [self.collectionView reloadData];
    }
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!self.items || self.items.count < 1) self.items = [self reloadCellItems];
}

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated{
    self.currentIndex = index;
    UICollectionViewScrollPosition postion = UICollectionViewScrollPositionCenteredHorizontally;
    if (self.innerAlignment == ZLTabBarViewAlignmentStart) {
        postion = UICollectionViewScrollPositionLeft;
    } else if (self.innerAlignment == ZLTabBarViewAlignmentEnd) {
        postion = UICollectionViewScrollPositionRight;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:postion animated:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        UICollectionViewScrollPosition postion = UICollectionViewScrollPositionCenteredHorizontally;
        if (self.innerAlignment == ZLTabBarViewAlignmentStart) {
            postion = UICollectionViewScrollPositionLeft;
        } else if (self.innerAlignment == ZLTabBarViewAlignmentEnd) {
            postion = UICollectionViewScrollPositionRight;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:postion animated:animated];
    });
}
-(void)pagerTabBarUpdateIndicatorFromIndex:(NSInteger)fromIndex
                                   toIndex:(NSInteger)toIndex 
                                  animated:(BOOL)animated{
    if (self.shouldUpdateButtonBarView == NO) return;
    if (fromIndex > self.items.count - 1 || toIndex > self.items.count - 1 || fromIndex < 0 || toIndex < 0) {
        NSLog(@"Invalid index: fromIndex %ld, toIndex %ld, items count %lu", (long)fromIndex, (long)toIndex, (unsigned long)self.items.count);
        return;
    }
    ZLTabBarCellModel *fromItem = self.items[fromIndex];
    ZLTabBarCellModel *toItem = self.items[toIndex];
    [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    fromItem.isSelected = NO;
    toItem.isSelected = YES;
    [self adjustTabBarViewLayout];
    if (_selectedBar && !self.selectedBar.hidden && CGRectEqualToRect(self.selectedBar.frame, CGRectZero)) {
        [self updateIndicatorFromIndex:fromIndex toIndex:toIndex withProgressPercentage:1.0];
    }else {
        [UIView animateWithDuration:0.15 animations:^{
            [self updateIndicatorFromIndex:fromIndex toIndex:toIndex withProgressPercentage:1.0];
        }];
    }
   
    [self moveToIndex:toIndex animated:animated];

}
-(void)pagerTabUpdateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
                   indexWasChanged:(BOOL)indexWasChanged
                               animated:(BOOL)animated;

{
    if (toIndex < 0 || toIndex >= self.items.count) {
        //忽略边界
        progressPercentage = 1;
    }
    toIndex = MIN(self.items.count - 1,MAX(toIndex, 0));
    fromIndex = MIN(self.items.count - 1,MAX(fromIndex, 0));
    
    if (toIndex > self.currentIndex && toIndex - self.currentIndex > 1) {
        [self pagerTabBarUpdateIndicatorFromIndex:fromIndex toIndex:toIndex - 1 animated:animated];
    }
    if (toIndex < self.currentIndex && self.currentIndex - toIndex > 1) {
        [self pagerTabBarUpdateIndicatorFromIndex:fromIndex toIndex:toIndex + 1 animated:animated] ;
    }

    if (progressPercentage >= 1.0) {
        [self pagerTabBarUpdateIndicatorFromIndex:fromIndex toIndex:toIndex animated:animated];
    }else {
        [self updateIndicatorFromIndex:fromIndex toIndex:toIndex withProgressPercentage:progressPercentage];
    }
}
-(void)updateIndicatorFromIndex:(NSInteger)fromIndex
                        toIndex:(NSInteger)toIndex
         withProgressPercentage:(CGFloat)progressPercentage
{
    if (self.shouldUpdateButtonBarView == NO) return;
    toIndex = MIN(self.items.count - 1,MAX(toIndex, 0));
    fromIndex = MIN(self.items.count - 1,MAX(fromIndex, 0));
    ZLTabBarCellModel *fromItem = self.items[fromIndex];
    ZLTabBarCellModel *toItem = self.items[toIndex];
    CGFloat toWidth = toItem.itemWidth;
    if (toItem.selectedBarWidth != toItem.selectItemWidth) {
        toWidth = toItem.selectedBarWidth;
    }
    CGFloat newWidth = fromItem.selectedBarWidth + (toWidth - fromItem.selectedBarWidth) * progressPercentage;
    CGFloat newHeight = fromItem.selectedBarHeight + (toItem.selectedBarHeight - fromItem.selectedBarHeight) * progressPercentage;
    if (progressPercentage >= 1.0) {
        newWidth = toItem.selectedBarWidth;
    }
    if (toIndex == fromIndex) {
        newWidth = toItem.selectedBarWidth;
    }
    
    
    
    CGFloat fromFrameCenterX = fromItem.getCenterX;
    CGFloat toFrameCenterX = toItem.getCenterX;
    CGFloat newCenterX = fromFrameCenterX + (toFrameCenterX - fromFrameCenterX) * progressPercentage;
    
    UIEdgeInsets inset = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout insetForSectionAtIndex:0];
    newCenterX += inset.left;
    CGFloat collectionViewHeight = self.collectionView.frame.size.height;
    
    
     ZLTabBarCell *fromCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
     ZLTabBarCell *toCell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
     
     UIStackView *fromStackView = [fromCell.contentView viewWithTag:1001];
    ZLTabBarItemLabel *fromTitleLabel = [fromStackView viewWithTag:1002];
     
     UIStackView *toStackView = [toCell.contentView viewWithTag:1001];
    ZLTabBarItemLabel *toTitleLabel = [toStackView viewWithTag:1002];
     

    if (_selectedBar && !self.selectedBar.hidden) {
        CGFloat selectedBarVerticalOffset = fromItem.selectedBarVerticalOffset + (toItem.selectedBarVerticalOffset - fromItem.selectedBarVerticalOffset) * progressPercentage;
        self.selectedBar.frame = CGRectMake(0, 0, newWidth, newHeight );
        if (self.selectedBarAlignment == ZLSelectedBarAlignmentTopCenter) {
            self.selectedBar.center = CGPointMake(newCenterX,newHeight / 2.0 + selectedBarVerticalOffset);
        }else if (self.selectedBarAlignment == ZLSelectedBarAlignmentCenter) {
            self.selectedBar.center = CGPointMake(newCenterX,collectionViewHeight / 2.0 + selectedBarVerticalOffset);
        }else if (self.selectedBarAlignment == ZLSelectedBarAlignmentBottomCenter) {
            self.selectedBar.center = CGPointMake(newCenterX,collectionViewHeight - newHeight / 2.0 + selectedBarVerticalOffset);
        }
        if (self.selectedBar.layer.masksToBounds) {
            self.selectedBar.layer.cornerRadius = newHeight / 2.0;
        }else {
            self.selectedBar.layer.cornerRadius = 0;
        }
        self.selectedBar.backgroundColor = [self colorByInterpolatingFromColor:fromItem.selectedBarColor toColor:toItem.selectedBarColor percentage:progressPercentage];
    }
    if (_extraView && !_extraView.hidden) {
        CGFloat fromExtraViewWidth = fromItem.extraViewSize.width > 0 ? fromItem.extraViewSize.width : fromItem.getShowWidth;
        CGFloat toExtraViewWidth = toItem.extraViewSize.width > 0 ? toItem.extraViewSize.width : toItem.getShowWidth;
        CGFloat newExtraViewWidth = fromExtraViewWidth + (toExtraViewWidth - fromExtraViewWidth) * progressPercentage;
        CGFloat fromExtraViewHeight = fromItem.extraViewSize.height > 0 ? fromItem.extraViewSize.height : collectionViewHeight;
        CGFloat toExtraViewHeight = toItem.extraViewSize.height > 0 ? toItem.extraViewSize.height : collectionViewHeight;
        CGFloat newExtraViewHeight = fromExtraViewHeight + (toExtraViewHeight - fromExtraViewHeight) * progressPercentage;
        CGFloat cornerRadius = MIN(newExtraViewWidth, newExtraViewHeight) /2.0;
        if (self.extraView.layer.masksToBounds && self.extraView.layer.cornerRadius != cornerRadius) {
            self.extraView.layer.cornerRadius = cornerRadius;
        }
        self.extraView.frame = CGRectMake(0, 0, newExtraViewWidth, newExtraViewHeight);
        self.extraView.center = CGPointMake(newCenterX, collectionViewHeight/2.0);
        fromItem.extraViewColor ?: (fromItem.extraViewColor = _extraView.backgroundColor);
        toItem.extraViewColor ?: (toItem.extraViewColor = _extraView.backgroundColor);
        self.extraView.backgroundColor = [self colorByInterpolatingFromColor:fromItem.extraViewColor toColor:toItem.extraViewColor percentage:progressPercentage];
        if (self.isSegmentedControlStyle) {
            CGRect toTitleLabelFrame =  [self.collectionView convertRect:toTitleLabel.frame fromView:toTitleLabel];
            CGRect fromTitleLabelFrame = [self.collectionView convertRect:fromTitleLabel.frame fromView:fromTitleLabel];
            if (toIndex > fromIndex) {
                toItem.maskFrame = CGRectMake(0, 0,  CGRectGetMaxX(self.extraView.frame) - CGRectGetMinX(toTitleLabelFrame), toTitleLabel.frame.size.height);
                toTitleLabel.frontLabel.maskView.frame = toItem.maskFrame;
                toTitleLabel.frontLabel.textColor = toItem.selectedTitleColor;
                CGFloat fromTitleLabelWidth = CGRectGetMinX(self.extraView.frame) - CGRectGetMinX(fromTitleLabelFrame);
                fromItem.maskFrame = CGRectMake(fromTitleLabelWidth, 0, CGRectGetWidth(fromTitleLabel.frame) - fromTitleLabelWidth, fromTitleLabel.frame.size.height);
                fromTitleLabel.frontLabel.maskView.frame = fromItem.maskFrame;
                fromTitleLabel.frontLabel.textColor = fromItem.selectedTitleColor;
            }else if (toIndex < fromIndex) {
                fromItem.maskFrame = CGRectMake(0, 0,  CGRectGetMaxX(self.extraView.frame) - CGRectGetMinX(fromTitleLabelFrame), fromTitleLabel.frame.size.height);
                fromTitleLabel.frontLabel.maskView.frame = fromItem.maskFrame;
                fromTitleLabel.frontLabel.textColor = fromItem.selectedTitleColor;
                CGFloat toTitleLabelWidth = CGRectGetMaxX(toTitleLabelFrame) - CGRectGetMinX(self.extraView.frame);
                if (toTitleLabelWidth > 0) {
                    toItem.maskFrame = CGRectMake(CGRectGetWidth(toTitleLabelFrame) - toTitleLabelWidth, 0, toTitleLabelWidth, toTitleLabel.frame.size.height);
                    toTitleLabel.frontLabel.maskView.frame = toItem.maskFrame;
                    toTitleLabel.frontLabel.textColor = toItem.selectedTitleColor;
                }
            }
        }
    }
   
    if (fromTitleLabel) {
        if (fromItem.enableTextColorGradient) {
            fromTitleLabel.textColor = [self colorByInterpolatingFromColor:fromItem.selectedTitleColor toColor:fromItem.titleColor percentage:progressPercentage];
        }
        if (fromItem.enableTextFontGradient) {
            fromTitleLabel.font = [self transitionFontFromFont:fromItem.selectedTitleFont toFont:fromItem.titleFont withProgress:progressPercentage];
        }
    }
    
    if (toTitleLabel ) {
        if (toItem.enableTextColorGradient) {
            toTitleLabel.textColor = [self colorByInterpolatingFromColor:fromItem.titleColor toColor:toItem.selectedTitleColor percentage:progressPercentage];
        }
        if (toItem.enableTextFontGradient) {
            toTitleLabel.font = [self transitionFontFromFont:toItem.titleFont toFont:toItem.selectedTitleFont withProgress:progressPercentage];
        }
    }
}
- (UIColor *)colorByInterpolatingFromColor:(UIColor *)fromColor
                                   toColor:(UIColor *)toColor
                                percentage:(CGFloat)percentage {
    percentage = MAX(0.0, MIN(1.0, percentage));
    CGFloat fromRed, fromGreen, fromBlue, fromAlpha;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    CGFloat toRed, toGreen, toBlue, toAlpha;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    CGFloat red = fromRed + (toRed - fromRed) * percentage;
    CGFloat green = fromGreen + (toGreen - fromGreen) * percentage;
    CGFloat blue = fromBlue + (toBlue - fromBlue) * percentage;
    CGFloat alpha = fromAlpha + (toAlpha - fromAlpha) * percentage;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (UIFont *)transitionFontFromFont:(UIFont *)fromFont
                           toFont:(UIFont *)toFont
                    withProgress:(CGFloat)progress {
    // 确保progress在0-1之间
    progress = MAX(0, MIN(1, progress));
    
    // 获取字体大小
    CGFloat fromSize = fromFont.pointSize;
    CGFloat toSize = toFont.pointSize;
    CGFloat interpolatedSize = fromSize + (toSize - fromSize) * progress;
    
    // 获取字体名称 - 如果不同，根据progress选择
    NSString *interpolatedFontName;
    if ([fromFont.fontName isEqualToString:toFont.fontName] || progress < 0.5) {
        interpolatedFontName = fromFont.fontName;
    } else {
        interpolatedFontName = toFont.fontName;
    }
    
    // 获取字重
    CGFloat fromWeight = [self weightForFont:fromFont];
    CGFloat toWeight = [self weightForFont:toFont];
    CGFloat interpolatedWeight = fromWeight + (toWeight - fromWeight) * progress;
    
    // 创建新字体
    if (@available(iOS 8.2, *)) {
        // 使用UIFontWeight（iOS 8.2+）
        return [UIFont systemFontOfSize:interpolatedSize
                               weight:interpolatedWeight];
    } else {
        // 回退到简单实现（仅改变大小）
        return [UIFont fontWithName:interpolatedFontName
                              size:interpolatedSize];
    }
}
- (CGFloat)weightForFont:(UIFont *)font {
    if (@available(iOS 8.2, *)) {
        NSDictionary *traits = [font.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
        CGFloat weight = [traits[UIFontWeightTrait] floatValue];
        return weight ?: UIFontWeightRegular;
    }
    return UIFontWeightRegular;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLTabBarCellModel *item = self.items[indexPath.item];
    ZLTabBarCell *cell = nil;
    if (item.cellReuseIdentifier) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.cellReuseIdentifier forIndexPath:indexPath];
    }else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLTabBarCell" forIndexPath:indexPath];
        cell.model = item;
        cell.titleImageSpace = item.titleImageSpace;
        UIStackView *stackView = [cell.contentView viewWithTag:1001];
        ZLTabBarItemLabel *titleLabel = [stackView viewWithTag:1002];
        UIImageView *imageView = [stackView viewWithTag:1003];
        stackView.spacing = item.titleImageSpace;
        GMItemType type = item.itemType;
        if (item.isSelected) {
            if (type == GMItemTypeText || type == GMItemTypeTextImage) {
                if (item.selectTitle && item.selectTitle.length > 0) {
                    cell.titleLabel.textColor = item.selectedTitleColor;
                    if (self.isSegmentedControlStyle) {
                        cell.titleLabel.textColor = item.titleColor;
                        ((ZLTabBarItemLabel*)cell.titleLabel).frontLabel.textColor = item.selectedTitleColor;
                        ((ZLTabBarItemLabel*)cell.titleLabel).frontLabel.maskView.frame = CGRectMake(0, 0, item.getShowWidth, item.selectedTitleFont.lineHeight);
                    }
                    cell.titleLabel.font = item.selectedTitleFont;
                    cell.titleLabel.text = item.selectTitle;
                }else {
                    ZLTabBarItemLabel *label = (ZLTabBarItemLabel*)cell.titleLabel;
                    label.attributedText = item.selectAttributedText;
                    if (self.isSegmentedControlStyle) {
                        label.attributedText = item.attributedText;
                        label.frontLabel.attributedText = item.selectAttributedText;
                        label.frontLabel.maskView.frame = CGRectMake(0, 0, item.getShowWidth, item.selectAttributedText.size.height);
                    }
                }
            }
            if (type == GMItemTypeImage || type == GMItemTypeTextImage) {
                if (item.selectedImage) cell.imageView.image = item.selectedImage;
            }

        }else {
            if (type == GMItemTypeText || type == GMItemTypeTextImage) {
                if (item.title && item.title.length > 0) {
                    cell.titleLabel.textColor = item.titleColor;
                    if (self.isSegmentedControlStyle) {
                        ((ZLTabBarItemLabel*)cell.titleLabel).frontLabel.textColor = item.titleColor;
                        ((ZLTabBarItemLabel*)cell.titleLabel).frontLabel.maskView.frame = item.maskFrame;
                    }
                    cell.titleLabel.text = item.title;
                    cell.titleLabel.font = item.titleFont;
                }else {
                    ZLTabBarItemLabel *label = (ZLTabBarItemLabel*)cell.titleLabel;
                    label.attributedText = item.attributedText;
                    if (self.isSegmentedControlStyle) {
                        label.attributedText = item.attributedText;
                        label.frontLabel.attributedText = item.attributedText;
                        label.frontLabel.maskView.frame = CGRectMake(0, 0, item.getShowWidth, item.attributedText.size.height);
                    }
                }
            }
            if (type == GMItemTypeImage || type == GMItemTypeTextImage) {
                if (item.image) cell.imageView.image = item.image;
            }
        }
    }
    if (!CGSizeEqualToSize(item.separatorViewSize, CGSizeZero)) {
        item.separatorView.hidden = NO;
        if (!item.separatorView.superview) [collectionView addSubview:item.separatorView];
        if (indexPath.item < self.items.count - 1) {
            ZLTabBarCellModel *nextItem = self.items[indexPath.item + 1];
            CGSize size = item.separatorViewSize;
            UIEdgeInsets inset = [self collectionView:self.collectionView layout:self.collectionView.collectionViewLayout insetForSectionAtIndex:0];
            item.separatorView.frame = CGRectMake((nextItem.getMinX - item.getMaxX - size.width) / 2.0 + item.getMaxX + inset.left, (CGRectGetHeight(collectionView.frame) - size.height)/2.0, size.width,size.height);
        }
    }
    if (_extraView && ![self.extraView isEqual:self.collectionView.subviews.firstObject]) {
        [self.collectionView insertSubview:self.extraView belowSubview:self.collectionView.subviews.firstObject];
    }
    if ([self.delegate respondsToSelector:@selector(pagerTabBar:configureCell:item:forIndex:)]) {
        [self.delegate pagerTabBar:self configureCell:cell item:item.cellItem forIndex:indexPath.item];
    }
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLTabBarCellModel *toItem = self.items[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(pagerTabBar:shouldSelectItem:index:)]) {
        if (![self.delegate pagerTabBar:self shouldSelectItem:toItem.cellItem index:indexPath.item]) {
            return; // 如果代理方法返回NO，则不进行选择
        }
    }
    
    ZLTabBarCellModel *fromItem = self.items[self.currentIndex];
    fromItem.isSelected = NO;
    toItem.isSelected = YES;
    if ([self.delegate respondsToSelector:@selector(pagerTabBar:didSelectItem:index:)]) {
        [self.delegate pagerTabBar:self didSelectItem:toItem.cellItem index:indexPath.item];
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLTabBarCellModel *item = self.items[indexPath.item];
    CGFloat height = collectionView.bounds.size.height;
    return CGSizeMake(item.getShowWidth, height > 0 ? height : 44);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.minInterItemSpacing;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.minInterItemSpacing;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    ZLTabBarViewAlignment alignment = self.innerAlignment;
    if (alignment == ZLTabBarViewAlignmentSpaceEvenly) {
        return UIEdgeInsetsMake(0, self.minInterItemSpacing, 0, self.minInterItemSpacing);
    }else if (alignment == ZLTabBarViewAlignmentSpaceAround){
        return UIEdgeInsetsMake(0, self.minInterItemSpacing/2.0, 0, self.minInterItemSpacing / 2.0);
    }else if (alignment == ZLTabBarViewAlignmentAutoFillEqualWidth){
        return UIEdgeInsetsZero;
    }else if (alignment == ZLTabBarViewAlignmentFillEqualWidth){
        return UIEdgeInsetsZero;
    };

    CGFloat totalWidth = 0;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)collectionViewLayout;
    UIEdgeInsets sectionInset = layout.sectionInset;
    for (ZLTabBarCellModel *item in self.items) totalWidth += item.getShowWidth;
    totalWidth += (self.items.count - 1) * self.minInterItemSpacing; // space between items
    CGFloat cWidth = collectionView.bounds.size.width;
    if (totalWidth < cWidth) {
        if (alignment == ZLTabBarViewAlignmentCenter) {
            CGFloat leftInset = (cWidth - totalWidth) / 2.0;
            return UIEdgeInsetsMake(sectionInset.top, leftInset + sectionInset.left, sectionInset.bottom, leftInset + sectionInset.right) ;
        }else if (alignment == ZLTabBarViewAlignmentEnd) {
            return UIEdgeInsetsMake(sectionInset.left, cWidth - totalWidth + sectionInset.left, sectionInset.bottom, sectionInset.right);
        }
    }
    return sectionInset;
}
@end
