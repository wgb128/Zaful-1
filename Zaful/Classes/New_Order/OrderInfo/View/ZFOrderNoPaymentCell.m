//
//  ZFOrderNoPaymentCell.m
//  Zaful
//
//  Created by TsangFa on 19/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderNoPaymentCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFOrderNoPaymentCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) YYAnimatedImageView   *warnIcon;
@property (nonatomic, strong) UILabel               *tipLabel;
@end

@implementation ZFOrderNoPaymentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.warnIcon];
    [self.contentView addSubview:self.tipLabel];
}

- (void)zfAutoLayoutView {
    [self.warnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 18));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.warnIcon.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
}

#pragma mark - Getter
- (YYAnimatedImageView *)warnIcon {
    if (!_warnIcon) {
        _warnIcon = [YYAnimatedImageView new];
        _warnIcon.image = [UIImage imageNamed:@"warn"];
    }
    return _warnIcon;
}

-(UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _tipLabel.text = ZFLocalizedString(@"CartOrderInfoViewModel_PlaceOrder_NoPayment",nil);
    }
    return _tipLabel;
}

@end
