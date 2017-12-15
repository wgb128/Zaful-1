//
//  ZFPayMethodsViewController.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFPayMethodsViewModel.h"
#import "ZFPayMethodsTipsView.h"
#import "ZFPayMethodsCombinedCell.h"
#import "ZFPayMethodsUnCombinedOnlineCell.h"
#import "ZFPayMethodsUnCombinedCodCell.h"
#import "ZFPayMethodsCombinedHeaderView.h"
#import "ZFPayMethodsUnCombinedOnlineHeaderView.h"
#import "ZFPayMethodsUnCombinedCodHeaderView.h"
#import "ZFPayMethodsListModel.h"
#import "ZFPayMethodsWaysModel.h"
#import "ZFPayMethodsChildModel.h"
#import "ZFOrderCheckInfoModel.h"
#import "CheckOutGoodListModel.h"
#import "ZFOrderInfoViewController.h"
#import "ZFOrderContentViewController.h"
#import "FilterManager.h"

static NSString *const kZFPayMethodsCombinedCellIdentifier = @"kZFPayMethodsCombinedCellIdentifier";
static NSString *const kZFPayMethodsUnCombinedOnlineCellIdentifier = @"kZFPayMethodsUnCombinedOnlineCellIdentifier";
static NSString *const kZFPayMethodsUnCombinedCodCellIdentifier = @"kZFPayMethodsUnCombinedCodCellIdentifier";
static NSString *const kZFPayMethodsCombinedHeaderViewIdentifier = @"kZFPayMethodsCombinedHeaderViewIdentifier";
static NSString *const kZFPayMethodsUnCombinedOnlineHeaderViewIdentifier = @"kZFPayMethodsUnCombinedOnlineHeaderViewIdentifier";
static NSString *const kZFPayMethodsUnCombinedCodHeaderViewIdentifier = @"kZFPayMethodsUnCombinedCodHeaderViewIdentifier";

@interface ZFPayMethodsViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate> {
    __block NSInteger           _currentSelectType;
}

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) UIButton                      *doneButton;
@property (nonatomic, strong) ZFPayMethodsTipsView          *tipsView;
@property (nonatomic, strong) ZFPayMethodsViewModel         *viewModel;
@property (nonatomic, strong) ZFPayMethodsListModel         *mothodsListModel;
@property (nonatomic, strong) NSArray<ZFPayMethodsWaysModel *> *dataArray;
@property (nonatomic, copy)   NSString                      *codMsg;
@property (nonatomic,assign)  NSInteger                     currentPaymentselectedIndexPath;

@end

@implementation ZFPayMethodsViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self requestPaymentMethodsInfo];
    self.navigationController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.firstEnter) {
        [ZFAnalytics screenViewQuantityWithScreenName:@"Choose Payment Methods"];
    }
    self.firstEnter = YES;
}

#pragma mark - action methods1
- (void)doneButtonAction:(UIButton *)sender {
    [self showCODAmountList];
    
    if (_currentSelectType == 1 || _currentSelectType == 3) {
        CGFloat codGoodsTotal = [self queryCodGoodsTotal];
        
        if (codGoodsTotal < [self.mothodsListModel.cod.totalMin floatValue] ||
            codGoodsTotal > [self.mothodsListModel.cod.totalMax floatValue])
        {
            [self showAlert:[NSString stringWithFormat:ZFLocalizedString(@"OrderInfoViewModel_alertMsg_COD",nil),self.mothodsListModel.cod.totalMin,self.mothodsListModel.cod.totalMax] actionTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil)];
            return;
        }
    }

    NSDictionary *dict = @{
                           @"payCode" : @(_currentSelectType),
                           @"order_info" : @""
                           };
    
    [self.viewModel requestDoneNetwork:dict completion:^(NSArray<ZFOrderCheckInfoModel *> *dataArray) {
        NSArray<ZFOrderCheckInfoModel *> *modelArray = dataArray;
        ZFOrderContentViewController *contentVC = [[ZFOrderContentViewController alloc] init];
        switch (dataArray.count) {
            case PaymentUITypeSingle:
            {
                ZFOrderCheckInfoModel *model = modelArray.firstObject;
                contentVC.paymentUIType = PaymentUITypeSingle;
                contentVC.paymentProcessType = PaymentProcessTypeNew;
                contentVC.payCode = model.node;
                contentVC.checkoutModel = model.order_info;
                [FilterManager saveIsComb:NO];
                
                [ZFFireBaseAnalytics beginCheckOutWithGoodsInfo:contentVC.checkoutModel];
            }
                break;
            case PaymentUITypeCombine:
            {
                contentVC.paymentUIType = PaymentUITypeCombine;
                contentVC.paymentProcessType = PaymentProcessTypeNew;
                contentVC.pages = modelArray;
                [FilterManager saveIsComb:YES];
            }
                break;
        }
        [self.navigationController pushViewController:contentVC animated:YES];
        
        // firebase 统计
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Done" itemName:@"Done" ContentType:@"Payment - Way" itemCategory:@"Done"];
    } failure:^(id obj) {
        
    }];
}

