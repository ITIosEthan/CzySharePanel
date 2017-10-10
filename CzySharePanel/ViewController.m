//
//  ViewController.m
//  CzySharePanel
//
//  Created by macOfEthan on 17/10/9.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import "ViewController.h"
#import "CzyCustomBtn.h"
#import "CzyPopView.h"

@interface ViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
/**平台*/
@property (nonatomic, strong) NSMutableArray *titles;

@end

@implementation ViewController


- (NSMutableArray *)titles
{
    if (!_titles) {
        self.titles = [NSMutableArray arrayWithObjects:@"微信", @"微信朋友圈", @"微信收藏",@"QQ",@"QQ空间", @"支付宝",nil];
    }
    return _titles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - 分享
- (void)share:(UIBarButtonItem *)bbi
{
    /**
    显示分享面板

    @param titles 分享平台名称
    @param imageNames 分享平台图片
    @param textColor 文字颜色
    @param textFont 文字字体
    */
    [[CzyPopView shareManager] showSharePanelWithTitiles:self.titles
                                           andImageNames:self.titles
                                            andTextColor:[UIColor redColor]
                                             andTextFont:[UIFont systemFontOfSize:12]];
}

#pragma mark - 提示
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"点击右上角分享"];
}

@end
