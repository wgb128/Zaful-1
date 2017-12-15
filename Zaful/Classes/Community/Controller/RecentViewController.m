//
//  RecentViewController.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentViewModel.h"

@interface RecentViewController ()
@property (nonatomic,strong) UITableView *goodsTableView;
@property (nonatomic,strong) RecentViewModel *viewModel;

@end

@implementation RecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.goodsTableView];
    [self requestRecentData];
}

- (void)requestRecentData {
    [self.viewModel requestRecentNetwork:nil completion:^(id obj) {
        [self.goodsTableView reloadData];
    } failure:^(id obj) {
        
    }];
}

#pragma mark - Setter/Getter
-(RecentViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RecentViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

-(UITableView *)goodsTableView {
    if (!_goodsTableView) {
        _goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStylePlain];
        _goodsTableView.rowHeight = 114;
        _goodsTableView.delegate = self.viewModel;
        _goodsTableView.dataSource = self.viewModel;
        _goodsTableView.showsVerticalScrollIndicator = YES;
        _goodsTableView.showsHorizontalScrollIndicator = NO;
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTableView.emptyDataSetSource = self.viewModel;
        _goodsTableView.emptyDataSetDelegate = self.viewModel;
        _goodsTableView.tableFooterView = [[UIView alloc] init];
    }
    return _goodsTableView;
}

@end
