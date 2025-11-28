//
//  ZLCustomScrollViewViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/20.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLCustomScrollViewViewController.h"
#import <ZLPagerTabController/ZLParallaxHeader.h>
#import <ZLPagerTabController/ZLScrollView.h>
#import <Masonry/Masonry.h>
#define SPANISH_WHITE [UIColor colorWithRed:0.996 green:0.992 blue:0.941 alpha:1] /*#fefdf0*/

@interface ZLCustomScrollViewViewController () <ZLScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ZLScrollView *scrollView;
@property (nonatomic, strong) UITableView *table1;
@property (nonatomic, strong) UITableView *table2;
@end

@implementation ZLCustomScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
//    self.scrollView.bounces = YES;
    [self.scrollView addSubview:self.table1];
    [self.scrollView addSubview:self.table2];
    
    {
        UIView *view = UIView.new;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"Background1"];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(0);
        }];
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"Spaceship"];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
            }];
        }
        self.scrollView.parallaxHeader.view = view;

    }
    self.scrollView.parallaxHeader.height = 300;
    self.scrollView.parallaxHeader.mode = ZLParallaxHeaderModeCenter;
    self.scrollView.parallaxHeader.minimumHeight = 80;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

// In this example I use manual layout for peformances
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.view.bounds;
    
    //Update scroll view frame and content size
    self.scrollView.frame = frame;
    self.scrollView.contentSize = frame.size;
    
    //Update table 1 frame
    frame.size.width /= 2;
    frame.size.height -= self.scrollView.parallaxHeader.minimumHeight;
    self.table1.frame = frame;
    
    //Update table 2 frame
    frame.origin.x = frame.size.width;
    self.table2.frame = frame;
}

#pragma mark Properties

- (ZLScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[ZLScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [[UITableView alloc] init];
        _table1.dataSource  = self;
        _table1.backgroundColor = SPANISH_WHITE;
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [[UITableView alloc] init];
        _table2.dataSource  = self;
        _table2.backgroundColor = SPANISH_WHITE;
    }
    return _table2;
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"progress %f", self.scrollView.parallaxHeader.progress);
}

#pragma mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    cell.backgroundColor = SPANISH_WHITE;
    
    return cell;
}

@end
