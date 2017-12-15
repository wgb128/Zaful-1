//
//  OrderDetailViewController.m
//  Zaful
//
//  Created by DBP on 17/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MyOrderDetailViewController.h"
#import "MyOrderDetailViewModel.h"

@interface MyOrderDetailViewController ()
@property (nonatomic, strong) MyOrderDetailViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"OrderDetail_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self requestData];
    [self initViews];
}

- (void)requestData {
    @weakify(self)
    [self.viewModel requestNetwork:self.orderId completion:^(id obj) {
        @strongify(self)
        
        [self.tableView reloadData];
    } failure:^(id obj) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void) initViews {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
}

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

- (MyOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyOrderDetailViewModel alloc] init];
        _viewModel.controller = self;
        _viewModel.tableView = self.tableView;
        @weakify(self)
        _viewModel.reloadOrderListBlock = ^(MyOrderDetailOrderModel *statusModel){
            @strongify(self)
            if(self.reloadOrderListBlock) {
                self.reloadOrderListBlock(statusModel);
            }

        };
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
