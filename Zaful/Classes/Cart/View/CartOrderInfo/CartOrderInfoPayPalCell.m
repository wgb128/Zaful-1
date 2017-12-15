//
//  CartOrderInfoPayPalCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/16.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoPayPalCell.h"

@interface CartOrderInfoPayPalCell ()

@property (nonatomic, strong) UIImageView *paymentIcon;


@end

@implementation CartOrderInfoPayPalCell

+ (CartOrderInfoPayPalCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoPayPalCell class] forCellReuseIdentifier:ORDERINFO_PAYPALCELL_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_PAYPALCELL_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.paymentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paypal"]];
        [self.contentView addSubview:self.paymentIcon];
        [self.paymentIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(12.5);
            make.leading.offset(40);
            make.width.equalTo(@90);
            make.height.equalTo(@25);
        }];
        
        self.paymentSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.paymentSelectBtn setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [self.paymentSelectBtn setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        self.paymentSelectBtn.selected = YES;
        [self.paymentSelectBtn addTarget:self action:@selector(payPalBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.paymentSelectBtn];
        [self.paymentSelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.paymentIcon.mas_centerY).offset(0);
            make.leading.offset(12);
            make.size.equalTo(@19);
        }];
        
        self.payPalLabel = [[UILabel alloc] init];
        self.payPalLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.payPalLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.payPalLabel];
        [self.payPalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentIcon.mas_bottom).offset(10);
            make.leading.equalTo(self.paymentIcon);
            make.bottom.offset(-12.5);
        }];
    }
    return self;
}

- (void)payPalBtnClick:(UIButton *)sender
{
    if (self.payPalSelectBlock && sender.selected == NO) {
        sender.selected = !sender.selected;
        self.payPalSelectBlock();
    }
}

@end
