//
//  NoShippingOrPaymentCell.m
//  Zaful
//
//  Created by 7FD75 on 16/9/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "NoShippingOrPaymentCell.h"

@interface NoShippingOrPaymentCell ()

@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation NoShippingOrPaymentCell

+ (NoShippingOrPaymentCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[NoShippingOrPaymentCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:14.0];
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        [self.contentView addSubview:self.tipLabel];
        [self.tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(12);
            make.trailing.offset(-12);
            make.top.offset(20);
            make.bottom.offset(-20);
            make.height.greaterThanOrEqualTo(@0);
        }];
    }
    return self;
}

-(void)setIsNoShippingCell:(BOOL)isNoShippingCell{
    
    if (isNoShippingCell) {
        self.tipLabel.text = ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoShipping",nil);
    }else{
        self.tipLabel.text = ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoPayment",nil);
    }
}

@end
