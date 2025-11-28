//
//  ZLNestPagerViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/20.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLNestPagerViewController.h"

#import <MJRefresh/MJRefresh.h>

@interface ZLNestPagerViewController ()

@end

@implementation ZLNestPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tableViewRefresh) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView.mj_header endRefreshing];
            });
        }];
    }
    
}
@end
