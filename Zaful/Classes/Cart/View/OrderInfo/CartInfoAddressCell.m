//
//  CartInfoAddressCell.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/2/24.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoAddressCell.h"
#import "ZFAddressInfoModel.h"

@interface CartInfoAddressCell ()

@property (nonatomic, strong) YYAnimatedImageView *addressIcon;

@property (nonatomic, strong) UILabel *addressUserName;

@property (nonatomic, strong) UILabel *addressUserTel;

@property (nonatomic, strong) UILabel *addressUserDetail;

@end

@implementation CartInfoAddressCell

+ (CartInfoAddressCell *)addressCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoAddressCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.addressUserName.text = nil;
    self.addressUserTel.text = nil;
    self.addressUserDetail.text = nil;
}

- (void)setAddressModel:(ZFAddressInfoModel *)addressModel {
    _addressModel = addressModel;
    self.addressUserName.text = [NSString stringWithFormat:@"%@ %@",addressModel.firstname,addressModel.lastname];;
    self.addressUserTel.text = [NSString stringWithFormat:@"%@",addressModel.tel];
    
    if([NSStringUtils isEmptyString:addressModel.code]) {
        self.addressUserTel.text = [NSString stringWithFormat:@"%@",addressModel.tel];
    } else {
        self.addressUserTel.text = [NSString stringWithFormat:@"+%@ %@%@",[NSStringUtils isEmptyString:addressModel.code withReplaceString:@""],[NSStringUtils isEmptyString:addressModel.supplier_number withReplaceString:@""],addressModel.tel];
    }
    
    self.addressUserDetail.text = [NSString stringWithFormat:@"%@ %@,\n%@ %@/%@ %@",addressModel.addressline1,addressModel.addressline2,addressModel.province,addressModel.country_str,addressModel.city,addressModel.zipcode];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        self.addressIcon = [YYAnimatedImageView new];
        self.addressIcon.image = [UIImage imageNamed:@"address_icon"];
        
        [self.contentView addSubview:self.addressIcon];
        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(25);
        }];
        
        self.addressUserName = [UILabel new];
        self.addressUserName.font = [UIFont boldSystemFontOfSize:14];
        self.addressUserName.numberOfLines = 2;
        self.addressUserName.textColor = ZFCOLOR(51, 51, 51, 1.0);
        
        [self.contentView addSubview:self.addressUserName];
        [self.addressUserName mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.leading.mas_equalTo(self.addressIcon.mas_trailing).offset(10);
        }];

        self.addressUserTel = [UILabel new];
        self.addressUserTel.textAlignment = NSTextAlignmentRight;
        self.addressUserTel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.addressUserTel.font = [UIFont systemFontOfSize:14];
        
        
        [self.contentView addSubview:self.addressUserTel];
        [self.addressUserTel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.addressUserName.mas_top);
            make.leading.mas_equalTo(self.addressUserName.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-24);
        }];
        
        
        self.addressUserDetail = [UILabel new];
        self.addressUserDetail.numberOfLines = 0;
        self.addressUserDetail.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.addressUserDetail.font = [UIFont systemFontOfSize:14];
        
        
        [self.contentView addSubview:self.addressUserDetail];
        [self.addressUserDetail  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.addressUserName.mas_leading);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-20);
            make.top.mas_equalTo(self.addressUserName.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }];
        
        [self.addressUserTel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.addressUserTel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}

@end
