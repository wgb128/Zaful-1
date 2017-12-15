//
//  CartInfoNoShippingCell.m
//  Zaful
//
//  Created by zhaowei on 2017/3/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartInfoNoShippingCell.h"

@interface CartInfoNoShippingCell ()
@property (nonatomic, strong) YYAnimatedImageView *warnIcon;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation CartInfoNoShippingCell

+ (CartInfoNoShippingCell *)noShippingCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartInfoNoShippingCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.warnIcon = [YYAnimatedImageView new];
        self.warnIcon.image = [UIImage imageNamed:@"warn"];
        
        [self.contentView addSubview:self.warnIcon];
        [self.warnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(18);
        }];
        
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:14.0];
        self.tipLabel.numberOfLines = 0;
//        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        self.tipLabel.text = ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoShipping",nil);
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.warnIcon.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.contentView.mas_top).offset(20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
        }];
    }
    return self;
}

@end
