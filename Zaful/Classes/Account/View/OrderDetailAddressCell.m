//
//  OrderDetailAddressCell.m
//  Zaful
//
//  Created by DBP on 17/3/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailAddressCell.h"
#import "OrderDetailOrderModel.h"

@interface OrderDetailAddressCell ()
@property (nonatomic, strong) YYAnimatedImageView *addressIcon;
@property (nonatomic, strong) UILabel *addressUserName;
@property (nonatomic, strong) UILabel *addressUserTel;
@property (nonatomic, strong) UILabel *addressUserDetail;
@property (nonatomic, strong) UIButton *addressShowBtn;
@end

@implementation OrderDetailAddressCell
+ (OrderDetailAddressCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[OrderDetailAddressCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.addressUserName.text = nil;
    self.addressUserTel.text = nil;
    self.addressUserDetail.text = nil;
}

-(void)setOrderModel:(OrderDetailOrderModel *)orderModel{
    _orderModel = orderModel;
    if (orderModel == nil) return ;
    self.addressShowBtn.hidden  = YES;
    self.addressUserName.text = [NSString stringWithFormat:@"%@",orderModel.consignee];
    
    self.addressUserTel.text = [NSString stringWithFormat:@"%@",orderModel.tel];
    
    if([NSStringUtils isEmptyString:orderModel.code]) {
        self.addressUserTel.text = [NSString stringWithFormat:@"%@",orderModel.tel];
    } else {
        self.addressUserTel.text = [NSString stringWithFormat:@"+%@ %@",[NSStringUtils isEmptyString:orderModel.code withReplaceString:@""],orderModel.tel];
    }
    
    self.addressUserDetail.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",orderModel.address,orderModel.city,orderModel.province,orderModel.country_str,orderModel.zipcode];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.addressIcon = [YYAnimatedImageView new];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
