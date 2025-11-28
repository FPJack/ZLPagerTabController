//
//  ZLEllipseMaskViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLEllipseMaskViewController.h"

@interface ZLEllipseMaskViewController ()
@property (nonatomic,assign)CGFloat selectedBarHeight;

@end

@implementation ZLEllipseMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView.extraView.hidden = NO;
    self.tabBarView.extraView.layer.masksToBounds = YES;
    self.tabBarView.selectedBar.hidden = YES;
}
- (void)settingAction:(UIButton *)btn {
    
    
    
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
           
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线实现椭圆遮罩").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tabBarView.selectedBar.hidden = NO;
                self.tabBarView.selectedBar.layer.masksToBounds = YES;
                self.tabBarView.selectedBarAlignment = ZLSelectedBarAlignmentCenter;
                self.tabBarView.extraView.hidden = YES;
                self.selectedBarHeight = 30;
                [self reloadPagerTabStripView];
            });
        })
    
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"附加view实现椭圆遮罩").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tabBarView.selectedBar.hidden = YES;
                self.tabBarView.extraView.hidden = NO;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"下划线椭圆遮罩并存").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tabBarView.selectedBar.hidden = NO;
                self.tabBarView.extraView.hidden = NO;
                self.tabBarView.selectedBarAlignment = ZLSelectedBarAlignmentBottomCenter;
                self.selectedBarHeight = 2;
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
    
    item.selectedBarHeight = self.selectedBarHeight;
    item.selectedBarHorizontalPadding = 8;
    item.selectedBarColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.5];
   
    item.extraViewSize = CGSizeMake(0, 30);
    item.extraViewColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0];
    return item;
}

@end
