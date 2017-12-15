
//
//  ZFAddressEditWhatsAppTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/19.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditWhatsAppTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditWhatsAppTableViewCell() <ZFInitViewProtocol, UITextFieldDelegate>
@property (nonatomic, strong) UIView                *containerView;
@property (nonatomic, strong) UILabel               *whatsAppLabel;
@property (nonatomic, strong) UITextField           *enterTextField;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *tipsImageView;
@property (nonatomic, strong) UILabel               *tipsLabel;
@end

@implementation ZFAddressEditWhatsAppTableViewCell
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
    self.whatsAppLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    self.tipsLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    
    [self.tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.containerView).offset(16);
        make.top.mas_equalTo(self.containerView.mas_bottom).offset(4);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
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
        if (textField.text.length == 35 && self.isOverLength == YES) {
            if (self.addressEditWhatsappCancelOverLengthCompletionHandler) {
                self.whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
                [self.tipsImageView removeFromSuperview];
                self.addressEditWhatsappCancelOverLengthCompletionHandler([textField.text substringToIndex:textField.text.length - 1]);
            }
        } else {
            if (self.addressEditWhatsappCheckErrorCompletionHandler) {
                self.addressEditWhatsappCheckErrorCompletionHandler(NO, [textField.text substringToIndex:textField.text.length - 1]);
            }
        }
        return YES;
    } else if (![string isEqualToString:@""]){
        //增加字符
        if (textField.text.length > 34) {
            if (self.addressEditWhatsappCheckErrorCompletionHandler) {
                self.addressEditWhatsappCheckErrorCompletionHandler(YES, textField.text);
            }
            return NO;
        } else if (textField.text.length < 35) {
            
            if (self.addressEditWhatsappCheckErrorCompletionHandler) {
                self.addressEditWhatsappCheckErrorCompletionHandler(NO, [NSString stringWithFormat:@"%@%@", textField.text, string]);
            }
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (textField.text.length < 35) {
        if (self.addressEditWhatsappCancelOverLengthCompletionHandler) {
            self.whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            [self.tipsImageView removeFromSuperview];
            self.addressEditWhatsappCancelOverLengthCompletionHandler(textField.text);
        }
    }
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.whatsAppLabel];
    [self.containerView addSubview:self.enterTextField];
    [self.containerView addSubview:self.lineView];
    [self.contentView addSubview:self.tipsLabel];
}

- (void)zfAutoLayoutView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.whatsAppLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.containerView.mas_leading).offset(16);
        make.centerY.mas_equalTo(self.containerView);
    }];
    
    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.whatsAppLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.whatsAppLabel);
        make.trailing.mas_equalTo(self.containerView.mas_trailing).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.whatsAppLabel);
        make.trailing.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.whatsAppLabel sizeToFit];
    [self.whatsAppLabel setContentHuggingPriority:UILayoutPriorityRequired
                                           forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.whatsAppLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                         forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.containerView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
    }];
    
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.enterTextField.text = model.whatsapp;
}

- (void)setIsOverLength:(BOOL)isOverLength {
    _isOverLength = isOverLength;
    if (_isOverLength) {
        
        BOOL isOk = YES;
        if (self.enterTextField.text.length >= 35) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"35"];
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            [self.tipsImageView removeFromSuperview];
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Extra_Tips",nil);
            [self zfAutoLayoutView];
        }
        
    } else {
        
    }
}


- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if (self.enterTextField.text.length >= 35) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"35"];
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            self.tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Extra_Tips",nil);
            [self.tipsImageView removeFromSuperview];
            [self zfAutoLayoutView];
        }
    } else {
        self.whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        self.tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        self.tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Extra_Tips",nil);
        [self.tipsImageView removeFromSuperview];
        [self zfAutoLayoutView];
    }
}


#pragma mark - getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containerView;
}

- (UILabel *)whatsAppLabel {
    if (!_whatsAppLabel) {
        _whatsAppLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _whatsAppLabel.font = [UIFont systemFontOfSize:14];
        _whatsAppLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _whatsAppLabel.numberOfLines = 1;
        _whatsAppLabel.text = @"What's App";
    }
    return _whatsAppLabel;
}

- (UITextField *)enterTextField {
    if (!_enterTextField) {
        _enterTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _enterTextField.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _enterTextField.font = [UIFont systemFontOfSize:14];
        _enterTextField.keyboardType = UIKeyboardTypeNumberPad;
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
        _tipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _tipsLabel.font = [UIFont systemFontOfSize:12];
        _tipsLabel.numberOfLines = 2;
        _tipsLabel.text = ZFLocalizedString(@"ModifyAddress_Extra_Tips",nil);
    }
    return _tipsLabel;
}
@end
