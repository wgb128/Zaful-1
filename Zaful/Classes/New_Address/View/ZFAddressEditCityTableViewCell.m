
//
//  ZFAddressEditCityTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditCityTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditCityTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>
@property (nonatomic, strong) UILabel           *cityLabel;
@property (nonatomic, strong) UITextField       *cityTextField;
@property (nonatomic, strong) UIImageView       *arrowView;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIImageView       *tipsImageView;
@property (nonatomic, strong) UILabel           *tipsLabel;
@end

@implementation ZFAddressEditCityTableViewCell
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
    self.cityLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    self.tipsImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.cityLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.cityLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.lineView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.tipsImageView.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.tipsImageView.mas_centerY);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
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
    if ([string isEqualToString:@""]) {
        //删除字符
        
        if (textField.text.length == 30 && self.isOverLength == YES) {
            if (self.addressEditCityCancelOverLengthCompletionHandler) {
                self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
                [self.tipsLabel removeFromSuperview];
                [self.tipsImageView removeFromSuperview];
                self.addressEditCityCancelOverLengthCompletionHandler([textField.text substringToIndex:textField.text.length - 1]);
            }
        } else {
            if (self.addressEditCityCheckErrorCompletionHandler) {
                self.addressEditCityCheckErrorCompletionHandler(NO, [textField.text substringToIndex:textField.text.length - 1]);
            }
        }
        return YES;
    } else if (![string isEqualToString:@""]){
        //增加字符
        if (textField.text.length > 29) {
            if (self.addressEditCityCheckErrorCompletionHandler) {
                self.addressEditCityCheckErrorCompletionHandler(YES, textField.text);
            }
            return NO;
        } else if (textField.text.length < 30) {
            if (self.addressEditCityCheckErrorCompletionHandler) {
                self.addressEditCityCheckErrorCompletionHandler(NO, [NSString stringWithFormat:@"%@%@", textField.text, string]);
            }
            return YES;
        }
        
    }
    return YES;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    if(textField.text.length == 0){
        self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_TipLabel",nil);
        if (self.addressEditCityCheckErrorCompletionHandler) {
            self.addressEditCityCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 3) {
        self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"3"];
        if (self.addressEditCityCheckErrorCompletionHandler) {
            self.addressEditCityCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{3,}$"] evaluateWithObject:self.cityTextField.text]){
        self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_AllNum_TipLabel",nil);
        if (self.addressEditCityCheckErrorCompletionHandler) {
            self.addressEditCityCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 30) {
        if (self.addressEditCityCancelOverLengthCompletionHandler) {
            self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            self.addressEditCityCancelOverLengthCompletionHandler(textField.text);
        }
    }

}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.cityLabel];
    [self.contentView addSubview:self.cityTextField];
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.cityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.cityLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.cityLabel);
        make.trailing.mas_equalTo(self.arrowView.mas_leading).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.cityLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.cityLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.cityLabel setContentHuggingPriority:UILayoutPriorityRequired
                                       forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.cityLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                     forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.cityTextField.text = _model.city;
    self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if([self.cityTextField.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_TipLabel",nil);
            isOk = NO;
        } else if (self.cityTextField.text.length < 3) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"3"];
            isOk = NO;
        } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{3,}$"] evaluateWithObject:self.cityTextField.text]){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_AllNum_TipLabel",nil);            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self zfAutoLayoutView];
        }

    } else {
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        [self.tipsImageView removeFromSuperview];
        [self.tipsLabel removeFromSuperview];
        [self zfAutoLayoutView];
    }
}

- (void)setHasCity:(BOOL)hasCity {
    _hasCity = hasCity;
    self.cityTextField.userInteractionEnabled = !_hasCity;
}

- (void)setIsOverLength:(BOOL)isOverLength {
    _isOverLength = isOverLength;
    if (_isOverLength) {
        
        BOOL isOk = YES;
        if([self.cityTextField.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_TipLabel",nil);
            isOk = NO;
        } else if (self.cityTextField.text.length < 3) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"3"];
            isOk = NO;
        } else if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{3,}$"] evaluateWithObject:self.cityTextField.text]){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_City_AllNum_TipLabel",nil);
            isOk = NO;
        } else if (self.cityTextField.text.length >= 30) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"30"];
            isOk = NO;
        }

        if (!isOk) {
            [self errorEnterTipsLayout];
        }
        
    } else {
        if (![NSStringUtils isEmptyString:self.model.city]) {
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
            
        }
    }
}

#pragma mark - getter
- (UILabel *)cityLabel {
    if (!_cityLabel) {
        _cityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _cityLabel.font = [UIFont systemFontOfSize:14];
        _cityLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _cityLabel.text = ZFLocalizedString(@"ModifyAddress_City_Placeholder", nil);
    }
    return _cityLabel;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _cityTextField.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _cityTextField.font = [UIFont systemFontOfSize:14];
        _cityTextField.delegate = self;
        _cityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cityTextField.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }
    return _cityTextField;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowView.image = [UIImage imageNamed:![SystemConfigUtils isRightToLeftShow] ? @"account_arrow_right" : @"account_arrow_left"];
    }
    return _arrowView;
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
