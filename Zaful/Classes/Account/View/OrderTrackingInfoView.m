//
//  OrderTrackingInfoView.m
//  Zaful
//
//  Created by TsangFa on 5/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderTrackingInfoView.h"

@interface OrderTrackingInfoView ()
@property (nonatomic, strong) UIButton   *trackingButton;
@end

@implementation OrderTrackingInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.trackingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.trackingButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [self.trackingButton setTitle:ZFLocalizedString(@"ZFTracking_information_title", nil) forState:UIControlStateNormal];
        self.trackingButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.trackingButton.titleLabel.contentMode = NSTextAlignmentCenter;
        [self.trackingButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [self.trackingButton addTarget:self action:@selector(orderTrackingInfoClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.trackingButton setContentEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        
        [self addSubview:self.trackingButton];
        [self.trackingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(12);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
            
        }];
    }
    return self;
}

- (void)orderTrackingInfoClick:(UIButton *)sender {
    if (self.orderTrackingInfoBlock) {
        self.orderTrackingInfoBlock();
    }

}




@end
