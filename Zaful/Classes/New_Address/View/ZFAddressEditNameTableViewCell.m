
//
//  ZFAddressEditNameTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditNameTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditNameTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>

@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UITextField           *enterTextField;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *tipsImageView;
@property (nonatomic, strong) UILabel               *tipsLabel;

@end


@implementation ZFAddressEditNameTableViewCell
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
    self.nameLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-25);
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
            if (self.addressEditNameCancelOverLengthCompletionHandler) {
                self.nameLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
                self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
                [self.tipsLabel removeFromSuperview];
                [self.tipsImageView removeFromSuperview];
                self.addressEditNameCancelOverLengthCompletionHandler([textField.text substringToIndex:textField.text.length - 1]);
            }
        } else {
            if (self.addressEditNameCheckErrorCompletionHandler) {
                self.addressEditNameCheckErrorCompletionHandler(NO, [textField.text substringToIndex:textField.text.length - 1]);
            }
        }
        return YES;
    } else if (![string isEqualToString:@""]){
        //增加字符
        if (textField.text.length > 31) {
            if (self.addressEditNameCheckErrorCompletionHandler) {
                self.addressEditNameCheckErrorCompletionHandler(YES, textField.text);
            }
            return NO;
        } else if (textField.text.length < 32) {
            if (self.addressEditNameCheckErrorCompletionHandler) {
                self.addressEditNameCheckErrorCompletionHandler(NO, [NSString stringWithFormat:@"%@%@", textField.text, string]);
            }
            return YES;
        }
        
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (textField.text.length == 0) {
        self.tipsLabel.text = ZFLocalizedString(self.addressNameType == ZFAddressNameTypeFirstName ? @"ModifyAddress_FirstName_TipLabel" : @"ModifyAddress_LastName_TipLabel",nil);
        if (self.addressEditNameCheckErrorCompletionHandler) {
            self.addressEditNameCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length == 1) {
        self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
        if (self.addressEditNameCheckErrorCompletionHandler) {
            self.addressEditNameCheckErrorCompletionHandler(YES, textField.text);
        }
    } else if (textField.text.length < 32) {
        if (self.addressEditNameCancelOverLengthCompletionHandler) {
            self.nameLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.nameLabel);
                make.trailing.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
                make.height.mas_equalTo(0.5);
            }];
            self.addressEditNameCancelOverLengthCompletionHandler(textField.text);
        }
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.enterTextField];
    [self.contentView addSubview:self.lineView];

}

- (void)zfAutoLayoutView {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.height.mas_equalTo(30).priorityHigh();
    }];
    
    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.nameLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.nameLabel sizeToFit];
    [self.nameLabel setContentHuggingPriority:UILayoutPriorityRequired
                                      forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                    forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setAddressNameType:(ZFAddressNameType)addressNameType {
    _addressNameType = addressNameType;
    self.nameLabel.text = _addressNameType == ZFAddressNameTypeFirstName ? ZFLocalizedString(@"ModifyAddress_FristName_Placeholder", nil) : ZFLocalizedString(@"ModifyAddress_LastName_Placeholder", nil);
}

- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.enterTextField.text = self.addressNameType == ZFAddressNameTypeFirstName ? model.firstname : model.lastname;
    if ([self.enterTextField.text length] == 1) {
        self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
    } else if ([self.enterTextField.text length] == 0){
        self.tipsLabel.text = ZFLocalizedString(self.addressNameType == ZFAddressNameTypeFirstName ? @"ModifyAddress_FirstName_TipLabel" : @"ModifyAddress_LastName_TipLabel",nil);
    } else {

    }

}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if (self.enterTextField.text.length == 1) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
            isOk = NO;
        }else if(self.enterTextField.text.length == 0){
            self.tipsLabel.text = ZFLocalizedString(self.addressNameType == ZFAddressNameTypeFirstName ? @"ModifyAddress_FirstName_TipLabel" : @"ModifyAddress_LastName_TipLabel",nil);
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.nameLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsLabel removeFromSuperview];
            [self.tipsImageView removeFromSuperview];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.nameLabel);
                make.trailing.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
                make.height.mas_equalTo(0.5);
            }];
            [self zfAutoLayoutView]; 
        }
    } else {
        [self zfAutoLayoutView];
    }
}

- (void)setIsOverLength:(BOOL)isOverLength {
    _isOverLength = isOverLength;
    if (_isOverLength) {
        BOOL isOk = YES;
        if ([self.enterTextField.text length] == 1) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Minimum_TipLabel",nil),@"2"];
            isOk = NO;
        }else if([self.enterTextField.text length] == 0){
            self.tipsLabel.text = ZFLocalizedString(self.addressNameType == ZFAddressNameTypeFirstName ? @"ModifyAddress_FirstName_TipLabel" : @"ModifyAddress_LastName_TipLabel",nil);
            isOk = NO;
        } else if (self.enterTextField.text.length >= 32) {
            self.tipsLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"ModifyAddress_Maxmum_TipLabel",nil),@"32"];
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        }
    } else {
        [self zfAutoLayoutView];
    }
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _nameLabel.numberOfLines = 1;
        
    }
    return _nameLabel;
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
