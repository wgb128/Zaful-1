//
//  ZFAddressEditEmailTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditEmailTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditEmailTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>

@property (nonatomic, strong) UILabel               *emailLabel;
@property (nonatomic, strong) UITextField           *enterTextField;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *tipsImageView;
@property (nonatomic, strong) UILabel               *tipsLabel;

@end

@implementation ZFAddressEditEmailTableViewCell
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
    self.emailLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.emailLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.emailLabel.mas_bottom).offset(10);
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
        
        if (textField.text.length == 60 && self.isOverLength == YES) {
            if (self.addressEditEmailCancelOverLengthCompletionHandler) {
                self.emailLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
                self.addressEditEmailCancelOverLengthCompletionHandler([textField.text substringToIndex:textField.text.length - 1]);
            }
        } else {
            if (self.addressEditEmailCheckErrorCompletionHandler) {
                self.addressEditEmailCheckErrorCompletionHandler(NO, [textField.text substringToIndex:textField.text.length - 1]);
            }
        }
        return YES;
    } else if (![string isEqualToString:@""]){
        //增加字符
        if (textField.text.length > 59) {
            if (self.addressEditEmailCheckErrorCompletionHandler) {
                self.addressEditEmailCheckErrorCompletionHandler(YES, textField.text);
            }
            return NO;
        } else if (textField.text.length < 60) {
            
            if (self.addressEditEmailCheckErrorCompletionHandler) {
                self.addressEditEmailCheckErrorCompletionHandler(NO, [NSString stringWithFormat:@"%@%@", textField.text, string]);
            }
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if(textField.text.length == 0){
        self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Email_TipLabel",nil);
        if (self.addressEditEmailCheckErrorCompletionHandler) {
            self.addressEditEmailCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 6) {
        self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"6"];
        if (self.addressEditEmailCheckErrorCompletionHandler) {
            self.addressEditEmailCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (![emailTest evaluateWithObject:textField.text]) {
        if (self.addressEditEmailCheckErrorCompletionHandler) {
            self.addressEditEmailCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 60) {
        if (self.addressEditEmailCancelOverLengthCompletionHandler) {
            self.emailLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self zfAutoLayoutView];
            self.addressEditEmailCancelOverLengthCompletionHandler(textField.text);
        }
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.emailLabel];
    [self.contentView addSubview:self.enterTextField];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.emailLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.emailLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.emailLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.emailLabel setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.emailLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.enterTextField.text = model.email ?: [AccountManager sharedManager].account.email;
    if (!model.email) {
        if (self.addressEditEmailCancelOverLengthCompletionHandler) {
            self.addressEditEmailCheckErrorCompletionHandler(NO, self.enterTextField.text);
        }
    }
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

        if(self.enterTextField.text.length == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Email_TipLabel",nil);
            isOk = NO;
        } else if (self.enterTextField.text.length < 6) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"6"];
            isOk = NO;
        } else if (![emailTest evaluateWithObject:self.enterTextField.text]) {
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Email_TipLabel", nil);
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.emailLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self zfAutoLayoutView];
        }

    } else {
        
    }
}

- (void)setIsOverLength:(BOOL)isOverLength {
    _isOverLength = isOverLength;
    if (_isOverLength) {
        BOOL isOk = YES;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        if(self.enterTextField.text.length == 0){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Email_TipLabel",nil);
            isOk = NO;
        } else if (self.enterTextField.text.length < 6) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"6"];
            isOk = NO;
        } else if (self.enterTextField.text.length >= 60) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"60"];
            isOk = NO;
        } else if (![emailTest evaluateWithObject:self.enterTextField.text]) {
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Email_TipLabel", nil);
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        }
        
    } else {
        self.emailLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        [self.tipsLabel removeFromSuperview];
        [self.tipsImageView removeFromSuperview];
        [self zfAutoLayoutView];

    }
}


#pragma mark - getter
- (UILabel *)emailLabel {
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emailLabel.font = [UIFont systemFontOfSize:14];
        _emailLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _emailLabel.text = ZFLocalizedString(@"ModifyAddress_EmailAddress_Placeholder", nil);
    }
    return _emailLabel;
}

- (UITextField *)enterTextField {
    if (!_enterTextField) {
        _enterTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _enterTextField.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _enterTextField.font = [UIFont systemFontOfSize:14];
        _enterTextField.delegate = self;
        _enterTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
