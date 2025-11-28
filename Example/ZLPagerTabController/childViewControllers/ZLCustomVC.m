//
//  ZLCustomVC.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLCustomVC.h"
#import "TestCell.h"

@interface ZLCustomVC ()

@end

@implementation ZLCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.cellReuseIdentifier = @"TestCell";
    item.cellNib = [UINib nibWithNibName:@"TestCell" bundle:nil];
    item.selectItemWidth = 80;
    item.separatorViewSize = CGSizeMake(2, 10);
    return item;
}
- (void)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index {
    TestCell *customCell = (TestCell *)cell;
}
@end
