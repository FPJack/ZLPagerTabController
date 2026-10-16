//
//  ZLSceneDelegate.m
//  ZLPagerTabController
//
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLSceneDelegate.h"

@implementation ZLSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }

    UIWindowScene *windowScene = (UIWindowScene *)scene;

    // window 已经由 Info.plist 中 UISceneStoryboardFile(Main) 自动创建时，直接复用
    if (self.window) {
        self.window.windowScene = windowScene;
        [self.window makeKeyAndVisible];
        return;
    }

    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    window.rootViewController = [storyboard instantiateInitialViewController];
    self.window = window;
    [window makeKeyAndVisible];
}

- (void)sceneDidDisconnect:(UIScene *)scene
{
    // 场景被系统释放时调用，可在此释放与该场景相关的资源。
}

- (void)sceneDidBecomeActive:(UIScene *)scene
{
    // 场景变为活跃状态，可恢复被暂停的任务。
}

- (void)sceneWillResignActive:(UIScene *)scene
{
    // 场景即将进入非活跃状态，可暂停正在进行的任务。
}

- (void)sceneWillEnterForeground:(UIScene *)scene
{
    // 场景即将从后台进入前台。
}

- (void)sceneDidEnterBackground:(UIScene *)scene
{
    // 场景进入后台，可保存数据。
}

@end
