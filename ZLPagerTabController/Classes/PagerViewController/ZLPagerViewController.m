//
//  ZLPagerViewController.m
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import "ZLPagerViewController.h"
@interface GMPagerScrollView : UIScrollView<UIGestureRecognizerDelegate>
@property (nonatomic,weak)ZLPagerViewController *pagerViewController;
@end
@implementation GMPagerScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.panGestureRecognizer.delegate = self;
    }
    return self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.pagerViewController.enableBoundaryBounce) return YES;
    NSString *className = NSStringFromClass(gestureRecognizer.class);
    if ([gestureRecognizer isEqual:self.panGestureRecognizer] &&
        [className isEqualToString:@"UIScrollViewPanGestureRecognizer"]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        NSInteger count = self.pagerViewController.pagerChildViewControllers.count;
        if (count <=  1) return NO;
        NSInteger idx = self.pagerViewController.currentIndex;
        if (idx == 0 && velocity.x > 0) return NO;
        if (idx == count - 1 && velocity.x < 0) return NO;
    }
    return YES;
}
@end

@interface ZLPagerViewController ()
@property (nonatomic,assign)CGSize lastSize;
@property (nonatomic,assign)CGFloat lastContentOffset;
@property (nonatomic,assign,readwrite)NSInteger currentIndex;
///解决第一次添加子控制器时，viewDidAppear会被调用两次的问题
@property (nonatomic,assign)BOOL isFirstAddChildViewController;
/// 每页页面宽度
@property (nonatomic,assign,readonly)CGFloat pageWidth;

@property (nonatomic,strong)NSArray<UIViewController *> *tempPagerChildViewControllers;
@property (nonatomic,strong,readwrite)NSArray<UIViewController *> *pagerChildViewControllers;

@end

@implementation ZLPagerViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self.view addSubview:self.containerScrollView];
    if (self.dataSource) {
        self.pagerChildViewControllers = [self.dataSource childViewControllersForPagerViewController:self];
    }
   
}
- (void)initialize {
    self.isFirstAddChildViewController = YES;
    self.currentIndex = 0;
    self.lastContentOffset = 0.0f;
    self.dataSource = self;
    self.delegate = self;
}
- (UIScrollView *)containerScrollView {
    if (!_containerScrollView) {
        GMPagerScrollView *scrollView = [[GMPagerScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.clipsToBounds = YES;
        scrollView.bounces = YES;
        scrollView.pagerViewController = self;
        [scrollView setAlwaysBounceHorizontal:YES];
        [scrollView setAlwaysBounceVertical:NO];
        scrollView.scrollsToTop = NO;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
        _containerScrollView = scrollView;
    }
    return _containerScrollView;
}
- (NSArray<UIViewController *> *)tempPagerChildViewControllers {
    return _tempPagerChildViewControllers  ? _tempPagerChildViewControllers : self.pagerChildViewControllers;
}
- (UISemanticContentAttribute)semanticContentAttribute {
    return UIView.appearance.semanticContentAttribute;
}
- (CGFloat)pageWidth {
    return self.containerScrollView.bounds.size.width;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.lastSize = self.containerScrollView.bounds.size;
    [self updateChildViewsIfNeed];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGAffineTransform transform = self.semanticContentAttribute == UISemanticContentAttributeForceRightToLeft ? CGAffineTransformMakeScale(-1, 1) : CGAffineTransformIdentity;
    if (!CGAffineTransformEqualToTransform(transform, self.containerScrollView.transform)) {
        self.containerScrollView.transform = CGAffineTransformMakeScale(-1, 1);
    }
    [self updateChildViewsIfNeed];
}
-(void)moveToViewControllerAtIndex:(NSInteger)index{
    [self moveToViewControllerAtIndex:index animated:YES];
}
-(void)moveToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated{
    if (!self.isViewLoaded || !self.view.window || index < 0 || index >= self.pagerChildViewControllers.count) {
        self.currentIndex = index;
        return;
    }
    
    CGFloat offset = [self pageOffsetForChildIndex:index];
    if (animated && self.skipIntermediateViewControllers && ABS(self.currentIndex - index) > 1) {
        NSMutableArray * tempChildViewControllers = [NSMutableArray arrayWithArray:self.pagerChildViewControllers];
        UIViewController *currentChildVC = [self.pagerChildViewControllers objectAtIndex:self.currentIndex];
        NSInteger fromIndex = (self.currentIndex < index) ? index - 1 : index + 1;
        UIViewController *fromChildVC = [self.pagerChildViewControllers objectAtIndex:fromIndex];
        [tempChildViewControllers setObject:fromChildVC atIndexedSubscript:self.currentIndex];
        [tempChildViewControllers setObject:currentChildVC atIndexedSubscript:fromIndex];
        _tempPagerChildViewControllers = tempChildViewControllers;
        if (self.navigationController){
            self.navigationController.view.userInteractionEnabled = NO;
        }
        else{
            self.view.userInteractionEnabled = NO;
        }
       
        [self.containerScrollView setContentOffset:CGPointMake([self pageOffsetForChildIndex:fromIndex], 0) animated:NO];
        [self.containerScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }else {
        [self.containerScrollView setContentOffset:CGPointMake(offset, 0) animated:animated];
    }
}
-(void)moveToViewController:(UIViewController *)viewController{
    [self moveToViewController:viewController animated:YES];
}
-(void)moveToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSInteger index = [self.pagerChildViewControllers indexOfObject:viewController];
    [self moveToViewControllerAtIndex:index animated:animated];
}
///把某个控制器从父视图移除
- (void)removeFromParentVC:(UIViewController *)viewController {
    if ([viewController parentViewController]){
        [viewController willMoveToParentViewController:nil];
        [viewController beginAppearanceTransition:NO animated:NO];
        [viewController.view removeFromSuperview];
        [viewController endAppearanceTransition];
        [viewController removeFromParentViewController];
    }
}
-(void)reloadPagerTabStripView
{
    if ([self isViewLoaded]){
        [self.pagerChildViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController * childVC = (UIViewController *)obj;
            [self removeFromParentVC:childVC];
        }];
        self.pagerChildViewControllers = self.dataSource ? [self.dataSource childViewControllersForPagerViewController:self] : @[];
        self.containerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.containerScrollView.bounds) * self.pagerChildViewControllers.count, self.containerScrollView.contentSize.height);
        if (self.currentIndex >= self.pagerChildViewControllers.count){
            self.currentIndex = self.pagerChildViewControllers.count - 1;
        }
        [self.containerScrollView setContentOffset:CGPointMake([self pageOffsetForChildIndex:self.currentIndex], 0)  animated:NO];
        [self updateChildViews];
    }
}

