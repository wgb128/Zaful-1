//
//  ZFOrderPlaceOrderCell.m
//  Zaful
//
//  Created by TsangFa on 22/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderPlaceOrderCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFOrderPlaceOrderCell()<ZFInitViewProtocol>
@property (nonatomic, strong) UIButton              *placeOrderButton;
@end

@implementation ZFOrderPlaceOrderCell
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
    [self.contentView addSubview:self.placeOrderButton];
}

- (void)zfAutoLayoutView {
    [self.placeOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(46);
    }];
}

#pragma mark - Getter
- (UIButton *)placeOrderButton {
    if (!_placeOrderButton) {
        _placeOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_placeOrderButton setTitle:ZFLocalizedString(@"CartOrderInformationBottomView_PlaceOrderBtn",nil) forState:UIControlStateNormal];
        [_placeOrderButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _placeOrderButton.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        _placeOrderButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _placeOrderButton.userInteractionEnabled = NO;
    }
    return _placeOrderButton;
}
@end
