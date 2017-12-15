//
//  CartOrderInfoPayMethodCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoPayMethodCell.h"

@interface CartOrderInfoPayMethodCell ()



@property (nonatomic, strong) UIImageView *paymentIcon;

@property (nonatomic, strong) UILabel *payPalLabel;

@property (nonatomic, strong) UIImageView *wordPayIcon;

@property (nonatomic, strong) UIButton *wordPaySelectBtn;

@property (nonatomic, strong) UILabel *wordPayLabel;

@end

typedef NS_ENUM(NSInteger , SelectPayType){
    SelectPayTypePayPal = 10,
    SelectPayTypeWorld
};

@implementation CartOrderInfoPayMethodCell

+ (CartOrderInfoPayMethodCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoPayMethodCell class] forCellReuseIdentifier:ORDERINFO_PAYMENTMETHOD_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_PAYMENTMETHOD_IDENTIFIER forIndexPath:indexPath];
}

-(void)refreshDataWithCheckOutModel:(CartCheckOutModel *)cartCheckOutModel{
    
    //PayPalModel *payPalmodel = cartCheckOutModel.payment_list.payPal;
    
   // WorldPayModel *worldPaymodel = cartCheckOutModel.payment_list.worldPay;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.paymentIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paypal"]];
        [self.contentView addSubview:self.paymentIcon];
        [self.paymentIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(25);
            make.leading.offset(40);
            make.width.equalTo(@90);
            make.height.equalTo(@25);
        }];
        
        self.paymentSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.paymentSelectBtn setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [self.paymentSelectBtn setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        self.paymentSelectBtn.tag = SelectPayTypePayPal;
        self.paymentSelectBtn.selected = YES;
        [self.paymentSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.paymentSelectBtn];
        [self.paymentSelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.paymentIcon.mas_centerY).offset(0);
            make.leading.offset(12);
            make.size.equalTo(@19);
        }];
        
        self.payPalLabel = [[UILabel alloc] init];
        self.payPalLabel.text = ZFLocalizedString(@"CartOrderInfo_PayMethodCell_PayPalLabel",nil);
        self.payPalLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.payPalLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.payPalLabel];
        [self.payPalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.paymentSelectBtn);
            make.leading.equalTo(self.paymentIcon.mas_trailing).offset(5);
        }];
        
        self.wordPayIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"american"]];
        [self.contentView addSubview:self.wordPayIcon];
        [self.wordPayIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.paymentIcon.mas_bottom).offset(25);
            make.leading.equalTo(self.paymentIcon.mas_bottom);
            make.height.equalTo(@25);
            make.width.equalTo(@55);
        }];
        
        self.wordPaySelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.wordPaySelectBtn setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [self.wordPaySelectBtn setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        self.wordPaySelectBtn.tag = SelectPayTypeWorld;
        [self.wordPaySelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.wordPaySelectBtn];
        [self.wordPaySelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.paymentSelectBtn);
            make.centerY.equalTo(self.wordPayIcon.mas_centerY).offset(0);
            make.size.equalTo(@19);
        }];
        
        self.wordPayLabel = [[UILabel alloc] init];
        self.wordPayLabel.text = ZFLocalizedString(@"CartOrderInfo_PayMethodCell_WordPayLabel",nil);
        self.wordPayLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        self.wordPayLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.wordPayLabel];
        [self.wordPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.wordPayIcon);
            make.top.equalTo(self.wordPayIcon.mas_bottom).offset(10);
            make.bottom.offset(-25);
        }];
        
    }
    return self;
}

- (void)selectBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case  SelectPayTypePayPal:
        {
            self.wordPaySelectBtn.selected = !sender.selected;
            break;
        }
        case  SelectPayTypeWorld:
        {
            self.paymentSelectBtn.selected = !sender.selected;
            break;
        }
        default:
            break;
    }
}

@end