- (CGFloat)pageOffsetForChildIndex:(NSInteger)index {
    if (CGRectGetWidth(self.containerScrollView.bounds) > CGRectGetWidth(self.view.bounds)){
        return (index * CGRectGetWidth(self.containerScrollView.bounds) + ((CGRectGetWidth(self.containerScrollView.bounds) - CGRectGetWidth(self.view.bounds)) * 0.5));
    }
    return (index * CGRectGetWidth(self.containerScrollView.bounds));
}
- (BOOL)isVisibleChildViewControllerAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.tempPagerChildViewControllers.count) {
        return NO;
    }
    CGFloat offsetForChild = [self pageOffsetForChildIndex:index];
    BOOL isVisible = fabs(self.containerScrollView.contentOffset.x - offsetForChild) < CGRectGetWidth(self.containerScrollView.bounds);
    return isVisible;
}
- (void)updateChildViewsIfNeed {
    if (!CGSizeEqualToSize(self.lastSize, self.containerScrollView.bounds.size)) {
        [self updateChildViews];
    }
}
- (void)updateChildViews {
    if (!CGSizeEqualToSize(self.lastSize, self.containerScrollView.bounds.size)) {
        if (self.lastSize.width != self.containerScrollView.bounds.size.width){
            if (self.currentIndex >= 0 && self.currentIndex < self.pagerChildViewControllers.count) {
                [self.containerScrollView setContentOffset:CGPointMake([self pageOffsetForChildIndex:self.currentIndex], 0) animated:NO];
            }
        }
    }
    
    self.lastSize = self.containerScrollView.bounds.size;
    NSArray * childViewControllers = self.tempPagerChildViewControllers;
    self.containerScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.containerScrollView.frame) * childViewControllers.count, self.containerScrollView.contentSize.height);
    if (childViewControllers.count <= 0) return;
    [childViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull childVC, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isVisibleChildViewControllerAtIndex:idx]) {
            CGFloat childPosition = [self pageOffsetForChildIndex:idx];
            if (childVC.parentViewController) {
                [childVC.view setFrame:CGRectMake(childPosition, 0, MIN(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.containerScrollView.bounds)), CGRectGetHeight(self.containerScrollView.bounds))];
                childVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            }else {
                [childVC  willMoveToParentViewController:self];
                [self addChildViewController:childVC];
                [childVC.view setFrame:CGRectMake(childPosition, 0, MIN(CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.containerScrollView.bounds)), CGRectGetHeight(self.containerScrollView.bounds))];
                childVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                CGAffineTransform transform = self.semanticContentAttribute == UISemanticContentAttributeForceRightToLeft ? CGAffineTransformMakeScale(-1, 1) : CGAffineTransformIdentity;
                if (!CGAffineTransformEqualToTransform(transform, childVC.view.transform)) {
                    childVC.view.transform = CGAffineTransformMakeScale(-1, 1);
                }
                [childVC didMoveToParentViewController:self];
                [childVC beginAppearanceTransition:YES animated:NO];
                [self.containerScrollView addSubview:childVC.view];
                //标签嵌套使用的时候这行至关重要
                [self.view layoutIfNeeded];
                if (!self.isFirstAddChildViewController) {
                    [childVC endAppearanceTransition];
                }
                self.isFirstAddChildViewController = NO;
            }
        }else {
            [self removeFromParentVC:childVC];
        }
    }];
    
    NSInteger oldCurrentIndex = self.currentIndex;
    NSInteger newCurrentIndex = (self.containerScrollView.contentOffset.x + 1.5 * self.pageWidth) / self.pageWidth - 1;
    NSInteger childsCount = childViewControllers.count;
    newCurrentIndex = MIN(MAX(newCurrentIndex, 0), childsCount - 1);
    self.currentIndex = newCurrentIndex;
    if (self.isProgressiveIndicator) {
        if ([self.delegate respondsToSelector:@selector(pagerViewController:updateFromIndex:toIndex:progressPercentage:indexWasChanged:)]) {
            CGFloat percentage = [self scrollPercentage];
            CGFloat currentOffset = self.containerScrollView.contentOffset.x;
            NSInteger fromIndex = self.currentIndex;
            NSInteger toIndex = self.currentIndex;
            if (currentOffset > self.lastContentOffset) {
                //向右滑动
                if (percentage >= 0.5) {
                    fromIndex = newCurrentIndex - 1;
                    fromIndex = MAX(fromIndex, 0);
                }else {
                    toIndex = fromIndex + 1;
                }
            }else if (currentOffset < self.lastContentOffset) {
                //向左滑动
                if (percentage > 0.5) {
                    fromIndex = MIN(fromIndex + 1, childsCount);
                }else {
                    toIndex = fromIndex - 1;
                }
            }
            [self.delegate pagerViewController:self updateFromIndex:fromIndex toIndex:toIndex progressPercentage:percentage indexWasChanged:oldCurrentIndex != newCurrentIndex];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(pagerViewController:updateFromIndex:toIndex:)]) {
            if (oldCurrentIndex != self.currentIndex) {
                [self.delegate pagerViewController:self updateFromIndex:oldCurrentIndex toIndex:self.currentIndex];
            }
        }
    }
}
-(CGFloat)scrollPercentage
{
    CGFloat pageWidth = self.pageWidth;
    //向左滑动
    if (self.containerScrollView.contentOffset.x > self.lastContentOffset) {
        if (fmodf(self.containerScrollView.contentOffset.x, pageWidth) == 0.0) {
            return 1.0;
        }
        return fmodf(self.containerScrollView.contentOffset.x, pageWidth) / pageWidth;
    }
    return 1 - fmodf(self.containerScrollView.contentOffset.x >= 0 ? self.containerScrollView.contentOffset.x : pageWidth + self.containerScrollView.contentOffset.x, pageWidth) / pageWidth;
}
- (nonnull NSArray<UIViewController *> *)childViewControllersForPagerViewController:(nonnull ZLPagerViewController *)pagerTabVC {
   
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.containerScrollView]) {
        [self updateChildViews];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.containerScrollView]) {
        self.lastContentOffset = scrollView.contentOffset.x;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.containerScrollView]) {
        [self updateChildViews];
        self.tempPagerChildViewControllers = nil;
        if (self.navigationController){
            self.navigationController.view.userInteractionEnabled = YES;
        }
        else{
            self.view.userInteractionEnabled = YES;
        }
    }
}
- (void)addedToParentViewController:(UIViewController *)parentViewController {
    [self  willMoveToParentViewController:parentViewController];
    [parentViewController addChildViewController:self];
    [self.view setFrame:parentViewController.view.bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self didMoveToParentViewController:parentViewController];
    [self beginAppearanceTransition:YES animated:NO];
    [parentViewController.view addSubview:self.view];
    [parentViewController.view layoutIfNeeded];
    [self endAppearanceTransition];

}
@end
