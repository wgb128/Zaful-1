//
//  MyOrderDetailDeliveryCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/12.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "MyOrderDetailDeliveryCell.h"

@interface MyOrderDetailDeliveryCell ()

@property (nonatomic, strong) UILabel *payStatusLabel;

@property (nonatomic, strong) UILabel *dateLabel;

@property (nonatomic, strong) UILabel *dateContentLabel;

@property (nonatomic, strong) UILabel *deliveryLabel;

@property (nonatomic, strong) UILabel *deliveryContentLabel;

@property (nonatomic, strong) UILabel *paymentLabel;

@property (nonatomic, strong) UILabel *paymentContentLabel;


@end

@implementation MyOrderDetailDeliveryCell

+ (MyOrderDetailDeliveryCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[MyOrderDetailDeliveryCell class] forCellReuseIdentifier:MY_ORDERS_DETAIL_DELIVERY_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:MY_ORDERS_DETAIL_DELIVERY_INENTIFIER forIndexPath:indexPath];
}


- (void)prepareForReuse {
    self.payStatusLabel.text = nil;
    self.dateContentLabel.text = nil;
    self.deliveryContentLabel.text = nil;
    self.paymentContentLabel.text = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.payStatusLabel];
        [self.payStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        }];
        
        [self.contentView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.payStatusLabel.mas_bottom).offset(10);
            make.leading.mas_equalTo(self.payStatusLabel.mas_leading);
        }];
        
        [self.contentView addSubview:self.dateContentLabel];
        [self.dateContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.dateLabel.mas_centerY);
            make.leading.mas_equalTo(self.dateLabel.mas_trailing).offset(2);
        }];
        
        [self.contentView addSubview:self.deliveryLabel];
        [self.deliveryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self.payStatusLabel.mas_leading);
        }];
        
        [self.contentView addSubview:self.deliveryContentLabel];
        [self.deliveryContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.deliveryLabel.mas_centerY);
            make.leading.mas_equalTo(self.deliveryLabel.mas_trailing).offset(2);
        }];
        
        [self.contentView addSubview:self.paymentLabel];
        [self.paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.deliveryLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self.payStatusLabel.mas_leading);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
        }];
        
        [self.contentView addSubview:self.paymentContentLabel];
        [self.paymentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.paymentLabel.mas_centerY);
            make.leading.mas_equalTo(self.paymentLabel.mas_trailing).offset(2);
        }];
    }
    return self;
}

-(void)setOrderModel:(MyOrderDetailOrderModel *)orderModel{
    
    _orderModel = orderModel;
#if 0
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setLocale:[NSLocale systemLocale]]; //设置为en_US的显示模式,  PM...AM .
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    //[dateFormatter setDateFormat:@"YYYY-MM-dd  HH:mm:ss"]; //MM-dd-YYYY HH:mm:ss aa
    [dateFormatter setDateFormat:@"MM/dd/YYYY HH:mm:ss aa"];
    NSDate *comefromTimeSp = [NSDate dateWithTimeIntervalSince1970:orderModel.add_time.integerValue];
    //12/08/2016 03:23:55 AM
    
    self.dateContentLabel.text = [dateFormatter stringFromDate:comefromTimeSp];
#endif
    
    self.payStatusLabel.text = orderModel.order_status_str;
    
    self.dateContentLabel.text = orderModel.add_time;
    
    self.deliveryContentLabel.text = orderModel.shipping_name;
    
    self.paymentContentLabel.text = orderModel.pay_name;
}

-(UILabel *)payStatusLabel{
    if (!_payStatusLabel) {
        _payStatusLabel = [[UILabel alloc] init];
        _payStatusLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _payStatusLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    return _payStatusLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.text = [NSString stringWithFormat:@"%@:",ZFLocalizedString(@"OrderDetail_Delivery_Cell_Date",nil)];
        _dateLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _dateLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _dateLabel;
}

-(UILabel *)dateContentLabel{
    if (!_dateContentLabel) {
        _dateContentLabel = [[UILabel alloc] init];
        _dateContentLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _dateContentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _dateContentLabel;
}

-(UILabel *)deliveryLabel{
    if (!_deliveryLabel) {
        _deliveryLabel = [[UILabel alloc] init];
        _deliveryLabel.text = [NSString stringWithFormat:@"%@:",ZFLocalizedString(@"OrderDetail_Delivery_Cell_Delivery",nil)];
        _deliveryLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _deliveryLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _deliveryLabel;
}

-(UILabel *)deliveryContentLabel{
    if (!_deliveryContentLabel) {
        _deliveryContentLabel = [[UILabel alloc] init];
        _deliveryContentLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _deliveryContentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _deliveryContentLabel;
}

-(UILabel *)paymentLabel{
    if (!_paymentLabel) {
        _paymentLabel = [[UILabel alloc] init];
        _paymentLabel.text = [NSString stringWithFormat:@"%@:",ZFLocalizedString(@"OrderDetail_Delivery_Cell_Payment",nil)];
        _paymentLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _paymentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _paymentLabel;
}

-(UILabel *)paymentContentLabel{
    if (!_paymentContentLabel) {
        _paymentContentLabel = [[UILabel alloc] init];
        _paymentContentLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _paymentContentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _paymentContentLabel;
}

@end
