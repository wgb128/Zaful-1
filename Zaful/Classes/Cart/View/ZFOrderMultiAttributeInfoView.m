//
//  ZFOrderMultiAttributeInfoView.m
//  Zaful
//
//  Created by liuxi on 2017/10/24.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderMultiAttributeInfoView.h"
#import "ZFInitViewProtocol.h"

@interface ZFOrderMultiAttributeInfoView() <ZFInitViewProtocol>

@end

@implementation ZFOrderMultiAttributeInfoView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
}

- (void)zfAutoLayoutView {}

#pragma mark - setter
- (void)setAttrsArray:(NSArray *)attrsArray {
    _attrsArray = attrsArray;
    CGFloat height = 16;
    __block CGFloat position_y = 0;
    
    [_attrsArray enumerateObjectsUsingBlock:^(ZFMultAttributeModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            
            UILabel *attrNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            attrNameLabel.text = [NSString stringWithFormat:@"%@:", obj.attr_name];
            attrNameLabel.font = [UIFont boldSystemFontOfSize:12];
            attrNameLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
            [self addSubview:attrNameLabel];
            [attrNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self);
                make.top.mas_equalTo(self.mas_top).offset(position_y);
                make.height.mas_equalTo(16);
            }];
            
            UILabel *attrValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            attrValueLabel.text = obj.attr_value;
            attrValueLabel.font = [UIFont boldSystemFontOfSize:12];
            attrValueLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
            [self addSubview:attrValueLabel];
            [attrValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(attrNameLabel.mas_trailing);
                make.trailing.mas_equalTo(self);
                make.top.mas_equalTo(self.mas_top).offset(position_y);
                make.height.mas_equalTo(16);
            }];
            position_y += height;
        }
    }];
}

@end
