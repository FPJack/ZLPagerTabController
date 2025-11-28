//
//  ZLSeparatorViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLSeparatorViewController.h"

@interface ZLSeparatorViewController ()

@end

@implementation ZLSeparatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;

}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.selectedTitleColor = UIColor.orangeColor;
    item.separatorViewSize = CGSizeMake(2, 10);
    item.separatorView.backgroundColor = UIColor.redColor;
    return item;
}
@end
