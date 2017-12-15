
//
//  ZFAddressEditNationalIDTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditNationalIDTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditNationalIDTableViewCell () <ZFInitViewProtocol, UITextFieldDelegate>
@property (nonatomic, strong) UILabel               *nationalNumberLabel;
@property (nonatomic, strong) UITextField           *enterTextField;
@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIButton              *tipsInfoButton;
@property (nonatomic, strong) UIImageView           *tipsImageView;
@property (nonatomic, strong) UILabel               *tipsLabel;
@end

@implementation ZFAddressEditNationalIDTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)tipsInfoButtonAction:(UIButton *)sender {
    if (self.addressEditNationalTipsShowCompletionHandler) {
        self.addressEditNationalTipsShowCompletionHandler();
    }
}

#pragma mark - private methods
- (void)errorEnterTipsLayout {
    self.lineView.backgroundColor = ZFCOLOR(255, 168, 0, 1.f);
    self.nationalNumberLabel.textColor = ZFCOLOR(255, 168, 0, 1.f);
    [self.contentView addSubview:self.tipsImageView];
    [self.contentView addSubview:self.tipsLabel];
    self.tipsImageView.hidden = NO;
    self.tipsLabel.hidden = NO;
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nationalNumberLabel);
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
    self.tipsInfoButton.hidden = textField.text.length > 0;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.tipsInfoButton.hidden = (textField.text.length > 0) || (string.length > 0);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    BOOL isError = NO;
    if([textField.text length] != 10){
        isError = YES;
    }
    if (self.addressEditNationalCheckErrorCompletionHandler) {
        if (!isError) {
            self.nationalNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.nationalNumberLabel);
                make.trailing.mas_equalTo(self.contentView);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
            }];
        }
        self.addressEditNationalCheckErrorCompletionHandler(isError, textField.text);
    }
    
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.nationalNumberLabel];
    [self.contentView addSubview:self.enterTextField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.tipsInfoButton];
}

- (void)zfAutoLayoutView {
    [self.nationalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.enterTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nationalNumberLabel.mas_trailing).offset(12);
        make.centerY.mas_equalTo(self.nationalNumberLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.height.mas_equalTo(30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nationalNumberLabel);
        make.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
    
    [self.tipsInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nationalNumberLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.nationalNumberLabel setContentHuggingPriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.nationalNumberLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                           forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.enterTextField.text = model.id_card;
}

- (void)setIsContinueCheck:(BOOL)isContinueCheck {
    _isContinueCheck = isContinueCheck;
    if (_isContinueCheck) {
        BOOL isOk = YES;
        if([self.enterTextField.text length] != 10){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddressViewController_cardTipLabe2", nil);
            isOk = NO;
        }
        if (!isOk) {
            [self errorEnterTipsLayout];
        } else {
            self.nationalNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
            self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
            [self.tipsImageView removeFromSuperview];
            [self.tipsLabel removeFromSuperview];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.nationalNumberLabel);
                make.trailing.mas_equalTo(self.contentView);
                make.height.mas_equalTo(0.5);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
            }];
        }
    } else {
    }
}

- (void)setIsErrorEnter:(BOOL)isErrorEnter {
    _isErrorEnter = isErrorEnter;
    if (_isErrorEnter) {
        if([self.enterTextField.text length] != 10){
            self.tipsLabel.text = ZFLocalizedString(@"ModifyAddressViewController_cardTipLabe2", nil);
        }
        [self errorEnterTipsLayout];
    } else {
        self.nationalNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
        [self.tipsImageView removeFromSuperview];
        [self.tipsLabel removeFromSuperview];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.nationalNumberLabel);
            make.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
        }];
    }
}

#pragma mark - getter
- (UILabel *)nationalNumberLabel {
    if (!_nationalNumberLabel) {
        _nationalNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nationalNumberLabel.font = [UIFont systemFontOfSize:14];
        _nationalNumberLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _nationalNumberLabel.text = ZFLocalizedString(@"ModifyAddressViewController_cardPlaceLabel", nil);
    }
    return _nationalNumberLabel;
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

- (UIButton *)tipsInfoButton {
    if (!_tipsInfoButton) {
        _tipsInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipsInfoButton setImage:[UIImage imageNamed:@"nationalID"] forState:UIControlStateNormal];
        [_tipsInfoButton addTarget:self action:@selector(tipsInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipsInfoButton;
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
