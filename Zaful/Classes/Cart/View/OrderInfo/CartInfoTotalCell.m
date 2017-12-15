//
//  CartInfoTotalCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoTotalCell.h"
#import "CartInfoTotalSubView.h"
#import "CartInfoTotalLineView.h"
#import "CartInfoPlaceOrderView.h"
#import "FDStackView.h"
#import "FilterManager.h"

@interface CartInfoTotalCell ()

@property (nonatomic, strong) FDStackView *stackView;
@property (nonatomic, strong) CartInfoTotalSubView *subtotalView;
@property (nonatomic, strong) CartInfoTotalSubView *rewardsView;
@property (nonatomic, strong) CartInfoTotalSubView *couponView;
@property (nonatomic, strong) CartInfoTotalSubView *shippingView;
@property (nonatomic, strong) CartInfoTotalSubView *insuranceView;
@property (nonatomic, strong) CartInfoTotalSubView *freightView;
@property (nonatomic, strong) CartInfoTotalLineView *middleLineView;
@property (nonatomic, strong) CartInfoTotalSubView *grandView;
//-------------------------只有COD才会显示------------------------------
@property (nonatomic, strong) CartInfoTotalLineView *payLineView;
@property (nonatomic, strong) CartInfoTotalSubView *discountView;
@property (nonatomic, strong) CartInfoTotalSubView *payableView;
//--------------------------------------------------------------------
@property (nonatomic, strong) CartInfoTotalLineView *bottomLineView;

@end

@implementation CartInfoTotalCell

+ (CartInfoTotalCell *)totalCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoTotalCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

