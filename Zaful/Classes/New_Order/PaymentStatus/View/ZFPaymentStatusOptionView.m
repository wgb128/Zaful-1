
//
//  ZFPaymentStatusOptionView.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPaymentStatusOptionView.h"
#import "ZFInitViewProtocol.h"

@interface ZFPaymentStatusOptionView() <ZFInitViewProtocol>

@property (nonatomic, strong) UIButton          *cancelButton;

@end

@implementation ZFPaymentStatusOptionView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    
}

- (void)zfAutoLayoutView {
    
}

#pragma mark - setter
- (void)setStatusType:(ZFPaymentStatusOptionType)statusType {
    _statusType = statusType;
    
}

#pragma mark - getter

@end
