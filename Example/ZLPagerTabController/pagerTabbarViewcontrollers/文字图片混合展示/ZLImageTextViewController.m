//
//  ZLImageTextViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/18.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLImageTextViewController.h"

@interface ZLImageTextViewController ()
@property (nonatomic, assign) CGFloat titleImageSpace;
@property (nonatomic,assign)int tag;
@end

@implementation ZLImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarView.selectedBar.hidden = YES;
}

- (void)settingAction:(UIButton *)btn {
    
    kPopViewColumnBuilder
        .tapMaskDismiss
        .space(10)
        .inset(10, 10, 10, 10)
        .addViewBK(^ViewKFCType  _Nonnull{
           
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"设置图片文字间距15").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.titleImageSpace = 15;
                [self reloadPagerTabStripView];
            });
        })
    
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"文字在左图片在右").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tag = 0;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"图片在左文字在右").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tag = 1;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"图片在上文字在下").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tag = 2;
                [self reloadPagerTabStripView];
            });
        })
        .addViewBK(^ViewKFCType  _Nonnull{
            return  UILabel.kfc.dismissPopViewWhenTap.text(@"文字在上图片在下").addTapAction(^(__kindof UIView * _Nonnull view) {
                self.tag = 3;
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
    item.image = [UIImage imageNamed:@"message_org"];
    item.titleImageSpace = self.titleImageSpace;
    return item;
}
- (void)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index {
    [cell.titleLabel removeFromSuperview];
    [cell.imageView removeFromSuperview];
    if (self.tag == 0) {
        cell.stackView.axis = UILayoutConstraintAxisHorizontal;
        [cell.stackView addArrangedSubview:cell.titleLabel];
        [cell.stackView addArrangedSubview:cell.imageView];
    }else if (self.tag == 1) {
        cell.stackView.axis = UILayoutConstraintAxisHorizontal;
        [cell.stackView addArrangedSubview:cell.imageView];
        [cell.stackView addArrangedSubview:cell.titleLabel];
    }else if (self.tag == 2) {
        cell.stackView.axis = UILayoutConstraintAxisVertical;
        [cell.stackView addArrangedSubview:cell.imageView];
        [cell.stackView addArrangedSubview:cell.titleLabel];
    }else {
        cell.stackView.axis = UILayoutConstraintAxisVertical;
        [cell.stackView addArrangedSubview:cell.titleLabel];
        [cell.stackView addArrangedSubview:cell.imageView];
    }
}
@end
