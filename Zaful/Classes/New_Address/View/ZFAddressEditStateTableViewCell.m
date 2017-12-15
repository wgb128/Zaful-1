//
//  ZFAddressEditStateTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditStateTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditStateTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>
@property (nonatomic, strong) UILabel           *stateLabel;
@property (nonatomic, strong) UITextField       *stateTextField;
@property (nonatomic, strong) UIImageView       *arrowView;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIImageView       *tipsImageView;
@property (nonatomic, strong) UILabel           *tipsLabel;
@end

@implementation ZFAddressEditStateTableViewCell
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
    self.stateLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    self.tipsImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stateLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.stateLabel.mas_bottom).offset(10);
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
        
        if (textField.text.length == 32 && self.isOverLength == YES) {
            if (self.addressEditStateCancelOverLengthCompletionHandler) {
                self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
                [self.tipsLabel removeFromSuperview];
                [self.tipsImageView removeFromSuperview];
                self.addressEditStateCancelOverLengthCompletionHandler([textField.text substringToIndex:textField.text.length - 1]);
            }
        } else {

            if (self.addressEditStateCheckErrorCompletionHandler) {
                self.addressEditStateCheckErrorCompletionHandler(NO, [textField.text substringToIndex:textField.text.length - 1]);
            }
        }
        return YES;
    } else if (![string isEqualToString:@""]){
        //增加字符
        if (textField.text.length > 31) {
            if (self.addressEditStateCheckErrorCompletionHandler) {
                self.addressEditStateCheckErrorCompletionHandler(YES, textField.text);
            }
            return NO;
        } else if (textField.text.length < 32) {
            if (self.addressEditStateCheckErrorCompletionHandler) {
                self.addressEditStateCheckErrorCompletionHandler(NO, [NSString stringWithFormat:@"%@%@", textField.text, string]);
            }
            return YES;
        }
        
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    if(textField.text.length == 0){
        self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_State_TipLabel",nil);
        if (self.addressEditStateCheckErrorCompletionHandler) {
            self.addressEditStateCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 2) {
        self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
        if (self.addressEditStateCheckErrorCompletionHandler) {
            self.addressEditStateCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 32) {
        if (self.addressEditStateCancelOverLengthCompletionHandler) {
            self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            self.addressEditStateCancelOverLengthCompletionHandler(textField.text);
        }
    }

}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.stateTextField];
    [self.contentView addSubview:self.arrowView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.stateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stateLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.stateLabel);
        make.trailing.mas_equalTo(self.arrowView.mas_leading).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.stateLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.stateLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.stateLabel setContentHuggingPriority:UILayoutPriorityRequired
                                         forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.stateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter 
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.stateTextField.text = _model.province;
    self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
}

- (void)setHasProvince:(BOOL)hasProvince {
    _hasProvince = hasProvince;
    self.stateTextField.userInteractionEnabled = !_hasProvince;
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if([self.stateTextField.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_State_TipLabel",nil);
            isOk = NO;
        } else if (self.stateTextField.text.length < 2) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self zfAutoLayoutView];
        }

    } else {
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        [self.tipsImageView removeFromSuperview];
        [self.tipsLabel removeFromSuperview];
        [self zfAutoLayoutView];
//        if (![NSStringUtils isEmptyString:self.model.province_id]) {
//            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
//            self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
//            [self.tipsImageView removeFromSuperview];
//            [self.tipsLabel removeFromSuperview];
//            [self zfAutoLayoutView];
//
//        }

    }
}

- (void)setIsOverLength:(BOOL)isOverLength {
    _isOverLength = isOverLength;
    if (_isOverLength) {
        BOOL isOk = YES;
        if([self.stateTextField.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_State_TipLabel",nil);
            isOk = NO;
        } else if (self.stateTextField.text.length < 2) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
            isOk = NO;
        } else if (self.stateTextField.text.length >= 32) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"32"];
            isOk = NO;
        }

        if (!isOk) {
            [self errorEnterTipsLayout];
        } 
        
        
    } else {
        if (![NSStringUtils isEmptyString:self.model.province]) {
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
        }
    }
}

#pragma mark - getter
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _stateLabel.text = ZFLocalizedString(@"ModifyAddress_State_Placeholder", nil);
    }
    return _stateLabel;
}

- (UITextField *)stateTextField {
    if (!_stateTextField) {
        _stateTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _stateTextField.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _stateTextField.font = [UIFont systemFontOfSize:14];
        _stateTextField.delegate = self;
        _stateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _stateTextField.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentLeft : NSTextAlignmentRight;
    }
    return _stateTextField;
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
