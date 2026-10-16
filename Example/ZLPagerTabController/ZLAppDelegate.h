//
//  ZLAppDelegate.h
//  ZLPagerTabController
//
//  Created by fanpeng on 11/28/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

@import UIKit;

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate>

// 使用 UIScene 后，window 由 ZLSceneDelegate 持有
@property (strong, nonatomic) UIWindow *window API_DEPRECATED("Use ZLSceneDelegate.window", ios(2.0, 13.0));

@end
