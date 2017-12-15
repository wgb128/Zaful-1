//
//  OrderViewController.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderViewModel.h"

@interface OrderViewController ()
@property (nonatomic,strong) UITableView *goodsTableView;
@property (nonatomic,strong) OrderViewModel *viewModel;
@end

@implementation OrderViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.goodsTableView];
    [self requestNetWorkGoods];
}

- (void)requestNetWorkGoods {
    @weakify(self)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self requstRefreshNetworkWith:Refresh];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.goodsTableView.mj_header = header;
    
    self.goodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requstRefreshNetworkWith:LoadMore];
    }];
    [self.goodsTableView.mj_header beginRefreshing];
}

- (void)requstRefreshNetworkWith:(NSString *)refresh {
    [self.viewModel requestOrderNetwork:refresh completion:^(id obj) {
        if([obj isEqual: NoMoreToLoad]) {
            // 无法加载更多的时候
//            [self.goodsTableView.mj_footer endRefreshingWithNoMoreData];
            self.goodsTableView.mj_footer.hidden = YES;
        }else {
            [self.goodsTableView.mj_footer endRefreshing];
            self.goodsTableView.mj_footer.hidden = NO;
        }
        
        [self.goodsTableView reloadData];
        [self.goodsTableView.mj_header endRefreshing];
        
    } failure:^(id obj) {
        [self.goodsTableView.mj_header endRefreshing];
        [self.goodsTableView.mj_footer endRefreshing];
    }];
    
}


#pragma mark - Setter/Getter
-(OrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[OrderViewModel alloc] init];
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
