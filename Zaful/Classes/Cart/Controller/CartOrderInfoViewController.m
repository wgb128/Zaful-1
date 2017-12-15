//
//  CartOrderInfoViewController.m
//  Zaful
//
//  Created by TsangFa on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartOrderInfoViewController.h"
#import "OrderInfoViewModel.h"
#import "CartCheckOutModel.h"

@interface CartOrderInfoViewController ()
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) OrderInfoViewModel        *viewModel;

@end

@implementation CartOrderInfoViewController

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*谷歌统计*/
    if (!self.firstEnter) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"Generate Order"];
        [ZFAnalytics settleInfoProcedureWithProduct:self.checkOutModel.cart_goods.goods_list step:1 option:nil screenName:@"OrderDetail"];
    }
    self.firstEnter = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    self.title = ZFLocalizedString(@"CartOrderInfo_VC_Title",nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    self.viewModel.checkOutModel = self.checkOutModel;
    [self.tableView reloadData];
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 80;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (OrderInfoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[OrderInfoViewModel alloc] init];
        _viewModel.controller = self;
        @weakify(self)
        _viewModel.refreshBlock = ^{
            @strongify(self)
            [self.tableView reloadData];
        };

    }
    return _viewModel;
}



@end
