//
//  CurrencyViewController.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CurrencyViewController.h"
#import "GoodsSortCell.h"
#import "CurrencyViewModel.h"
#import "ZFInitViewProtocol.h"


@interface CurrencyViewController () <ZFInitViewProtocol>

@property (nonatomic, strong) UITableView    * tableView;
@property (nonatomic, strong) NSString       * currencyString;
@property (nonatomic, strong) CurrencyViewModel *viewModel;

@end

@implementation CurrencyViewController

@synthesize rowDescriptor = _rowDescriptor;
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewModel requestData];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"Currency_VC_Title",nil);
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"currencyCell"];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
    }
    return _tableView;
}

- (CurrencyViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[CurrencyViewModel alloc] init];
        _viewModel.controller = self;
        _viewModel.tableView = _tableView;
        @weakify(self)
        _viewModel.selectCurrencyBlock = ^(NSString *currency) {
            @strongify(self)
            self.rowDescriptor.value = currency;
        };
    }
    return _viewModel;
}

@end
