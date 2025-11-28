//
//  ZLParallaxPagerViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/20.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLParallaxPagerViewController.h"
#import "ZLChildViewController.h"
#import <Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <ZLPopView/ZLPopView.h>
#import "ZLNestPagerViewController.h"
#import "ZLNormalViewController.h"

@interface ZLParallaxPagerViewController ()
@property (nonatomic,assign)BOOL tableViewRefresh;
@end

@implementation ZLParallaxPagerViewController

- (void)viewDidLoad {
    self.tableViewRefresh = YES;
    self.tabBarView.selectedBar.hidden = NO;
    [super viewDidLoad];
    UIButton *btn = UIButton.new;
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    {
        UIView *view = UIView.new;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"Background1"];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(0);
        }];
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"Spaceship"];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
            }];
        }
        self.scrollView.parallaxHeader.view = view;
    }
    self.scrollView.parallaxHeader.height = 300;
    self.scrollView.parallaxHeader.minimumHeight = 0;
    self.scrollView.parallaxHeader.mode = ZLParallaxHeaderModeBottom;
    
    
}
- (void)setTableViewRefresh:(BOOL)tableViewRefresh {
    _tableViewRefresh = tableViewRefresh;
    if (tableViewRefresh) {
        self.scrollView.bounces = NO;
        self.scrollView.mj_header = nil;
    }else {
        self.scrollView.bounces = YES;
        self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.scrollView.parallaxHeader.height = 300;
                [self.scrollView.mj_header endRefreshing];
            });
        }];
        self.scrollView.mj_header.ignoredScrollViewContentInsetTop = 300;
    }
}
- (void)settingAction:(UIButton *)btn {
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
           
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"外部整体刷新").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tableViewRefresh = NO;
                self.tabBarView.alignment = ZLTabBarViewAlignmentStart;
                [self reloadPagerTabStripView];
            });
        })
    
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"内部tableView刷新").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tableViewRefresh = YES;
                self.tabBarView.alignment = ZLTabBarViewAlignmentCenter;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"设置头部悬浮最小高度100").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.scrollView.parallaxHeader.minimumHeight = 100;
                self.tableViewRefresh = YES;
                self.tabBarView.alignment = ZLTabBarViewAlignmentCenter;
                [self reloadPagerTabStripView];
            });
        })
       
        .buildPopOverView
        .setFromView(btn)
        .showPopView();
    
    
   
}
- (NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        if (i  % 2 == 0) {
            ZLNestPagerViewController *vc = [[ZLNestPagerViewController alloc] init];
            vc.tableViewRefresh = self.tableViewRefresh;
            [viewControllers addObject:vc];
        }else {
            ZLNormalViewController *vc = [[ZLNormalViewController alloc] init];
            [viewControllers addObject:vc];
        }
      
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
