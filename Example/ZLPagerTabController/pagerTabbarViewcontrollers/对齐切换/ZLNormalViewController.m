//
//  ZLNormalViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLNormalViewController.h"


@interface ZLNormalViewController ()
@property (nonatomic,assign)NSInteger count;
@end

@implementation ZLNormalViewController

- (void)viewDidLoad {
    self.count = 20;
    [super viewDidLoad];
    self.tabBarView.selectedBar.hidden = NO;
}
- (void)settingAction:(UIButton *)btn {
    
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
           
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"左对齐").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentStart;
                [self reloadPagerTabStripView];
            });
        })
    
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"居中对齐").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentCenter;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"右对齐").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentEnd;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"平分空间").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentFillEqualWidth;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"间距相等").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentSpaceEvenly;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"边距二分之一").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.count = 3;
                self.tabBarView.alignment = ZLTabBarViewAlignmentSpaceAround;
                [self reloadPagerTabStripView];
            });
        })
        .buildPopOverView
        .setFromView(btn)
        .showPopView();
    
   
}
- (NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController {
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        ZLChildViewController *vc = [[ZLChildViewController alloc] init];
        [viewControllers addObject:vc];
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
