//
//  ZLCustomViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/18.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLCustomViewController.h"
#import "TestCell.h"

@interface ZLCustomViewController ()

@end

@implementation ZLCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
}
-(CGRect)tabBarViewFrameForPagerViewController:(ZLPagerViewController *)pagerViewController {
    return CGRectMake(0, 0, self.view.bounds.size.width, 80);
}
- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.cellReuseIdentifier = @"TestCell";
    item.cellNib = [UINib nibWithNibName:@"TestCell" bundle:nil];
    item.selectItemWidth = 80;
    item.selectedBarColor = UIColor.redColor;
    return item;
}
- (void)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index {
    TestCell *testCell = (TestCell *)cell;
    testCell.sw.on = index == self.currentIndex;
}

@end
