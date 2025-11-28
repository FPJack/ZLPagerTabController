//
//  ZLTabBarCellItem.m
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import "ZLTabBarCellItem.h"

@implementation ZLTabBarCellItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.leftRightMargin = 20;
        self.titleFont = [UIFont systemFontOfSize:16];
    }
    return self;
}
- (ZLTabBarCellModel *)convertToCellModel {
    ZLTabBarCellModel *item = ZLTabBarCellModel.new;
    ZLTabBarCellItem *barItem = self;
    item.cellItem = barItem;
    
    item.itemWidth = barItem.itemWidth;
    item.attributedText = barItem.attributedText;
    item.selectAttributedText = barItem.selectAttributedText;
    item.selectItemWidth = barItem.selectItemWidth;
    item.itemWidthMode = barItem.itemWidthMode;
    item.title = barItem.title;
    item.selectTitle = barItem.selectTitle;
    item.image = barItem.image;
    item.selectedImage = barItem.selectedImage;
    item.titleFont = barItem.titleFont;
    item.selectedTitleFont = barItem.selectedTitleFont;
    item.titleColor = barItem.titleColor;
    item.selectedTitleColor = barItem.selectedTitleColor;
    item.titleImageSpace = barItem.titleImageSpace;
    item.leftRightMargin = barItem.leftRightMargin;
    item.selectedBarWidth = barItem.selectedBarWidth;
    item.selectedBarHeight = barItem.selectedBarHeight;
    item.selectedBarHorizontalPadding = barItem.selectedBarHorizontalPadding;
    item.selectedBarColor = barItem.selectedBarColor;
    item.enableTextFontGradient = barItem.enableTextFontGradient;
    item.enableTextColorGradient = barItem.enableTextColorGradient;
    item.selectedBarVerticalOffset = barItem.selectedBarVerticalOffset;
    item.cellReuseIdentifier = barItem.cellReuseIdentifier;
    item.cellClass = barItem.cellClass;
    item.cellNib = barItem.cellNib;
    item.separatorViewSize = barItem.separatorViewSize;
    item.extraViewColor = barItem.extraViewColor;
    item.extraViewSize = barItem.extraViewSize;
    if (!CGSizeEqualToSize(barItem.separatorViewSize, CGSizeZero)) {
        item.separatorView = barItem.separatorView;
    }
    return item;
}
- (UIView *)separatorView {
    if (!_separatorView) {
        _separatorView = UIView.new;
        if (@available(iOS 13.0, *)) {
            _separatorView.backgroundColor = [UIColor separatorColor];
        } else {
            // Fallback on earlier versions
        }
        _separatorView.hidden = YES;
    }
    return _separatorView;
}
@end
@interface ZLTabBarCellModel()
@property (nonatomic,assign)CGFloat attributedTextWidth;
@property (nonatomic,assign)CGFloat selectAttributedTextWidth;
@property (nonatomic,assign)CGFloat titleWidth;
@property (nonatomic,assign)CGFloat selectTitleWidth;
@end
@implementation ZLTabBarCellModel
- (UIFont *)titleFont {
    if (!self.cellItem.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:16];
    }
    return _titleFont;
}
- (CGFloat)attributedTextWidth {
    if (!self.attributedText || self.attributedText.length == 0) return 0;
    if (_attributedTextWidth <= 0) {
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        CGRect textRect = [self.attributedText boundingRectWithSize:maxSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                          context:nil];
        _attributedTextWidth = ceil(CGRectGetWidth(textRect));

    }
    return _attributedTextWidth;
}
- (CGFloat)selectAttributedTextWidth {
    if (!self.selectAttributedText || self.selectAttributedText.length == 0) return 0;
    if (_selectAttributedTextWidth <= 0) {
        CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        CGRect textRect = [self.selectAttributedText boundingRectWithSize:maxSize
        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        context:nil];
        _selectAttributedTextWidth = ceil(CGRectGetWidth(textRect));
    }
    return _selectAttributedTextWidth;
}
- (CGFloat)titleWidth {
    if (!self.title || self.title.length == 0) return 0;
    if (_titleWidth <= 0) {
        NSDictionary *attributes = @{NSFontAttributeName: self.titleFont};
        CGSize textSize = [self.title sizeWithAttributes:attributes];
        _titleWidth = ceil(textSize.width);
    }
    return _titleWidth;
}
- (CGFloat)selectTitleWidth {
    if (!self.selectTitle || self.selectTitle.length == 0) return 0;
    if (_selectTitleWidth <= 0) {
        NSDictionary *attributes = @{NSFontAttributeName: self.selectedTitleFont};
        CGSize textSize = [self.selectTitle sizeWithAttributes:attributes];
        _selectTitleWidth = ceil(textSize.width);
    }
    return _selectTitleWidth;
}

