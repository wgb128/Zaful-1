//
//  ZFOrderPointsCell.m
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderPointsCell.h"
#import "ZFInitViewProtocol.h"
#import "NoPasteTextFiled.h"
#import "FilterManager.h"
#import "PointModel.h"

@interface ZFOrderPointsCell()<ZFInitViewProtocol,UITextFieldDelegate>
@property (nonatomic, strong) YYAnimatedImageView       *pointsIcon;
@property (nonatomic, strong) UILabel                   *infoLabel;
@property (nonatomic, strong) ZFButton                  *helpButton;
@property (nonatomic, strong) NoPasteTextFiled          *inputTextField;
@property (nonatomic, strong) UILabel                   *amountLabel;
@end

@implementation ZFOrderPointsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.pointsIcon];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.helpButton];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.inputTextField];
}

- (void)zfAutoLayoutView {
    [self.pointsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-15).priorityLow();
        make.size.mas_equalTo(CGSizeMake(20, 22));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.pointsIcon.mas_trailing).offset(12);
        make.centerY.equalTo(self.pointsIcon);
    }];
    
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoLabel.mas_trailing).offset(0);
        make.centerY.equalTo(self.infoLabel);
        make.size.mas_equalTo(CGSizeMake(40, 60));
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-12);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.amountLabel.mas_leading).offset(-8);
        make.centerY.equalTo(self.amountLabel);
        make.size.mas_equalTo(CGSizeMake(60, 28));
    }];
}

#pragma mark - Setter
- (void)setPointModel:(PointModel *)pointModel {
    _pointModel = pointModel;
    NSString *amount = [FilterManager adapterCodWithAmount:[NSString stringWithFormat:@"%.2f",[pointModel.currentPoint integerValue] * 0.02]andCod:self.isCod];
    self.amountLabel.text = [NSString stringWithFormat:@"- %@",amount];
    self.inputTextField.text = [NSString stringWithFormat:@"%ld",(long)[pointModel.currentPoint integerValue]];
}

- (void)showPointsDetail {
    if (self.pointsShowHelpBlock) {
        NSString *instructionPrice = [FilterManager adapterCodWithAmount:[NSString stringWithFormat:@"%.2f",[self.pointModel.use_point_max integerValue] * 0.02] andCod:self.isCod];
        NSString *tips = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),self.pointModel.avail_point,self.pointModel.use_point_max,instructionPrice];
        self.pointsShowHelpBlock(tips);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *inputReward = @"";
    if ([textField.text integerValue] > [self.pointModel.use_point_max integerValue]) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfo_RewardsCell_MaxPoint",nil)];
        [textField showCurrentViewBorder:MIN_PIXEL * 2 color:[UIColor redColor]];
        inputReward = self.pointModel.use_point_max;
    }else{
        inputReward = textField.text;
    }
    
    NSString *amount = [NSString stringWithFormat:@"%.2f",[inputReward integerValue] * 0.02];
    
   NSString *result = [FilterManager adapterCodWithAmount:amount andCod:self.isCod];
    
    self.amountLabel.text = [NSString stringWithFormat:@"- %@",result];

    if (self.pointsInputBlock) {
        self.pointsInputBlock(amount, inputReward);
    }
    
    [self.contentView endEditing:YES];
}

#pragma mark - Getter
- (YYAnimatedImageView *)pointsIcon {
    if (!_pointsIcon) {
        _pointsIcon = [YYAnimatedImageView new];
        _pointsIcon.image = [UIImage imageNamed:@"points"];
    }
    return _pointsIcon;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont boldSystemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _infoLabel.text = ZFLocalizedString(@"CartOrderInfo_RewardsCell_RewardLabel",nil);
        [_infoLabel sizeToFit];
    }
    return _infoLabel;
}

- (ZFButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [ZFButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:[UIImage imageNamed:@"nationalID"] forState:UIControlStateNormal];
        _helpButton.titleRect = CGRectZero;
        _helpButton.imageRect = CGRectMake(8, 24, 12, 12);
        [_helpButton addTarget:self action:@selector(showPointsDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}

- (NoPasteTextFiled *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[NoPasteTextFiled alloc] init];
        _inputTextField.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _inputTextField.font = [UIFont boldSystemFontOfSize:14];
        _inputTextField.delegate = self;
        _inputTextField.layer.borderColor = ZFCOLOR(178, 178, 178, 1.0).CGColor;
        _inputTextField.layer.borderWidth = MIN_PIXEL;
        _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputTextField.textAlignment = NSTextAlignmentCenter;
        _inputTextField.returnKeyType = UIReturnKeyDone;
    }
    return _inputTextField;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:14];
        _amountLabel.textColor = ZFCOLOR(183, 96, 42, 1);
    }
    return _amountLabel;
}
@end
