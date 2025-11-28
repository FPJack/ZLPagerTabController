//
//  ZLChildImageVC.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLChildImageVC.h"
#import <ZLPagerTabController/ZLPagerTabBarViewController.h>
#import <Masonry/Masonry.h>
@interface ZLChildImageVC ()

@end

@implementation ZLChildImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.image = [UIImage imageNamed:@"image3"];
    item.separatorViewSize = CGSizeMake(2, 10);
    return item;
}
@end