- (CGFloat)itemWidth {
    if (self.itemWidthMode == GMItemWidthModeUseSelected) return  self.selectItemWidth;
    
    if (self.cellItem.itemWidth <= 0) {
            CGFloat itemWidth = self.titleWidth > 0 ? self.titleWidth : self.attributedTextWidth;
            if (itemWidth > 0) {
                _itemWidth += (self.titleImageSpace + itemWidth);
            }
            _itemWidth += self.image.size.width;
    }
    return _itemWidth > 0 ? _itemWidth : 50.0;
}
- (CGFloat)titleImageSpace {
    if (_titleImageSpace <= 0) {
        _titleImageSpace = 5.0;
        if (!self.image || !self.selectedImage) {
            _titleImageSpace = 0;
        }else {
            _titleImageSpace = 5;
        }
    }
    return _titleImageSpace;
}
- (CGFloat)selectItemWidth {
    if (self.itemWidthMode == GMItemWidthModeUseNormal) return  self.itemWidth;
    
    if (_selectItemWidth <= 0) {
            CGFloat selectItemWidth = self.selectTitleWidth > 0 ? self.selectTitleWidth : self.selectAttributedTextWidth;
            if (selectItemWidth > 0) {
                _selectItemWidth += (self.titleImageSpace + selectItemWidth);
            }
            _selectItemWidth += self.selectedImage.size.width;
    }
    return _selectItemWidth > 0 ? _selectItemWidth : 50.0;
}
- (NSAttributedString *)selectAttributedText {
    if (!_selectAttributedText) {
        _selectAttributedText = self.attributedText;
        
    }
    return _selectAttributedText;
}
- (NSString *)selectTitle {
    if (!_selectTitle) {
        _selectTitle = self.title;
    }
    return _selectTitle;
}
- (UIColor *)titleColor {
    if (!_titleColor) {
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}
- (UIColor *)selectedTitleColor {
    if (!_selectedTitleColor) {
        _selectedTitleColor = self.titleColor;
    }
    return _selectedTitleColor;
}
- (UIImage *)selectedImage {
    if (!_selectedImage) {
        _selectedImage = self.image;
    }
    return _selectedImage;
}
- (UIFont *)selectedTitleFont {
    if (!_selectedTitleFont) {
        _selectedTitleFont = self.titleFont;
    }
    return _selectedTitleFont;
}
- (CGFloat)selectedBarWidth {
    if (_selectedBarWidth <= 0) {
        _selectedBarWidth =  self.selectItemWidth;
        _selectedBarWidth += self.selectedBarHorizontalPadding * 2;
    }
    return _selectedBarWidth;
}
- (CGFloat)selectedBarHeight {
    if (_selectedBarHeight <= 0) {
        _selectedBarHeight = 2.0;
    }
    return _selectedBarHeight;
}
- (UIColor *)selectedBarColor {
    if (_selectedBarColor <= 0) {
        _selectedBarColor = self.selectedTitleColor;
    }
    return _selectedBarColor;
}
- (NSString *)cellReuseIdentifier {
    if (!_cellReuseIdentifier) {
        _cellReuseIdentifier = NSStringFromClass(self.cellClass);
    }
    return _cellReuseIdentifier;
}
- (CGFloat)getMinX {
    __block CGFloat x = 0;
    [self.items enumerateObjectsUsingBlock:^(ZLTabBarCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self]) {
            x += obj.getShowWidth;
            x += self.minInterItemSpacing;
        }else {
            *stop = YES;
        }
    }];
    return x;
}
- (CGFloat)getMaxX {
    return self.getMinX + self.getShowWidth;
}
- (CGFloat)getCenterX {
    return self.getMinX + self.getShowWidth / 2.0;
}
- (CGFloat)getShowWidth {
    return self.availableFillEqualWidth > 0 ? self.availableFillEqualWidth : (self.isSelected ? self.selectItemWidth : self.itemWidth) + self.leftRightMargin;
}
- (CGFloat)leftRightMargin {
    if(self.isSelected) {
        if (self.itemWidthMode == GMItemWidthModeUseNormal) {
            if (self.cellItem.itemWidth > 0) {
                return 0;
            }
        }
        if (self.cellItem.selectItemWidth > 0) {
            return 0;
        }
    }else {
        if (self.itemWidthMode == GMItemWidthModeUseSelected) {
            if (self.cellItem.selectItemWidth > 0) {
                return 0;
            }
        }
        if (self.cellItem.itemWidth > 0) {
            return 0;
        }
    }
    return _leftRightMargin;
}
- (GMItemType)itemType {
    BOOL isText = (self.selectTitle ?: @"").length > 0 || self.selectAttributedText;
    BOOL isImage = self.selectedImage != nil;
    BOOL isTextImage = isText && isImage;
    if (isTextImage) {
        return GMItemTypeTextImage;
    }else if (isText) {
        return GMItemTypeText;
    }else if (isImage) {
        return GMItemTypeImage;
    }
    return GMItemTypeUnknown;
}
- (void)dealloc
{
    [self.separatorView removeFromSuperview];
}
@end

