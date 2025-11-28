//
//  ZLPagerTabBar.h
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import <UIKit/UIKit.h>
#import "ZLTabBarCellItem.h"

NS_ASSUME_NONNULL_BEGIN
@class ZLPagerTabBar,ZLTabBarCell;
typedef NS_ENUM(NSUInteger, ZLTabBarViewAlignment) {
    ZLTabBarViewAlignmentStart,
    ZLTabBarViewAlignmentEnd,
    ZLTabBarViewAlignmentCenter,
    ZLTabBarViewAlignmentAutoFillEqualWidth,//会判断平分空间条件下能否满足每个cell内容都放下，空间不够会自动调整
    ZLTabBarViewAlignmentFillEqualWidth,//平分空间
    ZLTabBarViewAlignmentSpaceEvenly,//两边和中间间距相等
    ZLTabBarViewAlignmentSpaceAround//两边间距等于中间间距一半
};
typedef NS_ENUM(NSUInteger, ZLSelectedBarAlignment) {
    ZLSelectedBarAlignmentTopCenter,
    ZLSelectedBarAlignmentCenter,
    ZLSelectedBarAlignmentBottomCenter,
    ZLSelectedBarAlignmentProgressive
};
@interface ZLRTLTabBarCollectionView:  UICollectionView
@end
@interface ZLRTLTabBarCollectionViewFlowLayout: UICollectionViewFlowLayout
@end



@protocol ZLPagerTabBarDataSource <NSObject>
@required
- (NSArray<ZLTabBarCellItem *> *)tabBarItemsForPagerTabBar:(ZLPagerTabBar *)pagerTabBar;
@end



@protocol ZLPagerTabBarDelegate <NSObject>
@optional
- (void )pagerTabBar:(ZLPagerTabBar *)pagerTabBar didSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index;
- (BOOL)pagerTabBar:(ZLPagerTabBar *)pagerTabBar shouldSelectItem:(ZLTabBarCellItem *)item index:(NSInteger)index;
- (void )pagerTabBar:(ZLPagerTabBar *)tabBarView configureCell:(ZLTabBarCell *)cell item:(ZLTabBarCellItem *)item forIndex:(NSInteger)index;
@end

@interface ZLTabBarItemLabel : UILabel
@property (nonatomic,strong) UILabel *frontLabel;
@end
@interface ZLTabBarCell : UICollectionViewCell
@property (nonatomic,assign)CGFloat titleImageSpace;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *imageView;
@end


@interface ZLPagerTabBar : UIView
///只读属性
@property (nonatomic,strong,readonly) NSArray<ZLTabBarCellModel *> *items;
@property (nonatomic,assign,readonly)UICollectionView *collectionView;
@property (nonatomic,strong,readonly) UIView * selectedBar;

/// 利用这个View可以实现类似SegmentedControl效果
@property (nonatomic,strong,readonly)UIView *extraView;
@property (nonatomic,assign,readonly) NSInteger currentIndex;
///设置代理
@property (nonatomic, weak) id<ZLPagerTabBarDataSource> dataSource;
@property (nonatomic, weak) id<ZLPagerTabBarDelegate> delegate;

///是否开启SegmentedControl效果
@property (nonatomic,assign) BOOL isSegmentedControlStyle;

///默认ZLTabBarViewAlignmentCenter
@property (nonatomic,assign,readwrite) ZLTabBarViewAlignment alignment;
///默认ZLSelectedBarAlignmentBottomCenter
@property (nonatomic,assign) ZLSelectedBarAlignment selectedBarAlignment;
///默认10
@property (nonatomic,assign)CGFloat minItemSpacing;
///默认UIEdgeInsetsMake(0, 10, 0, 10)
@property (nonatomic,assign)UIEdgeInsets contentInset;

-(void)moveToIndex:(NSUInteger)index animated:(BOOL)animated;

//frame,配置,数据源改变的时候刷新
- (void)reloadTabBarView;

-(void)pagerTabBarUpdateIndicatorFromIndex:(NSInteger)fromIndex
                                   toIndex:(NSInteger)toIndex
                                  animated:(BOOL)animated;

-(void)pagerTabUpdateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
                        indexWasChanged:(BOOL)indexWasChanged
                               animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
