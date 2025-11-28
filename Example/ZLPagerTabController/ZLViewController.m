//
//  ZLViewController.m
//  GMPagerTabController
//
//  Created by fanpeng on 07/31/2025.
//  Copyright (c) 2025 fanpeng. All rights reserved.
//

#import "ZLViewController.h"
#import "ZLNormalViewController.h"
#import "ZLSepViewController.h"
#import "GMItemViewController.h"

#import "ZLImageTextViewController.h"
#import "ZLAttributedViewController.h"
#import "ZLCustomViewController.h"

#import "ZLSeparatorViewController.h"
#import "ZLEllipseMaskViewController.h"
#import "ZLSegmentedControlViewController.h"
#import "ZLTabBarAddViewViewController.h"
#import "ZLNavTabBarViewController.h"
#import "ZLScrollViewViewController.h"
#import "ZLCustomScrollViewViewController.h"
#import "ZLParallaxPagerViewController.h"
#import "ZLNestPagerTabBarViewController.h"


@interface ZLViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ZLViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.redColor;// 设置背景色
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor}; // 标题颜色
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }else {
        self.navigationController.navigationBar.barTintColor = UIColor.redColor;
        self.navigationController.navigationBar.backgroundColor = UIColor.redColor;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GMCell"];
    self.dataSource = @[
        @"对齐方式切换",
        @"下划线设置",
        @"字体颜色宽度设置",
        @"文字图片混合展示",
        @"富文本展示",
        @"自定义cell展示",
        @"cell之间设置分界线",
        @"椭圆遮罩层设置",
        @"实现SegmentedControl效果",
        @"tabBar上添加其他按钮",
        @"导航栏上添加TabBar",
        @"弹性ScrollView效果",
        @"弹性GMScrollView效果",
        @"悬浮PagerTabbar",
        @"标签页面嵌套使用"
    ];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GMCell" forIndexPath:indexPath];
    NSString *title = self.dataSource[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        ZLNormalViewController *vc = [[ZLNormalViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 1) {
        ZLSepViewController *vc = [[ZLSepViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 2) {
        GMItemViewController *vc = [[GMItemViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 3) {
        ZLImageTextViewController *vc = [[ZLImageTextViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 4) {
        ZLAttributedViewController *vc = [[ZLAttributedViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 5) {
        ZLCustomViewController *vc = [[ZLCustomViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 6) {
        ZLSeparatorViewController *vc = [[ZLSeparatorViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 7) {
        ZLEllipseMaskViewController *vc = [[ZLEllipseMaskViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 8) {
        ZLSegmentedControlViewController *vc = [[ZLSegmentedControlViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 9) {
        ZLTabBarAddViewViewController *vc = [[ZLTabBarAddViewViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 10) {
        ZLNavTabBarViewController *vc = [[ZLNavTabBarViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 11) {
        ZLScrollViewViewController *vc = [[ZLScrollViewViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 12) {
        ZLCustomScrollViewViewController *vc = [[ZLCustomScrollViewViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 13) {
        ZLParallaxPagerViewController *vc = [[ZLParallaxPagerViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.item == 14) {
        ZLNestPagerTabBarViewController *vc = [[ZLNestPagerTabBarViewController alloc] init];
        vc.title = self.dataSource[indexPath.item];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"ZLViewController viewWillAppear %@", self);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"ZLViewController viewDidAppear %@", self);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"ZLViewController viewWillDisappear %@", self);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"ZLViewController viewDidDisappear %@", self);
}
@end
