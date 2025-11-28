//
//  ZLParallaxPageTabBarViewController.m
//  ZLPagerTabController
//
//  Created by admin on 2025/8/1.
//

#import "ZLParallaxPageTabBarViewController.h"
@interface ZLParallaxPageTabBarViewController ()
@property (nonatomic,strong,readwrite)ZLScrollView *scrollView;
@end

@implementation ZLParallaxPageTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarView removeFromSuperview];
    [self.scrollView addSubview:self.tabBarView];
    [self.containerScrollView removeFromSuperview];
    [self.scrollView addSubview:self.containerScrollView];
}
- (ZLScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[ZLScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!CGRectEqualToRect(self.scrollView.frame, self.view.bounds)) {
        self.scrollView.frame = self.view.bounds;
    }
    if (!CGSizeEqualToSize(self.view.bounds.size, self.scrollView.contentSize)) {
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    CGRect newContainerViewFrame = self.containerScrollView.frame;
    newContainerViewFrame.origin.y = CGRectGetMaxY(self.tabBarView.frame);
    newContainerViewFrame.size.height = self.view.bounds.size.height - newContainerViewFrame.origin.y - self.scrollView.parallaxHeader.minimumHeight;
    if (!CGRectEqualToRect(self.containerScrollView.frame, newContainerViewFrame)) {
        self.containerScrollView.frame = newContainerViewFrame;
    }
   
}
@end
