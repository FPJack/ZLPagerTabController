//
//  ZLNavTabBarViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLNavTabBarViewController.h"

@interface ZLNavTabBarViewController ()

@end

@implementation ZLNavTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.tabBarView.backgroundColor = UIColor.lightGrayColor;
    [self.navigationController.navigationBar addSubview:self.tabBarView];
    [self updateTabBarViewFrameInNavigationBar];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.containerScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    //折叠屏展开/折叠、旋转后导航栏宽度会变，不能用写死的 frame
    [self updateTabBarViewFrameInNavigationBar];
}
- (void)updateTabBarViewFrameInNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (self.tabBarView.superview != navigationBar) return;
    CGFloat horizontalMargin = 80;
    CGFloat height = 40;
    CGRect frame = CGRectMake(horizontalMargin,
                              (CGRectGetHeight(navigationBar.bounds) - height) / 2.0,
                              MAX(CGRectGetWidth(navigationBar.bounds) - horizontalMargin * 2, 0),
                              height);
    if (!CGRectEqualToRect(self.tabBarView.frame, frame)) {
        self.tabBarView.frame = frame;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tabBarView removeFromSuperview];
}
- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.titleColor = UIColor.redColor;
    item.selectedTitleColor = UIColor.blueColor;
    item.extraViewSize = CGSizeMake(0, 30);
    return item;
}
@end
