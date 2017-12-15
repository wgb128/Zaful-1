//
//  ZFPaymentStatusViewController.m
//  Zaful
//
//  Created by TsangFa on 2017/10/12.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import "ZFPaymentStatusViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFPaymentStatusWaitForPayTableViewCell.h"
#import "ZFPaymentStatusPaySuccessTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VerificationView.h"
#import "ZFPaymentView.h"
#import "ZFOrderCheckDoneModel.h"
#import "ZFOrderCheckDoneDetailModel.h"
#import "ZFOrderManager.h"
#import "ZFOrderInformationViewModel.h"
#import "MyOrdersListViewController.h"

// 支付方式
typedef NS_ENUM(NSUInteger, PaymentType){
    // cod 支付
    PaymentTypeCOD      = 1,
    // online 支付
    PaymentTypeOnline   = 2
};

// cell 类型
typedef NS_ENUM(NSUInteger, TableViewCellType){
    // cod
    TableViewCellTypeCOD      = 0,
    // online
    TableViewCellTypeOnline   = 1
};

static NSString *const kZFPaymentStatusWaitForPayTableViewCellIdentifier = @"kZFPaymentStatusWaitForPayTableViewCellIdentifier";
static NSString *const kZFPaymentStatusPaySuccessTableViewCellIdentifier = @"kZFPaymentStatusPaySuccessTableViewCellIdentifier";

@interface ZFPaymentStatusViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) UIButton                      *optionButton;
@property (nonatomic, strong) ZFOrderInformationViewModel   *viewModel;
@end

@implementation ZFPaymentStatusViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Setter
- (void)setDataArray:(NSArray<ZFOrderCheckDoneModel *> *)dataArray {
    _dataArray = dataArray;
    for (ZFOrderCheckDoneModel *model in dataArray) {
        model.isSuccess = NO;
        model.order_info.payState = PaymentStateTypeWaite;
        if (model.node == PaymentTypeCOD) {
            model.order_info.payName = ZFLocalizedString(@"ZFPaymentCod", nil);
        }else if (model.node == PaymentTypeOnline){
            model.order_info.payName = ZFLocalizedString(@"ZFPaymentOnline", nil);
        }
    }
}

