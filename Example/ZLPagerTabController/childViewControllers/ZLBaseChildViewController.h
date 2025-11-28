//
//  ZLBaseChildViewController.h
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZLPagerTabController/ZLPagerTabBarViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLBaseChildViewController : UIViewController<ZLPagerTabBarChildItem>
@property (strong, nonatomic) UITableView *tableView;

+ (NSString *)randomText;
@end

NS_ASSUME_NONNULL_END
