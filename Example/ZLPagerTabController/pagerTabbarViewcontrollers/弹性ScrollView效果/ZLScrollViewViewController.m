//
//  ZLScrollViewViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/19.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLScrollViewViewController.h"
#import <ZLPagerTabController/ZLScrollView.h>
#import <ZLPagerTabController/ZLParallaxHeader.h>
#import <Masonry/Masonry.h>
@interface ZLScrollViewViewController ()<UITableViewDataSource, UITableViewDelegate,ZLParallaxHeaderDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end


@implementation ZLScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GMCell"];
    self.dataSource = NSMutableArray.array;
    for (int i = 0; i < 50; i ++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"第 %d 行", i]];
    }

    {
        UIView *view = UIView.new;
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"Background"];
        [view addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.mas_equalTo(0);
        }];
        {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = [UIImage imageNamed:@"Rocket"];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.centerX.mas_equalTo(0);
            }];
        }
        self.tableView.parallaxHeader.view = view;

    }
    self.tableView.parallaxHeader.height = 300;
    self.tableView.parallaxHeader.mode = ZLParallaxHeaderModeFill;
    self.tableView.parallaxHeader.delegate = self;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.parallaxHeader.minimumHeight = 60;
}
- (void)parallaxHeaderDidScroll:(ZLParallaxHeader *)parallaxHeader {
    NSLog(@"progress %f", parallaxHeader.progress);
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
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
   
    
}

@end
