//
//  GMItemViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/15.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "GMItemViewController.h"

@interface GMItemViewController ()
@property(nonatomic,assign)CGFloat itemWidth;
@property (nonatomic,assign)CGFloat selectItemWidth;
@property (nonatomic,assign)BOOL enableTextFontGradient;
@property (nonatomic, assign) BOOL enableTextColorGradient;
@property (nonatomic,assign)GMItemWidthMode itemWidthMode;
@property (nonatomic,assign)CGFloat leftRightMargin;

@end

@implementation GMItemViewController

- (void)viewDidLoad {
    self.leftRightMargin = 20;
    [super viewDidLoad];
}

- (void)settingAction:(UIButton *)btn {
    
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
           
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"设置固定宽度120").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.itemWidth = 120;
                self.selectItemWidth = 120;
                [self reloadPagerTabStripView];
            });
        })
    
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"开启滑动字体缩放").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.enableTextFontGradient = YES;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"开启滑动颜色渐变").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.enableTextColorGradient = YES;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"设置左右边距20").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.leftRightMargin = 40;
                self.itemWidth = 0;
                self.selectItemWidth = 0;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"设置item之间间距30").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tabBarView.minItemSpacing = 30;
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
    item.titleFont = [UIFont systemFontOfSize:16];
    item.titleColor = UIColor.blackColor;
    
    item.selectedTitleColor = UIColor.blueColor;
    item.selectTitle = [NSString stringWithFormat:@"%@1", item.title];
    item.selectedTitleFont = [UIFont boldSystemFontOfSize:18];
    
    item.enableTextFontGradient = self.enableTextFontGradient;
    item.enableTextColorGradient = self.enableTextColorGradient;

    item.itemWidth = self.itemWidth;
    item.selectItemWidth = self.selectItemWidth;
    
    item.leftRightMargin = self.leftRightMargin;
    return item;
}

@end
