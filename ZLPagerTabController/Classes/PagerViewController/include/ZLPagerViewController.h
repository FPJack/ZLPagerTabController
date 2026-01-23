//
//  ZLPagerViewController.h
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class ZLPagerViewController;

@protocol ZLPagerViewControllerDelegate <NSObject>
@optional
-(void)pagerViewController:(ZLPagerViewController *)pagerViewController
                           updateFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex;
-(void)pagerViewController:(ZLPagerViewController *)pagerViewController
                           updateFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
                           progressPercentage:(CGFloat)progressPercentage
                           indexWasChanged:(BOOL)indexWasChanged;
@end

@protocol ZLPagerViewControllerDataSource <NSObject>
@required
-(NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController;

@end
@interface ZLPagerViewController : UIViewController<UIScrollViewDelegate,ZLPagerViewControllerDataSource,ZLPagerViewControllerDelegate>
@property (nonatomic,strong)UIScrollView *containerScrollView;

@property (nonatomic,strong,readonly)NSArray<UIViewController *> *pagerChildViewControllers;

@property (nonatomic,weak)id<ZLPagerViewControllerDataSource> dataSource;

@property (nonatomic,weak)id<ZLPagerViewControllerDelegate> delegate;

@property (nonatomic,assign,readonly)NSInteger currentIndex;
///是否支持滑动进度回调
@property (nonatomic,assign)BOOL isProgressiveIndicator;

///切换间隔大于 1页的时候，是否跳过中间页面
@property(nonatomic,assign) BOOL skipIntermediateViewControllers;
///滑到边界的时候是否可以继续滑动
@property (nonatomic, assign) BOOL enableBoundaryBounce;



@property (nonatomic,assign,readonly) UISemanticContentAttribute semanticContentAttribute;

-(void)reloadPagerTabStripView;
-(void)moveToViewControllerAtIndex:(NSInteger)index;
-(void)moveToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
-(void)moveToViewController:(UIViewController *)viewController;
-(void)moveToViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
