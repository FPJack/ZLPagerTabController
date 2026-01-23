//
//  ZLPagerTabBarViewController.h
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import "ZLPagerViewController.h"
#import "ZLPagerTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@class ZLPagerTabBarViewController;
//标签控制器的代理对象和子控制器都可以实现的协议方法，如果都实现了子控制器优先配置
@protocol ZLPagerTabBarChildItem <NSObject>
@optional
- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index;
- (void )pagerViewController:(ZLPagerTabBarViewController *)pagerViewController configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index;
@end


@protocol ZLPagerTabBarViewControllerDataSource <ZLPagerViewControllerDataSource>
@required
-(NSArray<UIViewController<ZLPagerTabBarChildItem> *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController;
@end


@protocol ZLPagerTabBarViewControllerDelegate <ZLPagerViewControllerDelegate,ZLPagerTabBarChildItem>
@optional
-(CGRect)tabBarViewFrameForPagerViewController:(ZLPagerViewController *)pagerViewController;
- (void )pagerViewController:(ZLPagerViewController *)pagerViewController didSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index;
- (BOOL)pagerViewController:(ZLPagerViewController *)pagerViewController shouldSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index;
@end


@interface ZLPagerTabBarViewController : ZLPagerViewController<ZLPagerTabBarDataSource,ZLPagerTabBarDelegate,ZLPagerTabBarViewControllerDataSource,ZLPagerTabBarViewControllerDelegate>

@property (nonatomic,strong,readonly)NSArray<UIViewController<ZLPagerTabBarChildItem> *> *pagerChildViewControllers;

@property (nonatomic,weak)id<ZLPagerTabBarViewControllerDataSource> dataSource;

@property (nonatomic,weak)id<ZLPagerTabBarViewControllerDelegate> delegate;

@property (nonatomic,strong)ZLPagerTabBar *tabBarView;

@end

NS_ASSUME_NONNULL_END
