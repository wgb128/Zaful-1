//
//  CartOrderInfoDRewardsCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoDRewardsCell.h"

@interface CartOrderInfoDRewardsCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *rewardIcon;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UILabel *saveRewardLabel;
@end

@implementation CartOrderInfoDRewardsCell
{
    NSInteger rewardTextFieldText;
}

+ (CartOrderInfoDRewardsCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoDRewardsCell class] forCellReuseIdentifier:ORDERINFO_DREWARDS_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_DREWARDS_IDENTIFIER forIndexPath:indexPath];
}

-(void)setPointModel:(PointModel *)pointModel{
    
    _pointModel = pointModel;
    NSString *savePrice;
//    if ((int)rewardTextFieldText > [pointModel.use_point_max integerValue]) {
        savePrice = [ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",[pointModel.use_point_max integerValue] * 0.02]];
        self.rewardTextField.text = [NSString stringWithFormat:@"%ld",(long)[pointModel.use_point_max integerValue]];
//    }else {
//        savePrice = [ExchangeManager transforPrice:[NSString stringWithFormat:@"%.2f",rewardTextFieldText * 0.02]];
//        self.rewardTextField.text = [NSString stringWithFormat:@"%ld",(long)(long)rewardTextFieldText];
//        
//    }
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.saveRewardLabel.text = [NSString stringWithFormat:@"%@ -",savePrice];
    } else {
        self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",savePrice];
    }
    
    self.instructionLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),pointModel.avail_point,pointModel.use_point_max,savePrice];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text integerValue] > [self.pointModel.use_point_max integerValue]) {
        [HUDManager showHUDWithMessage:ZFLocalizedString(@"CartOrderInfo_RewardsCell_MaxPoint",nil)];
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = MIN_PIXEL * 2;
        rewardTextFieldText = [textField.text integerValue];
        
        NSString *notChangeSavePrice = [NSString stringWithFormat:@"%.2f",[_pointModel.use_point_max integerValue] * 0.02];

        if ([SystemConfigUtils isRightToLeftShow]) {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"%@ -",[ExchangeManager transforPrice:notChangeSavePrice]];
        } else {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",[ExchangeManager transforPrice:notChangeSavePrice]];
        }
        
        self.instructionLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),_pointModel.avail_point,_pointModel.use_point_max,self.saveRewardLabel.text];
        if (self.refreshRewardBlock) {
            self.refreshRewardBlock(notChangeSavePrice,[NSString stringWithFormat:@"%ld",(long)rewardTextFieldText]);
        }
    }else if([textField.text integerValue] < 0){
        [HUDManager showHUDWithMessage:ZFLocalizedString(@"CartOrderInfo_RewardsCell_ThanZero",nil)];
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = MIN_PIXEL * 2;
        rewardTextFieldText = [textField.text integerValue];
        NSString *notChangeSavePrice = [NSString stringWithFormat:@"%.2f",[_pointModel.use_point_max integerValue] * 0.02];

        if ([SystemConfigUtils isRightToLeftShow]) {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"%@ -",[ExchangeManager transforPrice:notChangeSavePrice]];
        } else {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",[ExchangeManager transforPrice:notChangeSavePrice]];
        }
        
        self.instructionLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),_pointModel.avail_point,_pointModel.use_point_max,self.saveRewardLabel.text];
        if (self.refreshRewardBlock) {
            self.refreshRewardBlock(notChangeSavePrice,[NSString stringWithFormat:@"%ld",(long)rewardTextFieldText]);
        }
    }else{
        
        rewardTextFieldText = [textField.text integerValue];
        NSString *notChangeSavePrice = [NSString stringWithFormat:@"%.2f",rewardTextFieldText * 0.02];

        if ([SystemConfigUtils isRightToLeftShow]) {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"%@ -",[ExchangeManager transforPrice:notChangeSavePrice]];
        } else {
            self.saveRewardLabel.text = [NSString stringWithFormat:@"- %@",[ExchangeManager transforPrice:notChangeSavePrice]];
        }
        
        self.instructionLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartOrderInfo_RewardsCell_Instruction",nil),_pointModel.avail_point,_pointModel.use_point_max,self.saveRewardLabel.text];
        if (self.refreshRewardBlock) {
            self.refreshRewardBlock(notChangeSavePrice,[NSString stringWithFormat:@"%ld",(long)rewardTextFieldText]);
        }
    }
    [self.contentView endEditing:YES];
    

}





/*
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = nil;
    textField.layer.borderWidth = 0.0;
    textField.text = @"";
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rewardIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reward"]];
        [self.contentView addSubview:self.rewardIcon];
        [self.rewardIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.top.offset(25);
            make.size.equalTo(@25);
        }];
        
        self.rewardLabel = [[UILabel alloc] init];
        self.rewardLabel.text = ZFLocalizedString(@"CartOrderInfo_RewardsCell_RewardLabel",nil);
        self.rewardLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.rewardLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:self.rewardLabel];
        [self.rewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.rewardIcon.mas_trailing).offset(10);
            make.centerY.equalTo(self.rewardIcon);
        }];
        
        self.saveRewardLabel = [[UILabel alloc] init];
        self.saveRewardLabel.textColor = ZFCOLOR(244, 67, 69, 1.0);
        self.saveRewardLabel.font = [UIFont systemFontOfSize:14.0];
        self.saveRewardLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.saveRewardLabel];
        [_saveRewardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rewardIcon);
            make.trailing.offset(-12);
        }];
        
        self.rewardTextField = [[CustomTextField alloc] init];
        self.rewardTextField.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.rewardTextField.font = [UIFont boldSystemFontOfSize:14.0];
        self.rewardTextField.delegate = self;
        self.rewardTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.rewardTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.rewardTextField.textAlignment = NSTextAlignmentCenter;
        self.rewardTextField.returnKeyType = UIReturnKeyDone;
        self.rewardTextField.text = @"0";
        [self.contentView addSubview:self.rewardTextField];
        [self.rewardTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.rewardIcon);
            make.trailing.equalTo(self.saveRewardLabel.mas_leading).offset(-20);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
        }];
        
        self.instructionLabel = [[UILabel alloc] init];
        self.instructionLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.instructionLabel.numberOfLines = 0;
        self.instructionLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.instructionLabel];
        [self.instructionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.rewardIcon.mas_bottom).offset(10);
            make.leading.offset(12);
            make.trailing.offset(-12);
            make.bottom.offset(-25);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


@end
