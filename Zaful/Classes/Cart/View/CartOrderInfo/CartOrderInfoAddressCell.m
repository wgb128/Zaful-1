//
//  CartOrderInfoAddressCell.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/26.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoAddressCell.h"

@interface CartOrderInfoAddressCell ()
@property (nonatomic, strong) UIImageView *addressIcon;
@property (nonatomic, strong) UILabel *addressUserName;
@property (nonatomic, strong) UILabel *addressUserTel;
@property (nonatomic, strong) UILabel *addressUserDetail;
@property (nonatomic, strong) UIButton *addressShowBtn;
@end

@implementation CartOrderInfoAddressCell

#pragma mark - 订单详情添加地址
+ (CartOrderInfoAddressCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoAddressCell class] forCellReuseIdentifier:CART_ADDRESS_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:CART_ADDRESS_INENTIFIER forIndexPath:indexPath];
}

-(void)setAddressModel:(AddressBookModel *)addressModel{
    _addressModel = addressModel;
    self.addressUserName.text = [NSString stringWithFormat:@"%@ %@",addressModel.firstname,addressModel.lastname];
    self.addressUserTel.text = addressModel.tel;
    self.addressUserDetail.text = [NSString stringWithFormat:@"%@ %@,\n%@ %@/%@ %@",addressModel.addressline1,addressModel.addressline2,addressModel.city,addressModel.province,addressModel.country_str,addressModel.zipcode];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.addressIcon = [UIImageView new];
        self.addressIcon.image = [UIImage imageNamed:@"address_icon"];
        
        [self.contentView addSubview:self.addressIcon];
        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.equalTo(@20);
            make.height.equalTo(@25);
        }];
        
        self.addressUserTel = [UILabel new];
        self.addressUserTel.textAlignment = NSTextAlignmentRight;
        self.addressUserTel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.addressUserTel.font = [UIFont systemFontOfSize:14.0];
        
        [self.contentView addSubview:self.addressUserTel];
        [self.addressUserTel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        }];
        
        self.addressUserName = [UILabel new];
        self.addressUserName.font = [UIFont boldSystemFontOfSize:16.0];
        self.addressUserName.numberOfLines = 2;
        self.addressUserName.textColor = ZFCOLOR(51, 51, 51, 1.0);
        
        [self.contentView addSubview:self.addressUserName];
        [self.addressUserName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(55);
            make.top.mas_equalTo(self.addressUserTel.mas_top);
            make.trailing.mas_equalTo(self.addressUserTel.mas_leading).offset(-10);
        }];
        
        self.addressUserDetail  = [UILabel new];
        self.addressUserDetail.numberOfLines = 0;
        self.addressUserDetail.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.addressUserDetail.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:self.addressUserDetail];
        [self.addressUserDetail  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.addressUserName.mas_leading);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-20);
            make.top.mas_equalTo(self.addressUserName.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }];
        
        self.addressShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addressShowBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.addressShowBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            [self.addressShowBtn setImage:[UIImage imageNamed:@"to_left"] forState:UIControlStateNormal];
        } else {
            [self.addressShowBtn setImage:[UIImage imageNamed:@"to_right"] forState:UIControlStateNormal];
        }
        
        [self.contentView addSubview:self.addressShowBtn];
        [self.addressShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
            make.width.mas_equalTo(@8);
            make.height.mas_equalTo(@15);
        }];
        
        [self.addressUserTel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.addressUserTel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}



@end
