# ZLPagerTabController

ZLPagerTabController支持各种页面标签展示效果，类似于今日头条、网易新闻、微信读书等App的标签页切换效果，支持自定义标签样式、指示器样式等

1.保留了控制器的完整生命周期方法，方便在各个子控制器中处理业务逻辑。

2.支持自定义标签样式，包括字体、颜色、间距等。

3.支持自定义指示器样式，包括颜色、高度、宽度等。

4.支持标签页面嵌套使用，实现复杂的标签切换效果。

5.支持横竖屏切换，自动适配屏幕尺寸变化。

6.支持悬浮效果，标签栏可以悬浮在内容上方。

7.支持动态添加和删除标签，方便实现动态内容展示。





## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation


```ruby
同时支持SPM导入和CocoaPods导入，CocoaPods导入方式如下：
pod 'ZLPagerTabController'
```




<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4799.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4798.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4797.GIF" width="30%" height="30%">

<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4796.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4795.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4794.GIF" width="30%" height="30%">

<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4793.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4792.GIF" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4800.PNG" width="30%" height="30%">

<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4801.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4802.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4803.PNG" width="30%" height="30%">

<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4804.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4805.PNG" width="30%" height="30%">   <img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4806.PNG" width="30%" height="30%">


<img src="https://github.com/FPJack/ZLPagerTabController/blob/master/IMG_4807.PNG" width="30%" height="30%">   

## 新建控制器继承ZLPagerTabBarViewController，实现数据源方法，更多自定义查看相对应的demo
```ruby
//返回子控制器
- (NSArray<UIViewController *> *)childViewControllersForPagerViewController:(ZLPagerViewController *)pagerViewController {
    UIViewController *vc1 = [[UIViewController alloc] init];
    UIViewController *vc2 = [[UIViewController alloc] init];
    UIViewController *vc3 = [[UIViewController alloc] init];
    return @[vc1, vc2, vc3];
}
//返回标签数据
- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    item.title = @"标签1";
    item.selectedTitleColor = UIColor.orangeColor;
    return item;
}
```

## Author

fanpeng, 2551412939@qq.com

## License

ZLPagerTabController is available under the MIT license. See the LICENSE file for more info.
