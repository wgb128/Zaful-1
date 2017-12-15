//
//  CartInfoCouponCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoCouponCell.h"
#import "FilterManager.h"

@interface CartInfoCouponCell ()

@property (nonatomic, strong) YYAnimatedImageView *codeIcon;

@property (nonatomic, strong) UILabel *promotionCodeLabel;

@property (nonatomic, strong) UILabel *saveLabel;

@end

@implementation CartInfoCouponCell

+ (CartInfoCouponCell *)couponCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoCouponCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.saveLabel.text = nil;
}

-(void)setCouponString:(NSString *)couponString {
    _couponString = couponString;
    
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        self.saveLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:couponString currency:[FilterManager tempCurrency]]];
    } else {
        self.saveLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:couponString]];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        self.codeIcon = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"coupon"]];
        [self.contentView addSubview:self.codeIcon];
        [self.codeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.top.mas_equalTo(self.contentView.mas_top).offset(22);
            make.size.mas_equalTo(CGSizeMake(24, 24));
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-22);
        }];
        
        self.promotionCodeLabel = [[UILabel alloc] init];
        self.promotionCodeLabel.text = ZFLocalizedString(@"CartOrderInfo_PromotionCodeCell_PromotionCodeLabel",nil);
        self.promotionCodeLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.promotionCodeLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:self.promotionCodeLabel];
        [self.promotionCodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.codeIcon.mas_trailing).offset(11);
            make.centerY.mas_equalTo(self.codeIcon.mas_centerY);
        }];
        
        self.saveLabel = [[UILabel alloc] init];
        self.saveLabel.textColor = ZFCOLOR(245, 86, 88, 1.0);
        self.saveLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.saveLabel];
        [self.saveLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-18);
            make.centerY.mas_equalTo(self.codeIcon.mas_centerY);
        }];
        
    }
    return self;
}


@end
