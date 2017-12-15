//
//  CartInfoRewardsCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoRewardsCell.h"
#import "NoPasteTextFiled.h"
#import "FilterManager.h"

@interface CartInfoRewardsCell () <UITextFieldDelegate>

@property (nonatomic, strong) YYAnimatedImageView *rewardIcon;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) NoPasteTextFiled *rewardTextField;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UILabel *saveRewardLabel;
@end

@implementation CartInfoRewardsCell

+ (CartInfoRewardsCell *)rewardsCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoRewardsCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.rewardTextField.text = nil;
    self.instructionLabel.text = nil;
    self.saveRewardLabel.text = nil;
}

- (void)setModel:(PointModel *)model {
    _model = model;
    NSString *savePrice;
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        savePrice = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",[model.currentPoint integerValue] * 0.02] currency:[FilterManager tempCurrency]]];
    } else {
        savePrice = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",[model.currentPoint integerValue] * 0.02]]];
    }
    self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",savePrice];
    self.rewardTextField.text = [NSString stringWithFormat:@"%ld",(long)[model.currentPoint integerValue]];
    
    NSString *instructionPrice;
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        instructionPrice = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",[model.use_point_max integerValue] * 0.02] currency:[FilterManager tempCurrency]]];
    } else {
        instructionPrice = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",[model.use_point_max integerValue] * 0.02]]];
    }
    
    self.instructionLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),model.avail_point,model.use_point_max,instructionPrice];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *inputReward = @"";
    if ([textField.text integerValue] > [self.model.use_point_max integerValue]) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"CartOrderInfo_RewardsCell_MaxPoint",nil)];
        [textField showCurrentViewBorder:MIN_PIXEL * 2 color:[UIColor redColor]];
        inputReward = self.model.use_point_max;
    }else{
        inputReward = textField.text;
    }
    
    NSString *notChangeSavePrice = [NSString stringWithFormat:@"%.2f",[inputReward integerValue] * 0.02];
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.saveRewardLabel.text = [NSString stringWithFormat:@"%@ -",[ExchangeManager transforPrice:notChangeSavePrice]];
    } else {
        self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",[ExchangeManager transforPrice:notChangeSavePrice]];
    }
    
    if (self.inputRewardBlock) {
        self.inputRewardBlock(notChangeSavePrice,inputReward);
    }

    [self.contentView endEditing:YES];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.rewardIcon = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"reward"]];
        [self.contentView addSubview:self.rewardIcon];
        [self.rewardIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.top.mas_equalTo(self.contentView.mas_top).offset(19.5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        self.rewardLabel = [[UILabel alloc] init];
        self.rewardLabel.text = ZFLocalizedString(@"CartOrderInfo_RewardsCell_RewardLabel",nil);
        self.rewardLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.rewardLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.rewardLabel];
        [self.rewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.rewardIcon.mas_trailing).offset(12);
            make.centerY.mas_equalTo(self.rewardIcon.mas_centerY);
        }];
        
        self.saveRewardLabel = [[UILabel alloc] init];
        self.saveRewardLabel.textColor = ZFCOLOR(245, 86, 88, 1.0);
        self.saveRewardLabel.font = [UIFont boldSystemFontOfSize:14];
        self.saveRewardLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.saveRewardLabel];
        [_saveRewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.rewardIcon);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        }];
        
        self.rewardTextField = [[NoPasteTextFiled alloc] init];
        self.rewardTextField.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.rewardTextField.font = [UIFont boldSystemFontOfSize:14];
        self.rewardTextField.delegate = self;
//        self.rewardTextField.borderStyle = UITextBorderStyleLine;
        self.rewardTextField.layer.borderColor = ZFCOLOR(178, 178, 178, 1.0).CGColor;
        self.rewardTextField.layer.borderWidth = MIN_PIXEL;
        self.rewardTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.rewardTextField.textAlignment = NSTextAlignmentCenter;
        self.rewardTextField.returnKeyType = UIReturnKeyDone;
        
        [self.contentView addSubview:self.rewardTextField];
        [self.rewardTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.rewardIcon.mas_centerY);
            make.trailing.mas_equalTo(self.saveRewardLabel.mas_leading).offset(-20);
            make.width.mas_equalTo(@60);
            make.height.mas_equalTo(@28);
        }];
        
        self.instructionLabel = [[UILabel alloc] init];
        self.instructionLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.instructionLabel.numberOfLines = 0;
        self.instructionLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.instructionLabel];
        [self.instructionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.rewardIcon.mas_bottom).offset(19.5);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
        }];
    }
    return self;
}





@end
