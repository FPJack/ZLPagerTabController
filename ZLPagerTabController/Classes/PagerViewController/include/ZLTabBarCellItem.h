//
//  ZLTabBarCellItem.h
//  ZLPagerTabController
//
//  Created by admin on 2025/7/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class ZLPagerTabBar,ZLTabBarCellModel;

typedef NS_ENUM(NSInteger, GMItemWidthMode) {
    GMItemWidthModeUseSelected = 0,  // 始终使用选中状态宽度
    GMItemWidthModeUseOriginal,   // 各自宽度为准
    GMItemWidthModeUseNormal   // 始终使用正常状态宽度
};
typedef NS_ENUM(NSInteger, GMItemType) {
    GMItemTypeUnknown,
    GMItemTypeText,
    GMItemTypeImage,
    GMItemTypeTextImage
};
@interface ZLTabBarCellItem : NSObject
///外部赋值
@property (nonatomic,copy)NSString* title;
///富文本属性
@property (nonatomic,copy)NSAttributedString *attributedText;
///选中状态富文本属性
@property (nonatomic,copy)NSAttributedString *selectAttributedText;
///默认  GMItemWidthModeUseSelected
@property (nonatomic,assign)GMItemWidthMode itemWidthMode;
/// 默认自动计算
@property (nonatomic,assign)CGFloat itemWidth;
/// 默认自动计算
@property (nonatomic,assign)CGFloat selectItemWidth;
/// 默认title
@property (nonatomic,copy)NSString* selectTitle;
/// 默认blackColor
@property (nonatomic,copy)UIColor* titleColor;
/// 默认color
@property (nonatomic,copy)UIColor* selectedTitleColor;
/// 默认16
@property (nonatomic,copy)UIFont* titleFont;
/// 默认font
@property (nonatomic,copy)UIFont* selectedTitleFont;
/// 默认nil
@property (nonatomic,strong)UIImage* image;
/// 默认image
@property (nonatomic,strong)UIImage* selectedImage;
/// 默认自动计算
@property (nonatomic,assign)CGFloat selectedBarWidth;
/// 默认2
@property (nonatomic,assign)CGFloat selectedBarHeight;
///selectbar 垂直方向偏移 默认0
@property (nonatomic, assign) CGFloat selectedBarVerticalOffset;
/// 默认selectedTextColor
@property (nonatomic,copy)UIColor* selectedBarColor;
/// 默认5
@property (nonatomic,assign)CGFloat titleImageSpace;
/// 默认10 如果设置了固定的宽度或选中宽度 改属性无效
@property (nonatomic,assign)CGFloat leftRightMargin;
/// 默认0
@property (nonatomic,assign) CGFloat selectedBarHorizontalPadding;
/// 字体大小是否渐变 富文本暂不支持
@property (nonatomic, assign) BOOL enableTextFontGradient;
/// text渐变颜色 富文本暂不支持
@property (nonatomic, assign) BOOL enableTextColorGradient;

///两个cell之间的额外附加View
@property (nonatomic,strong)UIView *separatorView;
///separatorView size
@property (nonatomic,assign) CGSize separatorViewSize;
///附加view的背景色
@property (nonatomic,copy)UIColor *extraViewColor;
//// 附加view的size CGSizeMake(0, 0) 宽高如果是0自适应宽高
@property (nonatomic,assign) CGSize extraViewSize;

/*
 自定义样式cell需要继承GMButtonBarViewCell，并且手动设置cell宽
 */
@property (nonatomic,copy)NSString *cellReuseIdentifier;
///自定义cell的时候需要继承GMButtonBarViewCell
@property (nonatomic,strong)Class cellClass;
//////自定义cell的时候需要继承GMButtonBarViewCell
@property (nonatomic,strong)UINib *cellNib;

- (ZLTabBarCellModel *)convertToCellModel;
@end


@interface ZLTabBarCellModel : NSObject
///外部赋值
@property (nonatomic,copy)NSString* title;
///富文本属性
@property (nonatomic,copy)NSAttributedString *attributedText;
///选中状态富文本属性
@property (nonatomic,copy)NSAttributedString *selectAttributedText;
/// 默认自动计算
@property (nonatomic,assign)CGFloat itemWidth;
/// 默认自动计算
@property (nonatomic,assign)CGFloat selectItemWidth;
///默认  GMItemWidthModeUseSelected
@property (nonatomic,assign)GMItemWidthMode itemWidthMode;
/// 默认title
@property (nonatomic,copy)NSString* selectTitle;
/// 默认blackColor
@property (nonatomic,copy)UIColor* titleColor;
/// 默认color
@property (nonatomic,copy)UIColor* selectedTitleColor;
/// 默认16
@property (nonatomic,copy)UIFont* titleFont;
/// 默认font
@property (nonatomic,copy)UIFont* selectedTitleFont;
/// 默认nil
@property (nonatomic,strong)UIImage* image;
/// 默认image
@property (nonatomic,strong)UIImage* selectedImage;
/// 默认自动计算
@property (nonatomic,assign)CGFloat selectedBarWidth;
/// 默认2
@property (nonatomic,assign)CGFloat selectedBarHeight;
///selectbar 垂直方向偏移 默认0
@property (nonatomic, assign) CGFloat selectedBarVerticalOffset;
/// 默认selectedTextColor
@property (nonatomic,copy)UIColor* selectedBarColor;
/// 默认5
@property (nonatomic,assign)CGFloat titleImageSpace;
/// 默认0
@property (nonatomic,assign)CGFloat leftRightMargin;
/// 默认0
@property (nonatomic,assign) CGFloat selectedBarHorizontalPadding;

/// 字体大小是否渐变
@property (nonatomic, assign) BOOL enableTextFontGradient;
/// text渐变颜色
@property (nonatomic, assign) BOOL enableTextColorGradient;
///两个cell之间的额外附加View
@property (nonatomic,assign) CGSize separatorViewSize;
///附加view的背景色
@property (nonatomic,copy)UIColor *extraViewColor;
//// 附加view的size
@property (nonatomic,assign) CGSize extraViewSize;

/*
 自定义样式cell需要继承GMButtonBarViewCell，并且手动设置cell宽
 */
@property (nonatomic,copy)NSString *cellReuseIdentifier;
///自定义cell的时候需要继承GMButtonBarViewCell
@property (nonatomic,strong)Class cellClass;
//////自定义cell的时候需要继承GMButtonBarViewCell
@property (nonatomic,strong)UINib *cellNib;

//内部自动合成属性
@property (nonatomic,strong)UIView *separatorView;
@property (nonatomic,strong)ZLTabBarCellItem *cellItem;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,weak)ZLPagerTabBar *pagerTabBar;
@property (nonatomic,weak)NSArray <ZLTabBarCellModel *> *items;
@property (nonatomic,assign,readonly)CGFloat getMinX;
@property (nonatomic,assign,readonly)CGFloat getMaxX;
@property (nonatomic,assign,readonly)CGFloat getCenterX;
@property (nonatomic,assign,readonly)CGFloat getShowWidth;
@property (nonatomic,assign)CGFloat availableFillEqualWidth;
@property (nonatomic,assign)CGFloat minInterItemSpacing;
@property (nonatomic,assign)CGRect maskFrame;
@property (nonatomic,assign,readonly)GMItemType itemType;
@end

NS_ASSUME_NONNULL_END
