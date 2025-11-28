//
//  ZLSegmentedControlViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLSegmentedControlViewController.h"

@interface ZLSegmentedControlViewController ()

@end

@implementation ZLSegmentedControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.tabBarView.selectedBar.hidden = YES;
    self.tabBarView.extraView.hidden = NO;
    self.tabBarView.extraView.layer.masksToBounds = YES;
    self.tabBarView.isSegmentedControlStyle = YES;
    self.tabBarView.contentInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.tabBarView.collectionView.layer.borderWidth = 1;
    self.tabBarView.collectionView.layer.borderColor = UIColor.redColor.CGColor;
    self.tabBarView.collectionView.layer.cornerRadius = 15;
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.titleColor = UIColor.redColor;
    item.selectedTitleColor = UIColor.whiteColor;
    item.extraViewSize = CGSizeMake(0, 30);
    return item;
}

@end
