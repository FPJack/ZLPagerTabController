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
    self.tabBarView.frame = CGRectMake(80, 0, self.view.bounds.size.width - 160, 40);
    self.tabBarView.backgroundColor = UIColor.lightGrayColor;
    [self.navigationController.navigationBar addSubview:self.tabBarView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.containerScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
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
