//
//  ZLNormalChildVC.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLNormalChildVC.h"
#import <ZLPagerTabController/ZLPagerTabBarViewController.h>

@interface ZLNormalChildVC ()

@end

@implementation ZLNormalChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = self.title;
    item.selectedTitleColor = UIColor.orangeColor;
    item.image = [UIImage imageNamed:@"message_org"];
    item.separatorViewSize = CGSizeMake(2, 10);
    return item;
}
@end