-(void)setManager:(OrderInfoManager *)manager {
    _manager = manager;
    
    CGFloat num = [manager.goods_price floatValue]    +
                  [manager.shippingPrice floatValue]  +
                  [manager.codFreight floatValue]     +
                  [manager.insurance floatValue]      -
                  [manager.couponAmount floatValue]   -
                  [manager.pointSavePrice floatValue] -
                  [manager.activities_amount floatValue];
    
    CGFloat total = [manager.goods_price floatValue] - [manager.activities_amount floatValue];
    NSString *totalStr = [NSString stringWithFormat:@"%f",total];
    
    if ([manager.pointSavePrice floatValue] == 0) {
        [self.stackView removeArrangedSubview:self.rewardsView];
    }else{
        [self.stackView insertArrangedSubview:self.rewardsView atIndex:1];
    }
    
    if ([manager.couponAmount floatValue] == 0) {
        [self.stackView removeArrangedSubview:self.couponView];
    }else if ([manager.pointSavePrice floatValue] != 0 && [manager.couponAmount floatValue] != 0) {
        [self.stackView insertArrangedSubview:self.couponView atIndex:2];
    }else if ([manager.pointSavePrice floatValue] != 0 && [manager.couponAmount floatValue] == 0) {
        [self.stackView insertArrangedSubview:self.couponView atIndex:1];
    }else if ([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] != 0){
         [self.stackView insertArrangedSubview:self.couponView atIndex:1];
    }

    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        self.subtotalView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:totalStr currency:[FilterManager tempCurrency]]];
        self.shippingView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.shippingPrice currency:[FilterManager tempCurrency]]];
        self.insuranceView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.insurance currency:[FilterManager tempCurrency]]];
        self.freightView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.codFreight currency:[FilterManager tempCurrency]]];
        
        if([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] == 0) {
            [self.stackView insertArrangedSubview:self.freightView atIndex:3];
        }else if ([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] != 0) {
            [self.stackView insertArrangedSubview:self.freightView atIndex:4];
        }else if ([manager.pointSavePrice floatValue] != 0 && [manager.couponAmount floatValue] == 0) {
            [self.stackView insertArrangedSubview:self.freightView atIndex:4];
        }else{
            [self.stackView insertArrangedSubview:self.freightView atIndex:5];
        }

        self.grandView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
        //COD取整方式
        switch ([FilterManager cashOnDeliveryTruncType:manager.countryID]) {
            case CashOnDeliveryTruncTypeUp:
            {
                self.discountView.leftTitleLabel.text =  ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_AirCargoInsurance",nil);

                self.discountView.rightValue = [NSString stringWithFormat:@"+%@",[ExchangeManager transforCeilDifferencePrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
                self.payableView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforCeilPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
                
                self.grandView.defaultColor = YES;
                
                
                if([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] == 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:6];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:8];
                }else if ([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] != 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:9];
                }else if ([manager.pointSavePrice floatValue] != 0 && [manager.couponAmount floatValue] == 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:9];
                }else{
                    [self.stackView insertArrangedSubview:self.discountView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:9];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:10];
                }
                
            }
                break;
            case CashOnDeliveryTruncTypeDefault:
            {
                [self.stackView removeArrangedSubview:self.payLineView];
                [self.stackView removeArrangedSubview:self.discountView];
                [self.stackView removeArrangedSubview:self.payableView];
                self.grandView.defaultColor = NO;
                
            }
                break;
            case CashOnDeliveryTruncTypeDown:
            {
                self.discountView.leftTitleLabel.text =ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Discount",nil);

                self.discountView.rightValue = [NSString stringWithFormat:@"-%@",[ExchangeManager transforFloorDifferencePrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
                self.payableView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforFloorPrice:[NSString stringWithFormat:@"%lf",num] currency:[FilterManager tempCurrency]]];
                
                self.grandView.defaultColor = YES;
                
                if([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] == 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:6];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:8];
                }else if ([manager.pointSavePrice floatValue] == 0 && [manager.couponAmount floatValue] != 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:9];
                }else if ([manager.pointSavePrice floatValue] != 0 && [manager.couponAmount floatValue] == 0) {
                    [self.stackView insertArrangedSubview:self.discountView atIndex:7];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:9];
                }else{
                    [self.stackView insertArrangedSubview:self.discountView atIndex:8];
                    [self.stackView insertArrangedSubview:self.payLineView atIndex:9];
                    [self.stackView insertArrangedSubview:self.payableView atIndex:10];
                }
            }
                break;
            default:
                break;
        }
        
    }else{
        self.subtotalView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:totalStr]];
        self.shippingView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.shippingPrice]];
        self.insuranceView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.insurance]];
        self.grandView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:[NSString stringWithFormat:@"%lf",num]]];
        self.freightView.rightValue = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:manager.codFreight]];
        [self.stackView removeArrangedSubview:self.freightView];
        [self.stackView removeArrangedSubview:self.payLineView];
        [self.stackView removeArrangedSubview:self.discountView];
        [self.stackView removeArrangedSubview:self.payableView];
    }
    //由于阿语的原因，所以不需要把负号位置改变
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        self.rewardsView.rightValue = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.pointSavePrice currency:[FilterManager tempCurrency]]];
        self.couponView.rightValue = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.couponAmount currency:[FilterManager tempCurrency]]];
    }else{
        self.rewardsView.rightValue = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.pointSavePrice]];
        self.couponView.rightValue = [NSString stringWithFormat:@"-%@",[ExchangeManager transforPrice:manager.couponAmount]];//优惠券
    }
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.stackView = [[FDStackView alloc] init];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.distribution = UIStackViewDistributionFill;
        self.stackView.alignment = UIStackViewAlignmentFill;
        
        [self.contentView addSubview:self.stackView];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        
        self.subtotalView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"MyOrders_Cell_Total",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.subtotalView];
        
        self.rewardsView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.rewardsView];
        
        self.couponView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.couponView];
        
        self.shippingView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingCost",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.shippingView];
        
        self.insuranceView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_ShippingInsurance",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.insuranceView];
        
        self.freightView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"OrderInfoViewModel_COD_cost", nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.freightView];
        [self.stackView removeArrangedSubview:self.freightView];
        
        self.middleLineView = [[CartInfoTotalLineView alloc] initWithColor:ZFCOLOR(221, 221, 221, 1.0) height:MIN_PIXEL];
        [self.stackView addArrangedSubview:self.middleLineView];
        
        self.grandView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_GrandTotal",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.grandView];
        
        self.discountView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_Discount",nil) defaultColor:YES];
        [self.stackView addArrangedSubview:self.discountView];
        [self.stackView removeArrangedSubview:self.discountView];
        
        self.payLineView = [[CartInfoTotalLineView alloc] initWithColor:ZFCOLOR(221, 221, 221, 1.0) height:MIN_PIXEL];
        [self.stackView addArrangedSubview:self.payLineView];
        [self.stackView removeArrangedSubview:self.payLineView];

        self.payableView = [[CartInfoTotalSubView alloc] initWithRightTitle:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil) defaultColor:NO];
        [self.stackView addArrangedSubview:self.payableView];
        [self.stackView removeArrangedSubview:self.payableView];

        self.bottomLineView = [[CartInfoTotalLineView alloc] initWithColor:[UIColor whiteColor] height:MIN_PIXEL];
        [self.stackView addArrangedSubview:self.bottomLineView];
        

    }
    return self;
}

@end
