//
//  CartInfoInsuranceCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoInsuranceCell.h"
#import "FilterManager.h"

@interface CartInfoInsuranceCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation CartInfoInsuranceCell

+ (CartInfoInsuranceCell *)insuranceCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoInsuranceCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.priceLabel.text = nil;
    self.checkBtn.selected = NO;
}

- (void)setInsuranceValue:(NSArray *)insuranceValue {
    _insuranceValue = insuranceValue;
    self.checkBtn.selected = [insuranceValue[1] boolValue];
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:insuranceValue[0] currency:[FilterManager tempCurrency]]];
    } else {
        self.priceLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:insuranceValue[0]]];
    }
}

- (void)checkTouch:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.checkTouchBlock) {
        self.checkTouchBlock(sender.selected);
    }
}

- (void)checkTapTouch:(UITapGestureRecognizer *)tap {
    self.checkBtn.selected = !self.checkBtn.selected;
    if (self.checkTouchBlock) {
        self.checkTouchBlock(self.checkBtn.selected);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkBtn setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [self.checkBtn setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [self.checkBtn addTarget:self action:@selector(checkTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(self.mas_top).offset(22);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-22);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = ZFLocalizedString(@"CartOrderInfo_ShippingInsuranceCell_Cell_ShippingInsurance",nil);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        UITapGestureRecognizer * titleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkTapTouch:)];
        [self.priceLabel addGestureRecognizer:titleTap];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.checkBtn.mas_trailing).offset(5);
            make.centerY.equalTo(self.checkBtn.mas_centerY);
        }];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = [UIFont boldSystemFontOfSize:14];
        self.priceLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_trailing).offset(5);
            make.centerY.equalTo(self.checkBtn.mas_centerY);
        }];
        
        UITapGestureRecognizer * priceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkTapTouch:)];
        [self.priceLabel addGestureRecognizer:priceTap];
    }
    return self;
}



@end
