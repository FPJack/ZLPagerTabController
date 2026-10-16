//
//  ZLBasePagerTabbarViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/14.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLBasePagerTabbarViewController.h"

@interface ZLBasePagerTabbarViewController ()

@end

@implementation ZLBasePagerTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = UIButton.new;
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(CGRect)tabBarViewFrameForPagerViewController:(ZLPagerViewController *)pagerViewController {
    //iOS26 之后导航栏是通透的，内容会铺到导航栏下面，这里用安全区顶部来定位，避免被导航栏遮挡
    return CGRectMake(0, self.view.safeAreaInsets.top, self.view.bounds.size.width, 50);
}
- (NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        ZLChildViewController *vc = [[ZLChildViewController alloc] init];
        [viewControllers addObject:vc];
    }
    return viewControllers;
}

- (void)settingAction:(UIButton *)btn {
    
}

@end
