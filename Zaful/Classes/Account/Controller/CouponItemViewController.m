//
//  CouponItemViewController.m
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CouponItemViewController.h"
#import "CouponItemViewModel.h"
#import "ZFInitViewProtocol.h"

@interface CouponItemViewController () <ZFInitViewProtocol>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *headerTitlelabel;

@property (nonatomic, strong) CouponItemViewModel *viewModel;
@end

@implementation CouponItemViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"MyCoupon_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    if ([self.kind isEqualToString:@"used"]) {
        [self.view addSubview:self.headerTitlelabel];
    }
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    if ([self.kind isEqualToString:@"used"]) {
        [self.headerTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(1);
            make.leading.trailing.mas_equalTo(self.view);
            make.height.mas_equalTo(60);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerTitlelabel.mas_bottom);
            make.leading.trailing.bottom.mas_equalTo(self.view);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
        }];
    }
}

#pragma mark - getter
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor                = ZFCOLOR(245, 245, 245, 1.0);
        _tableView.rowHeight                      = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight             = 200;
        _tableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator   = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource                     = self.viewModel;
        _tableView.delegate                       = self.viewModel;
        @weakify(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            @weakify(self)
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self)
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = NO;
                
                if([obj isEqual: NoMoreToLoad]) {
                    // 无法加载更多的时候
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                }
            } failure:^(id obj) {
                @strongify(self)
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        //footer.stateLabel.hidden = YES;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            @weakify(self)
            [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
                @strongify(self)
                [self.tableView reloadData];
                if([obj isEqual: NoMoreToLoad]) {
                    // 无法加载更多的时候
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                }else {
                    [self.tableView.mj_footer endRefreshing];
                }
            } failure:^(id obj) {
                @strongify(self)
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
    }
    return _tableView;
}

-(UILabel *)headerTitlelabel {
    if (!_headerTitlelabel) {
        _headerTitlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _headerTitlelabel.text = ZFLocalizedString(@"MyCoupon_VC_Header_Label",nil);
        _headerTitlelabel.textAlignment = NSTextAlignmentCenter;
        _headerTitlelabel.font = [UIFont systemFontOfSize:16.0];
        _headerTitlelabel.numberOfLines = 2;
        _headerTitlelabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _headerTitlelabel.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    }
    return _headerTitlelabel;
}

- (CouponItemViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CouponItemViewModel alloc]init];
        _viewModel.controller = self;
        _viewModel.kind = self.kind;
    }
    return _viewModel;
}

@end
