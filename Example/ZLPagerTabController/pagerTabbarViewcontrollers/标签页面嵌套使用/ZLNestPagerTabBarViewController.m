//
//  ZLNestPagerTabBarViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/20.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLNestPagerTabBarViewController.h"
#import "ZLNormalViewController.h"
#import "ZLNestPagerViewController.h"

@interface ZLNestPagerTabBarViewController ()

@end

@implementation ZLNestPagerTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}
- (NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        ZLNormalViewController *vc = [[ZLNormalViewController alloc] init];
        [viewControllers addObject:vc];
    }
    return viewControllers;
}
- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.selectedTitleColor = UIColor.orangeColor;
    return item;
}

@end
