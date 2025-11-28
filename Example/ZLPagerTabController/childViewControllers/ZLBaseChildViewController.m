//
//  ZLBaseChildViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/13.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLBaseChildViewController.h"

@interface ZLBaseChildViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ZLBaseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GMCell"];
    self.dataSource = NSMutableArray.array;
    for (int i = 0; i < 50; i ++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"第 %d 行", i]];
    }
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear %@", self);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@", self);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear %@", self);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear %@", self);
}

+ (NSString *)randomText{
    NSArray *worldCities = @[
        // 中国城市
        @"北京", @"上海", @"广州", @"深圳", @"成都",
        @"里约热内卢", @"圣保罗", @"布宜诺斯艾利斯", @"利马", @"圣地亚哥",
        @"约翰内斯堡", @"开普敦", @"内罗毕", @"卡萨布兰卡"
    ];
    
    return worldCities[arc4random_uniform((uint32_t)worldCities.count)];
}
@end
