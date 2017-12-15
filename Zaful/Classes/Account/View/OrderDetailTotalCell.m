//
//  OrderDetailTotalCell.m
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailTotalCell.h"
#import "FDStackView.h"
#import "OrderDetailTotalView.h"
#import "OrderDetailLineView.h"
#import "OrderDetailPaymentView.h"
#import "DeliveryShippingView.h"
#import "FilterManager.h"

@interface OrderDetailTotalCell ()
@property (nonatomic, strong) FDStackView *stackView;
@property (nonatomic, strong) OrderDetailLineView *spacingView;
@property (nonatomic, strong) OrderDetailTotalView *subtotalView;
@property (nonatomic, strong) OrderDetailTotalView *rewardsView;
@property (nonatomic, strong) OrderDetailTotalView *couponView;
@property (nonatomic, strong) OrderDetailTotalView *shippingView;
@property (nonatomic, strong) OrderDetailTotalView *deliveryView;
@property (nonatomic, strong) OrderDetailTotalView *insuranceView;
@property (nonatomic, strong) OrderDetailTotalView *freightView;
@property (nonatomic, strong) OrderDetailLineView *middleLineView;
@property (nonatomic, strong) OrderDetailTotalView *grandView;
@property (nonatomic, strong) OrderDetailTotalView *discountView;
@property (nonatomic, strong) OrderDetailLineView *payLineView;
@property (nonatomic, strong) OrderDetailTotalView *payableView;
@property (nonatomic, strong) OrderDetailLineView *bottomSpacingView;

@property (nonatomic, strong) DeliveryShippingView *deliveryShippingView;
@end
@implementation OrderDetailTotalCell

