//
//  ZFMyCouponViewController.m
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFMyCouponViewController.h"
#import "ZFMyCouponViewModel.h"
#import "ZFInitViewProtocol.h"
#import "ZFMyCouponModel.h"
#import "ZFCouponWarningView.h"

@interface ZFMyCouponViewController () <ZFInitViewProtocol> {
    ZFMyCouponModel *_applyModel;
}

@property (nonatomic, strong) UITableView *couponTableView;
@property (nonatomic, strong, nonnull) ZFMyCouponViewModel *viewModel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *couponTextField;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) ZFCouponWarningView *warningView;

@end

@implementation ZFMyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"Account_Cell_Coupon", nil);
    [self zfInitView];
    [self zfAutoLayoutView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.viewModel selectedBefore];
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    [self.view addSubview:self.couponTableView];
    [self.view addSubview:self.warningView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.couponTextField];
    [self.bottomView addSubview:self.applyButton];
    [self.view bringSubviewToFront:self.warningView];
    [self.view bringSubviewToFront:self.bottomView];
}

- (void)zfAutoLayoutView {
    [self.couponTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(56.0f);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.bottomView.mas_height);
        make.width.mas_equalTo(90.0f * SCREEN_WIDTH_SCALE);
        make.trailing.mas_equalTo(self.bottomView.mas_trailing);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom);
    }];
    
    [self.couponTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.bottomView.mas_leading).offset(15.0f);
        make.trailing.mas_equalTo(self.applyButton.mas_leading).offset(-5.0f);
        make.top.mas_equalTo(self.bottomView.mas_top).offset(5.0f);
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(-5.0f);
    }];
    
    [self.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_top);
        make.leading.mas_equalTo(self.view.mas_leading);
        make.trailing.mas_equalTo(self.view.mas_trailing);
        make.height.mas_equalTo(0.0f);
    }];
}

#pragma mark - event
- (void)applyButtonAction {
    if (self.applyCouponHandle) {
        self.applyCouponHandle(self.couponTextField.text);
    }
}

#pragma mark - getter/setter
- (UITableView *)couponTableView {
    if (!_couponTableView) {
        _couponTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _couponTableView.backgroundColor                = ZFCOLOR(245, 245, 245, 1.0);
        _couponTableView.rowHeight                      = UITableViewAutomaticDimension;
        _couponTableView.estimatedRowHeight             = 200;
        _couponTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _couponTableView.showsVerticalScrollIndicator   = NO;
        _couponTableView.showsHorizontalScrollIndicator = NO;
        _couponTableView.dataSource                     = self.viewModel;
        _couponTableView.delegate                       = self.viewModel;
    }
    return _couponTableView;
}

- (ZFMyCouponViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFMyCouponViewModel alloc] initWithAvailableCoupon:self.availableArray
                                                            disableCoupon:self.disabledArray
                                                               couponCode:self.couponCode
                                                             couponAmount:self.couponAmount];
        _viewModel.viewController = self;
        __weak ZFMyCouponViewController *weakSelf = self;
        _viewModel.itemSelectedHandle = ^(ZFMyCouponModel *model) {
            if (model == nil) {
                weakSelf.couponTextField.text = @"";
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.warningView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(0.0f);
                    }];
                    [weakSelf.view layoutIfNeeded];
                }];
            } else {
                weakSelf.couponTextField.text = model.code;
                weakSelf.warningView.couponAmount = model.pcode_amount;
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.warningView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(30.0f);
                    }];
                    [weakSelf.view layoutIfNeeded];
                }];
            }
        };
    }
    return _viewModel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (UITextField *)couponTextField {
    if (!_couponTextField) {
        _couponTextField           = [[UITextField alloc] init];
        _couponTextField.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _couponTextField.font      = [UIFont systemFontOfSize:14.0f];
        _couponTextField.placeholder = ZFLocalizedString(@"OrderDetail_CouponCode_InputplaceholderText", nil);
    }
    return _couponTextField;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.backgroundColor  = ZFCOLOR(0, 0, 0, 1.0);
        [_applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_applyButton setTitle:ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_APPLY", nil) forState:UIControlStateNormal];
        [_applyButton addTarget:self
                         action:@selector(applyButtonAction)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}

- (ZFCouponWarningView *)warningView {
    if (!_warningView) {
        _warningView = [[ZFCouponWarningView alloc] init];
    }
    return _warningView;
}

@end
