//
//  CartOrderInfoPromotionCodeCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoPromotionCodeCell.h"

@interface CartOrderInfoPromotionCodeCell ()

@property (nonatomic, strong) UIImageView *codeIcon;

@property (nonatomic, strong) UILabel *promotionCodeLabel;

@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation CartOrderInfoPromotionCodeCell

+ (CartOrderInfoPromotionCodeCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoPromotionCodeCell class] forCellReuseIdentifier:ORDERINFO_PROMOTIONCODE_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_PROMOTIONCODE_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.codeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coupon"]];
        [self.contentView addSubview:self.codeIcon];
        [self.codeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.top.offset(20);
            make.size.equalTo(@24);
            make.bottom.offset(-20);
        }];
        
        self.promotionCodeLabel = [[UILabel alloc] init];
        self.promotionCodeLabel.text = ZFLocalizedString(@"CartOrderInfo_PromotionCodeCell_PromotionCodeLabel",nil);
        self.promotionCodeLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.promotionCodeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.promotionCodeLabel];
        [self.promotionCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.codeIcon.mas_trailing).offset(10);
            make.centerY.equalTo(self.codeIcon);
        }];
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            self.rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"to_left"]];
        } else {
            self.rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"to_right"]];
        }

        [self.contentView addSubview:self.rightIcon];

        [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-12);
            make.width.equalTo(@6);
            make.height.equalTo(@12);
            make.centerY.equalTo(self.codeIcon);
        }];
        
        self.saveLabel = [[UILabel alloc] init];
        self.saveLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.saveLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:self.saveLabel];
        [self.saveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.rightIcon.mas_leading).offset(-10);
            make.centerY.equalTo(self.codeIcon);
        }];
        
    }
    return self;
}

- (void)applyBtnClick
{
    
}

@end