#pragma mark - action methods
- (void)optionButtonAction:(UIButton *)sender {
    if (self.payStatesBlock) {
        self.payStatesBlock();
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFOrderCheckDoneModel *cellModel = self.dataArray[indexPath.row];
    if (cellModel.isSuccess) {
        // 加载 成功 cell
        ZFPaymentStatusPaySuccessTableViewCell *successCell = [tableView dequeueReusableCellWithIdentifier:kZFPaymentStatusPaySuccessTableViewCellIdentifier];
        successCell.model = cellModel.order_info;
        return successCell;
    }else{
        // 加载 等待或失败 cell
        ZFPaymentStatusWaitForPayTableViewCell *failureCell = [tableView dequeueReusableCellWithIdentifier:kZFPaymentStatusWaitForPayTableViewCellIdentifier];
        failureCell.model = cellModel.order_info;
        return failureCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFOrderCheckDoneModel *cellModel = self.dataArray[indexPath.row];
    if (cellModel.isSuccess) {
        return [tableView fd_heightForCellWithIdentifier:kZFPaymentStatusPaySuccessTableViewCellIdentifier configuration:^(ZFPaymentStatusPaySuccessTableViewCell *successCell) {
            successCell.model = cellModel.order_info;
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:kZFPaymentStatusWaitForPayTableViewCellIdentifier configuration:^(ZFPaymentStatusWaitForPayTableViewCell *failureCell) {
            failureCell.model = cellModel.order_info;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFOrderCheckDoneModel *cellModel = self.dataArray[indexPath.row];
    if (!cellModel.isSuccess) {
        switch (cellModel.node) {
            case PaymentTypeCOD:
            {
                [self showCODPay];
            }
                break;
            case PaymentTypeOnline:
            {
                [self showOnlinePay];
            }
                break;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Private method
- (void)showCODPay {
    ZFOrderManager *codManager = self.managerArray.firstObject;
    ZFOrderCheckDoneModel *codModel = self.dataArray.firstObject;
    codManager.node = [NSString stringWithFormat:@"%lu",(unsigned long)PaymentTypeCOD];
    codManager.orderID = codModel.order_info.order_id;
    VerificationView *verifView = [[VerificationView alloc]initWithTitle:[codManager queryCashOnDelivery] andCode:codManager.addressCode andphoneNum:[NSString stringWithFormat:@"%@%@",NullFilter(codManager.supplierNumber),codManager.tel]];
    @weakify(verifView)
    // 发送验证码到手机
    verifView.sendCodeBlock = ^{
        @strongify(verifView)
        [self.viewModel sendPhoneCod:codManager.addressId completion:^(id obj) {
            verifView.codeBlock = ^(NSString *codeStr) { // 验证手机码
                codManager.verifyCode = codeStr;
                NSMutableDictionary *codDict = [NSMutableDictionary dictionaryWithDictionary:[self.viewModel queryCheckDonePublicParmas:codManager]];
                [codDict setObject:@"1"  forKey:@"isCod"];
                NSDictionary *parmas = @{
                                         @"payCode"     : @"3",
                                         @"order_info"  : @[codDict]
                                         };
                [self.viewModel requestCheckDoneOrder:parmas completion:^(NSArray<ZFOrderCheckDoneModel *> *dataArray) {
                    ZFOrderCheckDoneModel *checkDoneModel = (ZFOrderCheckDoneModel *)dataArray.firstObject;
                    ZFOrderCheckDoneDetailModel *checkDoneDetailModel = checkDoneModel.order_info;
                    if (checkDoneDetailModel.error == 0) {
                        @strongify(verifView)
                        [verifView dismiss];
                        codModel.isSuccess = YES;
                        [self reSetButton];
                        [self reloadCell:TableViewCellTypeCOD];
                    }else{
                        @strongify(verifView)
                        verifView.isCodeSuccess = NO;
                        codModel.isSuccess = NO;
                    }
                } failure:^(id obj) {
                    @strongify(verifView)
                    verifView.isCodeSuccess = NO;
                    codModel.isSuccess = NO;
                }];
            };
        } failure:^(id obj) {
            codModel.isSuccess = NO;
        }];
    };
    [verifView show];
}

- (void)showOnlinePay {
    ZFOrderCheckDoneModel *onlineModel = self.dataArray.lastObject;
    [self showWebView:onlineModel.order_info resetModel:onlineModel];
}

- (void)showWebView:(ZFOrderCheckDoneDetailModel *)checkDoneDetailModel resetModel:(ZFOrderCheckDoneModel *)onlineModel{
    ZFPaymentView *ppView = [[ZFPaymentView alloc] initWithFrame:CGRectZero];
    ppView.url = checkDoneDetailModel.pay_url;
    @weakify(self);
    ppView.block = ^(PaymentStatus status){
        @strongify(self)
        switch (status) {
            case PaymentStatusDone:
            {
                onlineModel.isSuccess = YES;
                [self reSetButton];
                [self reloadCell:TableViewCellTypeOnline];
            }
                break;
            case PaymentStatusCancel:
            case PaymentStatusUnknown:
            case PaymentStatusFail:
            {
                onlineModel.isSuccess = NO;
                onlineModel.order_info.payState = PaymentStateTypeFailure;
                [self reloadCell:TableViewCellTypeOnline];
            }
                break;
        }
    };
    [ppView show];
}

- (void)reloadCell:(NSInteger)row {
    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)reSetButton {
    [self.optionButton setTitle:ZFLocalizedString(@"OrderFailure_VC_Account_Button", nil) forState:UIControlStateNormal];
    self.optionButton.backgroundColor = ZFCOLOR(51, 51, 51, 1);
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    self.title = ZFLocalizedString(@"OrderDetail_Delivery_Cell_Payment", nil);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.optionButton];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 48, 0));
    }];
    
    [self.optionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = ZFCOLOR(241, 241, 241, 1.f);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 16, 0);
        [_tableView registerClass:[ZFPaymentStatusPaySuccessTableViewCell class] forCellReuseIdentifier:kZFPaymentStatusPaySuccessTableViewCellIdentifier];
        [_tableView registerClass:[ZFPaymentStatusWaitForPayTableViewCell class] forCellReuseIdentifier:kZFPaymentStatusWaitForPayTableViewCellIdentifier];
    }
    return _tableView;
}

- (UIButton *)optionButton {
    if (!_optionButton) {
        _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_optionButton setTitle:ZFLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_optionButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        _optionButton.backgroundColor = ZFCOLOR(135, 135, 135, 1);
        [_optionButton addTarget:self action:@selector(optionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _optionButton;
}

- (ZFOrderInformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFOrderInformationViewModel alloc] init];
    }
    return _viewModel;
}

@end
