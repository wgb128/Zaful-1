//
//  DeliveryShippingView.m
//  Zaful
//
//  Created by DBP on 17/3/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "DeliveryShippingView.h"
#import "ZFInitViewProtocol.h"

@interface DeliveryShippingView () <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel *deliveryLabel;
@end

@implementation DeliveryShippingView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectZero]) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    [self addSubview:self.deliveryLabel];
}

- (void)zfAutoLayoutView {
    [self.deliveryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(15, 12, 24, 12));
    }];
}

#pragma mark - getter
- (UILabel *)deliveryLabel {
    if (!_deliveryLabel) {
        _deliveryLabel = [[UILabel alloc] init];
        _deliveryLabel.backgroundColor = [UIColor clearColor];
        _deliveryLabel.text = ZFLocalizedString(@"DeliveryShippingView_deliveryLabel", nil);
        _deliveryLabel.textColor = ZFCOLOR(52, 52, 52, 1.0);
        _deliveryLabel.preferredMaxLayoutWidth = KScreenWidth - 24;
        _deliveryLabel.numberOfLines = 0;
        [_deliveryLabel sizeToFit];
        _deliveryLabel.font = [UIFont systemFontOfSize:14];
    }
    return _deliveryLabel;
}

@end