#pragma mark - private methods
- (void)requestPaymentMethodsInfo {
    [self.viewModel requestNetwork:nil completion:^(id obj) {
        self.mothodsListModel = (ZFPayMethodsListModel *)obj;
        self.dataArray = self.mothodsListModel.pay_ways;
        self.codMsg = self.mothodsListModel.cod_msg;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (CGFloat)queryCodGoodsTotal {
    CGFloat codGoodsTotal = 0;
    ZFPayMethodsWaysModel *payMethodsModel = self.dataArray[_currentSelectType - 1];
    if (payMethodsModel.node == 1 || payMethodsModel.node == 3) {
        ZFPayMethodsChildModel *model = payMethodsModel.child.firstObject;
        if (model.type == 1) {
            for (CheckOutGoodListModel *listModel in model.goodsList) {
                codGoodsTotal = [listModel.subtotal floatValue] + codGoodsTotal;
            }
        }
    }
    return codGoodsTotal;
}

- (void)showAlert:(NSString *)message actionTitle:(NSString *)string {
    UIAlertController *alertController =  [UIAlertController alertControllerWithTitle:nil
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction  = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetButtonColor {
    self.doneButton.enabled = YES;
    self.doneButton.backgroundColor = ZFCOLOR(51, 51, 51, 1.f);
}

- (void)showCODAmountList {
    if (_currentSelectType == 1 || _currentSelectType == 3) {
        CGFloat codGoodsTotal = [self queryCodGoodsTotal];
        
        if (codGoodsTotal < [self.mothodsListModel.cod.totalMin floatValue] ||
            codGoodsTotal > [self.mothodsListModel.cod.totalMax floatValue])
        {
            [self showAlert:[NSString stringWithFormat:ZFLocalizedString(@"OrderInfoViewModel_alertMsg_COD",nil),self.mothodsListModel.cod.totalMin,self.mothodsListModel.cod.totalMax] actionTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil)];
            return;
        }
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZFPayMethodsWaysModel *model = self.dataArray[section];
    if (model.node == PayCodeTypeCombine) {
        return 1;
    }
    return self.dataArray[section].child.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFPayMethodsWaysModel *payMethodsModel = self.dataArray[indexPath.section];
    switch (payMethodsModel.node) {
        case PayCodeTypeCOD: // cod
        {
            ZFPayMethodsUnCombinedCodCell *codCell = [tableView dequeueReusableCellWithIdentifier:kZFPayMethodsUnCombinedCodCellIdentifier];
            codCell.model = payMethodsModel.child[indexPath.row];
            codCell.codMsg = self.codMsg;
            return codCell;
        }
            break;
        case PayCodeTypeOnline: // online
        {
            ZFPayMethodsUnCombinedOnlineCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:kZFPayMethodsUnCombinedOnlineCellIdentifier];
            onlineCell.model = payMethodsModel.child[indexPath.row];
            return onlineCell;
        }
        case PayCodeTypeCombine: // combine
        {
            ZFPayMethodsCombinedCell *combCell = [tableView dequeueReusableCellWithIdentifier:kZFPayMethodsCombinedCellIdentifier];
            combCell.model = payMethodsModel;
            combCell.codMsg = self.codMsg;
            return combCell;
        }
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZFPayMethodsWaysModel *combModel = self.dataArray[section];
    switch (combModel.node) {
        case PayCodeTypeCOD: // cod header
        {
            ZFPayMethodsUnCombinedCodHeaderView *codView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFPayMethodsUnCombinedCodHeaderViewIdentifier];
            codView.isSelect = self->_currentSelectType == PayCodeTypeCOD ? YES : NO;
            @weakify(self);
            codView.payMethodsCodSelectCompletionHandler = ^{
                @strongify(self);
                self->_currentSelectType = PayCodeTypeCOD;
                [self resetButtonColor];
                [self.tableView reloadData];
                [ZFAnalytics clickButtonWithCategory:@"Choose Payment Methods" actionName:@"Choose Payment Methods - Cash On Delivery" label:@"Choose Payment Methods - Cash On Delivery"];
                
                // firebase 统计
                [ZFFireBaseAnalytics selectContentWithItemId:@"Click_COD" itemName:@"COD" ContentType:@"Payment - Way" itemCategory:@"item"];
            };
             return codView;
        }
            break;
        case PayCodeTypeOnline: // online header
        {
            ZFPayMethodsUnCombinedOnlineHeaderView *onlineView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFPayMethodsUnCombinedOnlineHeaderViewIdentifier];
            onlineView.isSelect = self->_currentSelectType == PayCodeTypeOnline ? YES : NO;
            @weakify(self);
            onlineView.payMethodsOnlineSelectCompletionHandler = ^{
                @strongify(self);
                self->_currentSelectType = PayCodeTypeOnline;
                [self resetButtonColor];
                [self.tableView reloadData];
                [ZFAnalytics clickButtonWithCategory:@"Choose Payment Methods" actionName:@"Choose Payment Methods - Online Payment" label:@"Choose Payment Methods - Online Payment"];
                
                // firebase 统计
                [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Online" itemName:@"Online" ContentType:@"Payment - Way" itemCategory:@"item"];
            };
            return onlineView;
        }
        case PayCodeTypeCombine: // combine header
        {
            ZFPayMethodsCombinedHeaderView *combView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFPayMethodsCombinedHeaderViewIdentifier];
            combView.isSelect = self->_currentSelectType == PayCodeTypeCombine ? YES : NO;
            @weakify(self);
            combView.payMethodsCombinedSelectCompletionHandler = ^{
                @strongify(self);
                self->_currentSelectType = PayCodeTypeCombine;
                [self resetButtonColor];
                [self.tableView reloadData];
                [ZFAnalytics clickButtonWithCategory:@"Choose Payment Methods" actionName:@"Choose Payment Methods - Combined Payment" label:@"Choose Payment Methods - Combined Payment"];
                
                // firebase 统计
                [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Combined" itemName:@"Combined" ContentType:@"Payment - Way" itemCategory:@"item"];
            };
            return combView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZFPayMethodsWaysModel *combModel = self.dataArray[section];
    switch (combModel.node) {
        case PayCodeTypeCOD:
            return 68;
        case PayCodeTypeOnline:
            return 52;
        case PayCodeTypeCombine:
            return 65;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFPayMethodsWaysModel *payMethodsModel = self.dataArray[indexPath.section];
    switch (payMethodsModel.node) {
        case PayCodeTypeCOD:
            return [tableView fd_heightForCellWithIdentifier:kZFPayMethodsUnCombinedCodCellIdentifier configuration:^(ZFPayMethodsUnCombinedCodCell *codCell) {
                codCell.model = payMethodsModel.child[indexPath.row];
                codCell.codMsg = self.codMsg;
            }];
            break;
        case PayCodeTypeOnline:
            return [tableView fd_heightForCellWithIdentifier:kZFPayMethodsUnCombinedOnlineCellIdentifier configuration:^(ZFPayMethodsUnCombinedOnlineCell *onlineCell) {
                 onlineCell.model = payMethodsModel.child[indexPath.row];
            }];
            break;
        case PayCodeTypeCombine:
            return [tableView fd_heightForCellWithIdentifier:kZFPayMethodsCombinedCellIdentifier configuration:^(ZFPayMethodsCombinedCell *combCell) {
                combCell.model = payMethodsModel;
                combCell.codMsg = self.codMsg;
            }];
            break;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    self.title = ZFLocalizedString(@"ZFPaymentTitle", nil);
    [self.view addSubview:self.tipsView];
    [self.view addSubview:self.doneButton];
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - getter
- (ZFPayMethodsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFPayMethodsViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[ZFPayMethodsCombinedCell class] forCellReuseIdentifier:kZFPayMethodsCombinedCellIdentifier];
        [_tableView registerClass:[ZFPayMethodsUnCombinedOnlineCell class] forCellReuseIdentifier:kZFPayMethodsUnCombinedOnlineCellIdentifier];
        [_tableView registerClass:[ZFPayMethodsUnCombinedCodCell class] forCellReuseIdentifier:kZFPayMethodsUnCombinedCodCellIdentifier];
        [_tableView registerClass:[ZFPayMethodsCombinedHeaderView class] forHeaderFooterViewReuseIdentifier:kZFPayMethodsCombinedHeaderViewIdentifier];
        [_tableView registerClass:[ZFPayMethodsUnCombinedOnlineHeaderView class] forHeaderFooterViewReuseIdentifier:kZFPayMethodsUnCombinedOnlineHeaderViewIdentifier];
        [_tableView registerClass:[ZFPayMethodsUnCombinedCodHeaderView class] forHeaderFooterViewReuseIdentifier:kZFPayMethodsUnCombinedCodHeaderViewIdentifier];
    }
    return _tableView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:ZFLocalizedString(@"Category_Done", nil) forState:UIControlStateNormal];
        [_doneButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        _doneButton.enabled = NO;
        _doneButton.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        [_doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (ZFPayMethodsTipsView *)tipsView {
    if (!_tipsView) {
        _tipsView = [[ZFPayMethodsTipsView alloc] init];
    }
    return _tipsView;
}
@end
