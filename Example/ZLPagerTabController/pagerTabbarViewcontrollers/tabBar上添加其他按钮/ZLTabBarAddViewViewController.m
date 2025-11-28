//
//  ZLTabBarAddViewViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLTabBarAddViewViewController.h"

@interface ZLTabBarAddViewViewController ()

@end

@implementation ZLTabBarAddViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
    self.tabBarView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
    
   
    {
        UIButton *btn = UIButton.new;
        [btn setTitle:@"按钮" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(10, 10, 30, 30);
        [self.tabBarView addSubview:btn];
    }
    {
        UIButton *btn = UIButton.new;
        [btn setImage:[UIImage imageNamed:@"message_org"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(self.view.bounds.size.width - 40, 10, 30, 30);
        [self.tabBarView addSubview:btn];
    }
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.selectedTitleColor = UIColor.orangeColor;
    return item;
}

@end
