
//
//  ZFAddressEditPhoneNumberTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditPhoneNumberTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditPhoneNumberTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>

@property (nonatomic, strong) UILabel               *phoneNumberLabel;
@property (nonatomic, strong) UILabel               *codeLabel;
@property (nonatomic, strong) UIView                *sepLineView;
@property (nonatomic, strong) ZFButton              *countryCodeButton; //运营号
@property (nonatomic, strong) UITextField           *enterTextField;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *tipsImageView;
@property (nonatomic, strong) UILabel               *tipsLabel;

@end

@implementation ZFAddressEditPhoneNumberTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (void)errorEnterTipsLayout {
    self.lineView.backgroundColor = ZFCOLOR(255, 168, 0, 1.f);
    self.phoneNumberLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    self.tipsImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneNumberLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.phoneNumberLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tipsImageView.mas_trailing);
        make.centerY.mas_equalTo(self.tipsImageView.mas_centerY);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
}


#pragma mark - action methods
- (void)countryCodeSelectAction:(UIButton *)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (self.addressCountryCodeSelectCompletionHandler) {
        self.addressCountryCodeSelectCompletionHandler();
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)Textfield {
    [Textfield resignFirstResponder];//关闭键盘
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.enterTextField]) {
        if (!self.model.country_id || [NSStringUtils isEmptyString:self.model.country_str]) {
            if (self.addressEditSelctCountryFirstTipsCompletionHandler) {
                self.addressEditSelctCountryFirstTipsCompletionHandler();
            }
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    BOOL isError = NO;
    if(textField.text.length <= 0){
        isError = YES;
    }else if (self.model.configured_number == 1 && (textField.text.length != [self.model.number integerValue]) ) {  // 有限制号码长度     只要当前输入长度不等于number就提示
        isError = YES;
    }else if (self.model.configured_number == 0 && textField.text.length > [self.model.number integerValue]){       // 没有限制号码长度   电话号码长度最大不能超过 13位
        isError = YES;
    }
    
    if (self.addressEditPhoneNumberCheckErrorCompletionHandler) {
        if (!isError) {
            self.phoneNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        }
        NSString *realNumber = @"";
        if (![self.countryCodeButton.titleLabel.text isEqualToString:ZFLocalizedString(@"ModifyAddress_Supplier_Placeholder", nil)]) {
            realNumber = [NSString stringWithFormat:@"%@%@", self.countryCodeButton.titleLabel.text, textField.text];
        }
        self.addressEditPhoneNumberCheckErrorCompletionHandler(isError, textField.text, realNumber);
    }
    
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.codeLabel];
    [self.contentView addSubview:self.sepLineView];
    [self.contentView addSubview:self.countryCodeButton];
    [self.contentView addSubview:self.enterTextField];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneNumberLabel.mas_trailing).offset(6);
        make.centerY.mas_equalTo(self.phoneNumberLabel);
        make.size.mas_equalTo(CGSizeMake(45, 40));
    }];
    
    [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.codeLabel.mas_trailing).offset(6);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.lineView.mas_top).offset(-10);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.countryCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.sepLineView.mas_trailing).offset(24);
        make.centerY.mas_equalTo(self.phoneNumberLabel);
    }];

    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.countryCodeButton.mas_trailing).offset(8);
        make.centerY.mas_equalTo(self.phoneNumberLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneNumberLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.enterTextField.text = _model.tel;
    self.phoneNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneNumberLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    self.tipsImageView.hidden = YES;
    if ([NSStringUtils isEmptyString:_model.code]) {
        self.codeLabel.hidden = YES;
        self.sepLineView.hidden = YES;
        [self.phoneNumberLabel setContentHuggingPriority:UILayoutPriorityRequired
                                                 forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.phoneNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                               forAxis:UILayoutConstraintAxisHorizontal];
    } else {
        self.codeLabel.hidden = NO;
        self.sepLineView.hidden = NO;
        self.codeLabel.text = ![SystemConfigUtils isRightToLeftShow] ? [NSString stringWithFormat:@"+%@",_model.code] : [NSString stringWithFormat:@"%@+",_model.code];
        
        [self.enterTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.sepLineView.mas_trailing).offset(8);
            make.centerY.mas_equalTo(self.phoneNumberLabel);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        [self.phoneNumberLabel setContentHuggingPriority:UILayoutPriorityRequired
                                                 forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.phoneNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                               forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    if (![NSStringUtils isEmptyString:_model.supplier_number_list]) {
        self.countryCodeButton.hidden = NO;
        if ([NSStringUtils isEmptyString:_model.supplier_number]) {
            [self.countryCodeButton setTitle:ZFLocalizedString(@"ModifyAddress_Supplier_Placeholder", nil) forState:UIControlStateNormal];
        } else {
            [self.countryCodeButton setTitle:_model.supplier_number forState:UIControlStateNormal];
            [self.countryCodeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.sepLineView.mas_trailing).offset(18);
                make.centerY.mas_equalTo(self.phoneNumberLabel);
                make.width.mas_equalTo(40);
            }];
        }
        
        [self.countryCodeButton setContentHuggingPriority:UILayoutPriorityRequired
                                                 forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.countryCodeButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                               forAxis:UILayoutConstraintAxisHorizontal];
        
        
        if (![SystemConfigUtils isRightToLeftShow]) {
            self.countryCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.countryCodeButton.titleLabel.width / 2 + self.countryCodeButton.imageView.width, 0, -(self.countryCodeButton.titleLabel.width / 2 + self.countryCodeButton.imageView.width));
            self.countryCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.countryCodeButton.imageView.width + self.countryCodeButton.titleLabel.width / 2), 0, self.countryCodeButton.imageView.width + self.countryCodeButton.titleLabel.width / 2);
        } else {
            self.countryCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -self.countryCodeButton.titleLabel.width / 2 + self.countryCodeButton.imageView.width, 0, (self.countryCodeButton.titleLabel.width / 2 + self.countryCodeButton.imageView.width));
            self.countryCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, (self.countryCodeButton.imageView.width + self.countryCodeButton.titleLabel.width / 2), 0, -(self.countryCodeButton.imageView.width + self.countryCodeButton.titleLabel.width / 2));
            
        }
        
        [self.enterTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.countryCodeButton.mas_trailing).offset(4);
            make.centerY.mas_equalTo(self.phoneNumberLabel);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        
    } else {
        self.countryCodeButton.hidden = YES;
    }
    
    if ([NSStringUtils isEmptyString:_model.code] && [NSStringUtils isEmptyString:_model.supplier_number_list]) {
        [self.enterTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.phoneNumberLabel.mas_trailing).offset(8);
            make.centerY.mas_equalTo(self.phoneNumberLabel);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        [self.phoneNumberLabel setContentHuggingPriority:UILayoutPriorityRequired
                                                 forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.phoneNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                               forAxis:UILayoutConstraintAxisHorizontal];

    }
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if([self.enterTextField.text length] <= 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Phone_TipLabel",nil);
            isOk = NO;
        }else if (self.model.configured_number && (self.enterTextField.text.length != [self.model.number integerValue]) ) {  // 有限制号码长度     只要当前输入长度不等于number就提示
            self.tipsLabel.text =  [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),self.model.number];
            isOk = NO;
        }else if (!self.model.configured_number && self.enterTextField.text.length > [self.model.number integerValue]){       // 没有限制号码长度   电话号码长度最大不能超过 13位
            self.tipsLabel.text =  [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_include_Digits",nil),self.model.number];
            isOk = NO;
        } else if (![NSStringUtils isEmptyString:self.model.supplier_number_list] && self.model.supplier_number.length <= 0) {
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Supplier_TipLabel",nil);
            isOk = NO;
        }

        if (!isOk) {
            [self errorEnterTipsLayout];
        }
    } else {

    }
}