+ (OrderDetailTotalCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[OrderDetailTotalCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.stackView = [[FDStackView alloc] init];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.alignment = UIStackViewAlignmentFill;
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        
        self.spacingView = [[OrderDetailLineView alloc] initWithColor:ZFCOLOR(255, 255, 255, 1.0) height:10];
        [self.stackView addArrangedSubview:self.spacingView];
        
        self.subtotalView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Subtotal",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.subtotalView];
        
        self.rewardsView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_RewardsSaving",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.rewardsView];
        
        self.couponView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_PromotionCodeSaving",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.couponView];
        
        self.shippingView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_ShippingCost",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.shippingView];
        
        self.insuranceView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_ShippingInsurance",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.insuranceView];
        
        self.deliveryView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetailViewController_COD_cost", nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.deliveryView];
        
        self.middleLineView = [[OrderDetailLineView alloc] initWithColor:ZFCOLOR(221, 221, 221, 1.0) height:MIN_PIXEL];
        [self.stackView addArrangedSubview:self.middleLineView];
        
        self.grandView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_GrandTotal",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.grandView];
        
        self.discountView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Discount",nil) andDefaultColor:YES];
        [self.stackView addArrangedSubview:self.discountView];
        
        self.payLineView = [[OrderDetailLineView alloc] initWithColor:ZFCOLOR(221, 221, 221, 1.0) height:MIN_PIXEL];
        [self.stackView addArrangedSubview:self.payLineView];
        
        self.payableView = [[OrderDetailTotalView alloc] initWithTitle:ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_TotalPayable",nil) andDefaultColor:NO];
        [self.stackView addArrangedSubview:self.payableView];
        
        self.deliveryShippingView = [[DeliveryShippingView alloc] init];
        [self.stackView addArrangedSubview:self.deliveryShippingView];
        
        self.bottomSpacingView = [[OrderDetailLineView alloc] initWithColor:ZFCOLOR(255, 255, 255, 1.0) height:10];
        [self.stackView addArrangedSubview:self.bottomSpacingView];
    }
    return self;
}

- (void)setOrderModel:(OrderDetailOrderModel *)orderModel {
    _orderModel = orderModel;
    if (!orderModel) return;
    CGFloat num = [orderModel.subtotal floatValue]    +
    [orderModel.shipping_fee floatValue]  +
    [orderModel.insure_fee floatValue]     +
    [orderModel.formalities_fee floatValue]      -
    [orderModel.coupon floatValue]   -
    [orderModel.z_point floatValue];
    
    self.subtotalView.rightValue = [self showCurrency:orderModel.subtotal];
    self.rewardsView.rightValue = [NSString stringWithFormat:@"-%@",[self showCurrency:orderModel.point_money]];
    self.couponView.rightValue = [NSString stringWithFormat:@"-%@",[self showCurrency:orderModel.coupon]];
    self.shippingView.rightValue = [self showCurrency:orderModel.shipping_fee];
    self.insuranceView.rightValue = [self showCurrency:orderModel.insure_fee];
    NSString *numString = [NSString stringWithFormat:@"%.2f",num];
    self.grandView.rightValue = [self showCurrency:numString];
    self.deliveryView.rightValue = [self showCurrency:orderModel.formalities_fee];
    
    //积分优惠券为0的时候移除那两行，不显示
    if ([orderModel.coupon floatValue] == 0) {
        [self.stackView removeArrangedSubview:self.couponView];
    }
    if ([orderModel.point_money floatValue] == 0) {
        [self.stackView removeArrangedSubview:self.rewardsView];
    }
    
    //判断cod取整，移除cod手机提示等
    if (![orderModel.pay_id isEqualToString:@"Cod"]) {
        self.grandView.DefaultColor = NO;
        [self.stackView removeArrangedSubview:self.deliveryShippingView];
        [self.stackView removeArrangedSubview:self.deliveryView];
        
        [self.stackView removeArrangedSubview:self.discountView];
        [self.stackView removeArrangedSubview:self.payLineView];
        [self.stackView removeArrangedSubview:self.payableView];
    }else {
        [self.stackView removeArrangedSubview:self.bottomSpacingView]; //底下pay now
        
        if ([orderModel.order_status floatValue] == 13) {
            [self.stackView removeArrangedSubview:self.deliveryShippingView];
        }
        //这里需要后台返回的订单详情中的字段进行判断
        switch ([orderModel.cod_orientation integerValue]) {
            case CashOnDeliveryTruncTypeDefault:
            {
                self.grandView.DefaultColor = NO;
                [self.stackView removeArrangedSubview:self.discountView];
                [self.stackView removeArrangedSubview:self.payLineView];
                [self.stackView removeArrangedSubview:self.payableView];
            }
                break;
            case CashOnDeliveryTruncTypeUp:
            {
                self.grandView.DefaultColor = YES;
                self.discountView.leftLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_AirCargoInsurance",nil);
                self.discountView.rightValue = [NSString stringWithFormat:@"+%@",[self showCurrency:orderModel.cod_discount]];
                self.payableView.rightValue = [self showCurrency:orderModel.total_payable];
                
            }
                break;
            case CashOnDeliveryTruncTypeDown:
            {
                self.grandView.DefaultColor = YES;
                self.discountView.leftLabel.text = ZFLocalizedString(@"OrderDetail_TotalPrice_Cell_Discount",nil);
                self.discountView.rightValue = [NSString stringWithFormat:@"-%@", [self showCurrency:orderModel.cod_discount]];
                self.payableView.rightValue =  [self showCurrency:orderModel.total_payable];

            }
                break;
            default:
                break;
        }

    }
}


- (NSString *)showCurrency:(NSString *)price {
    NSString *priceString;
    if ([_orderModel.order_currency isEqualToString:@"€"]) {
        NSMutableString *string = [NSMutableString stringWithFormat:@"%@", price];
        NSRange range = [string rangeOfString:@"."];
        [string replaceCharactersInRange:range withString:@","];
        NSString *changePrice = string;
        priceString = [NSString stringWithFormat:@"%@ %@",changePrice,_orderModel.order_currency];
    }else{
        priceString = [NSString stringWithFormat:@"%@%@",_orderModel.order_currency,price];
    }
    return priceString;
}


@end
