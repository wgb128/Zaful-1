//
//  OrderDetailOrderCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/20.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "OrderDetailOrderCell.h"
#import "OrderDetailOrderModel.h"

@interface OrderDetailOrderCell ()

@property (nonatomic, strong) UILabel *orderSNLabel;

//@property (nonatomic, strong) UILabel *trackNumLabel;

@end

@implementation OrderDetailOrderCell

+ (OrderDetailOrderCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[OrderDetailOrderCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.orderSNLabel.text = nil;
}
/**
 $_LANG['os'][0] = 'Waiting for payment';
 $_LANG['os'][1] = 'Paid';
 $_LANG['os'][2] = 'Processing';
 $_LANG['os'][3] = 'Shipped out';
 $_LANG['os'][4] = 'Delivered';
 $_LANG['os'][6] = 'pending';
 $_LANG['os'][7] = 'Payment Authorized';
 $_LANG['os'][8] = 'Partial Paid';
 $_LANG['os'][10] = 'Refunded';
 $_LANG['os'][11] = 'Cancelled';
 $_LANG['os'][15] = 'Partial order dispatched';
 $_LANG['os'][16] = 'Dispatched';
 $_LANG['os'][20] = 'Partial order shipped';
 $_LANG['os'][30] = 'Delivered';
 */
-(void)setOrderModel:(OrderDetailOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    if (orderModel == nil) return; //会出现null显示在屏幕.

    if ([SystemConfigUtils isRightToLeftShow]) {
        self.orderSNLabel.text = [NSString stringWithFormat:@"%@ :%@",orderModel.order_sn,ZFLocalizedString(@"OrderDetail_Order_Cell_Order",nil)];
    } else {
        self.orderSNLabel.text = [NSString stringWithFormat:@"%@: %@",ZFLocalizedString(@"OrderDetail_Order_Cell_Order",nil),orderModel.order_sn];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.orderSNLabel = [[UILabel alloc] init];
        self.orderSNLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        self.orderSNLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.orderSNLabel];
        [self.orderSNLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.height.equalTo(@45);
            make.bottom.offset(0);
        }];
    }
    return self;
}

@end
