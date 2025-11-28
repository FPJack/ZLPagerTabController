//
//  ZLSepViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/14.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLSepViewController.h"
#import "ZLChildTextVC.h"
#import "ZLChildImageVC.h"
#import "ZLNormalChildVC.h"
#import <ZLPopView/ZLPopView.h>
#import "ZLCustomVC.h"
#import "ZLAttributedVC.h"
@interface ZLSepViewController ()
@property (nonatomic,assign)CGFloat selectedBarWidth;
@property (nonatomic,assign)CGFloat selectedBarHeight;
@property (nonatomic, assign) CGFloat selectedBarVerticalOffset;
@property (nonatomic,assign) CGFloat selecterExtraWidth;
@property (nonatomic,assign)BOOL randomColor;
@end

@implementation ZLSepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.selectedBar.hidden = NO;
}
- (void)settingAction:(UIButton *)btn {
    
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"隐藏下划线").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBar.hidden = YES;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"显示下划线").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBar.hidden = NO;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线宽度自适应").addTapAction(^(UIView * _Nonnull view) {
                self.selectedBarWidth = 0;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线宽度固定30").addTapAction(^(UIView * _Nonnull view) {
                self.selectedBarWidth = 30;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线高度固定5").addTapAction(^(UIView * _Nonnull view) {
                self.selectedBarHeight = 5;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线垂直居中").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBarAlignment = ZLSelectedBarAlignmentCenter;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线顶部显示").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBarAlignment = ZLSelectedBarAlignmentTopCenter;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线底部显示").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBarAlignment = ZLSelectedBarAlignmentBottomCenter;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线垂直方向偏移-10").addTapAction(^(UIView * _Nonnull view) {
                self.selectedBarVerticalOffset = -10;
                [self reloadPagerTabStripView];

            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线在自适应宽度基础上加10").addTapAction(^(UIView * _Nonnull view) {
                self.selecterExtraWidth = 10;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线每个Item自定义颜色").addTapAction(^(UIView * _Nonnull view) {
                self.randomColor = YES;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线设置圆角").addTapAction(^(UIView * _Nonnull view) {
                self.tabBarView.selectedBar.layer.masksToBounds = YES;
                [self reloadPagerTabStripView];
            });
        })
        .buildPopOverView
        .setFromView(btn)
        .showPopView();
    
    
    
   
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = [ZLBaseChildViewController randomText];
    item.selectedTitleColor = UIColor.orangeColor;
    item.selectedBarWidth = self.selectedBarWidth;
    item.selectedBarHeight = self.selectedBarHeight;
    item.selectedBarVerticalOffset = self.selectedBarVerticalOffset;
    item.selectedBarHorizontalPadding = self.selecterExtraWidth;
    if (self.randomColor) {
        ///随机生成颜色
        CGFloat red = arc4random_uniform(256) / 255.0;
        CGFloat green = arc4random_uniform(256) / 255.0;
        CGFloat blue = arc4random_uniform(256) / 255.0;
        item.selectedBarColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    }else {
        item.selectedBarColor = nil; //使用默认颜色
    }
    return item;
}
@end