- (void)setIsErrorEnter:(BOOL)isErrorEnter {
    _isErrorEnter = isErrorEnter;
    if (_isErrorEnter) {
        if([self.enterTextField.text length] <= 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Phone_TipLabel",nil);
        }else if (self.model.configured_number && (self.enterTextField.text.length != [self.model.number integerValue]) ) {  // 有限制号码长度     只要当前输入长度不等于number就提示
            self.tipsLabel.text =  [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),self.model.number];
            
        }else if (!self.model.configured_number && self.enterTextField.text.length > [self.model.number integerValue]){       // 没有限制号码长度   电话号码长度最大不能超过 13位
            self.tipsLabel.text =  [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_include_Digits",nil),self.model.number];
        }
        [self errorEnterTipsLayout];
    } else {

    }

}

#pragma mark - getter
- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumberLabel.font = [UIFont systemFontOfSize:14];
        _phoneNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _phoneNumberLabel.text = ZFLocalizedString(@"ModifyAddress_PhoneNum_Placeholder", nil);
        _phoneNumberLabel.numberOfLines = 1;
        [_phoneNumberLabel sizeToFit];
    }
    return _phoneNumberLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _codeLabel.font = [UIFont systemFontOfSize:14];
        _codeLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _codeLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
        _codeLabel.numberOfLines = 1;
        [_codeLabel sizeToFit];
    }
    return _codeLabel;
}

- (UIView *)sepLineView {
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _sepLineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _sepLineView;
}

- (ZFButton *)countryCodeButton {
    if (!_countryCodeButton) {
        _countryCodeButton = [ZFButton buttonWithType:UIButtonTypeCustom];
        [_countryCodeButton setTitle:ZFLocalizedString(@"ModifyAddress_Supplier_Placeholder", nil) forState:UIControlStateNormal];
        _countryCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_countryCodeButton setTitleColor:ZFCOLOR_BLACK forState:UIControlStateNormal];
        [_countryCodeButton setImage:[UIImage imageNamed:@"drop_down"] forState:UIControlStateNormal];
        [_countryCodeButton addTarget:self action:@selector(countryCodeSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [_countryCodeButton sizeToFit];
    

    }
    return _countryCodeButton;
}

- (UITextField *)enterTextField {
    if (!_enterTextField) {
        _enterTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _enterTextField.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _enterTextField.font = [UIFont systemFontOfSize:14];
        _enterTextField.delegate = self;
        _enterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _enterTextField.keyboardType = UIKeyboardTypeNumberPad;
        _enterTextField.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }
    return _enterTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (UIImageView *)tipsImageView {
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"!"]];
        
    }
    return _tipsImageView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipsLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipsLabel;
}
@end
