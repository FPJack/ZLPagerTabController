//
//  ZLBasePagerTabbarViewController.h
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/14.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLChildTextVC.h"
#import "ZLChildImageVC.h"
#import "ZLNormalChildVC.h"
#import <ZLPopView/ZLPopView.h>
#import "ZLCustomVC.h"
#import "ZLAttributedVC.h"
#import <ZLPagerTabController/ZLPagerTabBarViewController.h>
#import "ZLChildViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZLBasePagerTabbarViewController : ZLPagerTabBarViewController
- (void)settingAction:(UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
