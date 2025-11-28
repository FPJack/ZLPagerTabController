//
//  ZLAttributedViewController.m
//  GMPagerTabController_Example
//
//  Created by admin on 2025/8/18.
//  Copyright © 2025 fanpeng. All rights reserved.
//

#import "ZLAttributedViewController.h"

@interface ZLAttributedViewController ()

@end

@implementation ZLAttributedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (ZLTabBarCellItem *)pagerViewController:(ZLPagerTabBarViewController *)pagerViewController forIndex:(NSInteger)index {
    ZLTabBarCellItem *item = [[ZLTabBarCellItem alloc] init];
    UIColor *color = UIColor.blueColor;
    UIColor *selectColor = UIColor.redColor;
    {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] init];
        NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:@"文字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: color}];
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"message_org"];
        attachment.bounds = CGRectMake(0, -2, 16, 16);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSAttributedString *att2 = [[NSAttributedString alloc] initWithString:@"(1)" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: color}];
        [mAttr appendAttributedString:att1];
        [mAttr appendAttributedString:imageAttr];
        [mAttr appendAttributedString:att2];
        item.attributedText = mAttr;
    }
    {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] init];
        NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:@"文字" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: selectColor}];
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"message_org"];
        attachment.bounds = CGRectMake(0, -2, 16, 16);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        NSAttributedString *att2 = [[NSAttributedString alloc] initWithString:@"(1)" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: selectColor}];
        [mAttr appendAttributedString:att1];
        [mAttr appendAttributedString:imageAttr];
        [mAttr appendAttributedString:att2];
        item.selectAttributedText = mAttr;
    }
    item.selectedBarColor = UIColor.redColor;
    return item;
}

@end
