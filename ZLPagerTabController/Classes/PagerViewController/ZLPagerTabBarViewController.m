//
//  ZLPagerTabBarViewController.m
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import "ZLPagerTabBarViewController.h"
@interface ZLPagerTabBarViewController ()
@property (nonatomic,strong,readwrite)NSArray<UIViewController<ZLPagerTabBarChildItem> *> *pagerChildViewControllers;
@end
@implementation ZLPagerTabBarViewController
@synthesize pagerChildViewControllers = _pagerChildViewControllers;
@synthesize  dataSource = _dataSource;
@synthesize  delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isProgressiveIndicator = YES;
    self.skipIntermediateViewControllers = YES;
    [self.view addSubview:self.tabBarView];
    [self updateContainerScrollViewFrame];
}
- (ZLPagerTabBar *)tabBarView {
    if (!_tabBarView) {
        if ([self.delegate respondsToSelector:@selector(tabBarViewFrameForPagerViewController:)]) {
            _tabBarView = [[ZLPagerTabBar alloc] initWithFrame:[self.delegate tabBarViewFrameForPagerViewController:self]];
        }else {
            _tabBarView = [[ZLPagerTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        }
        _tabBarView.dataSource = self;
        _tabBarView.delegate = self;
    }
    return _tabBarView;
}

- (void)updateContainerScrollViewFrame {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(self.tabBarView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.tabBarView.frame));
    self.containerScrollView.frame = rect;
}
- (void)setPagerChildViewControllers:(NSArray<UIViewController<ZLPagerTabBarChildItem> *> *)pagerChildViewControllers {

    _pagerChildViewControllers = pagerChildViewControllers;
    if (!self.tabBarView.superview) return;
    if ([self.delegate respondsToSelector:@selector(tabBarViewFrameForPagerViewController:)]) {
        self.tabBarView.frame = [self.delegate tabBarViewFrameForPagerViewController:self];
        [self updateContainerScrollViewFrame];
    }
    [self.tabBarView reloadTabBarView];
}
#pragma mark - ZLPagerTabBarDataSource
- (NSArray<ZLTabBarCellItem *> *)tabBarItemsForPagerTabBar:(ZLPagerTabBar *)pagerTabBar {
    NSMutableArray *items = [NSMutableArray array];
    [self.pagerChildViewControllers enumerateObjectsUsingBlock:^(UIViewController<ZLPagerTabBarChildItem> * _Nonnull childVC, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL sel = @selector(pagerViewController:forIndex:);
        if ([childVC respondsToSelector:sel]) {
            [items addObject:[childVC pagerViewController:self forIndex:idx]];
        }else if ([self.delegate respondsToSelector:sel]){
            [items addObject:[self.delegate pagerViewController:self forIndex:idx]];
        }else {
            NSString *message = [NSString stringWithFormat:@"%@或者%@需要实现ZLPagerTabBarChildItem协议里面的pagerViewController:forIndex: 这个方法",NSStringFromClass(childVC.class),NSStringFromClass(self.delegate.class)];
            NSAssert(NO, message);
        }
    }];
    return items;
}
#pragma mark ZLPagerTabBarViewControllerDelegate
- (BOOL)pagerViewController:(ZLPagerViewController *)pagerViewController shouldSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index {
    return YES;
}
- (void)pagerViewController:(ZLPagerViewController *)pagerViewController didSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index {
}
- (CGRect)tabBarViewFrameForPagerViewController:(ZLPagerViewController *)pagerViewController {
    return CGRectMake(0, 0, self.view.bounds.size.width, 44);
}
#pragma mark - ZLPagerTabBarDelegate
- (void)pagerTabBar:(ZLPagerTabBar *)pagerTabBar didSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index {
    [self moveToViewControllerAtIndex:index animated:YES];
    [self pagerViewController:self didSelectItem:item index:index];
}
- (BOOL)pagerTabBar:(ZLPagerTabBar *)pagerTabBar shouldSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index {
    return [self pagerViewController:self shouldSelectItem:item index:index];
}
- (void)pagerTabBar:(ZLPagerTabBar *)tabBarView configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index {
    UIViewController<ZLPagerTabBarChildItem> *vc = self.pagerChildViewControllers[index];
    SEL sel = @selector(pagerViewController:configureCell:item:forIndex:);
    if ([vc respondsToSelector:sel]) {
        [vc pagerViewController:self configureCell:cell item:item forIndex:index];
    }else if ([self.delegate respondsToSelector:sel]) {
        [self.delegate pagerViewController:self configureCell:cell item:item forIndex:index];
    }
}


#pragma mark - ZLPagerViewControllerDelegate
- (void)pagerViewController:(ZLPagerViewController *)pagerViewController updateFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self.tabBarView pagerTabBarUpdateIndicatorFromIndex:fromIndex toIndex:toIndex animated:fromIndex != toIndex];
}
- (void)pagerViewController:(ZLPagerViewController *)pagerViewController updateFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progressPercentage:(CGFloat)progressPercentage indexWasChanged:(BOOL)indexWasChanged {
    [self.tabBarView pagerTabUpdateIndicatorFromIndex:fromIndex toIndex:toIndex withProgressPercentage:progressPercentage indexWasChanged:indexWasChanged animated:fromIndex != toIndex];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.delegate respondsToSelector:@selector(tabBarViewFrameForPagerViewController:)]) {
        CGRect frame = [self.delegate tabBarViewFrameForPagerViewController:self];
        if (!CGRectEqualToRect(self.tabBarView.frame, frame)) {
            self.tabBarView.frame = frame;
            [self.tabBarView reloadTabBarView];
        }
    }
}
@end
