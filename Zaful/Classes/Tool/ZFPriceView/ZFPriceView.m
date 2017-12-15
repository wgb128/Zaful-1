//
//  ZFPriceView.m
//  Zaful
//
//  Created by TsangFa on 14/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPriceView.h"
#import "ZFBaseGoodsModel.h"
#import "ZFInitViewProtocol.h"
#import "ZFLabel.h"

@interface ZFPriceView ()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel   *shopLabel;
@property (nonatomic, strong) UILabel   *marketLabel;
@property (nonatomic, strong) ZFLabel   *promoteLabel;
@property (nonatomic, strong) ZFLabel   *appLabel;
@property (nonatomic, strong) ZFLabel   *codLabel;
@end

@implementation ZFPriceView

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
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    [self addSubview:self.shopLabel];
    [self addSubview:self.marketLabel];
    [self addSubview:self.promoteLabel];
    [self addSubview:self.appLabel];
    [self addSubview:self.codLabel];
}

- (void)zfAutoLayoutView {
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(self);
    }];
    
    [self.marketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopLabel.mas_bottom).offset(5);
        make.leading.equalTo(self);
    }];
    
    [self.promoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self);
    }];
    
    [self.appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promoteLabel.mas_bottom).offset(4);
        make.trailing.equalTo(self);
        make.leading.equalTo(self.promoteLabel.mas_leading);
        make.height.equalTo(self.promoteLabel.mas_height);
    }];
    
    [self.codLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.promoteLabel.mas_bottom).offset(4);
        make.trailing.equalTo(self);
        make.leading.equalTo(self.promoteLabel.mas_leading);
        make.height.equalTo(self.promoteLabel.mas_height);
    }];
}

#pragma mark - Public method
- (void)clearAllData {
    self.shopLabel.text = nil;
    self.marketLabel.text = nil;
    self.promoteLabel.text = nil;
    self.promoteLabel.hidden = NO;
    self.appLabel.hidden = NO;
    self.codLabel.hidden = YES;
}

#pragma mark - Setter
- (void)setModel:(ZFBaseGoodsModel *)model {
    _model = model;
    
    self.shopLabel.text = [ExchangeManager transforPrice:model.shopPrice];
    NSString *marketPrice = [ExchangeManager transforPrice:model.marketPrice];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:marketPrice attributes:attribtDic];
    self.marketLabel.attributedText = attribtStr;
    self.promoteLabel.hidden = [model.promote_zhekou isEqualToString:@"0"]  ? YES : NO;
    if ([model.promote_zhekou isEqualToString:@"0"]) {
        self.promoteLabel.hidden = YES;
    }else{
        self.promoteLabel.hidden = NO;
        self.promoteLabel.text   = [NSString stringWithFormat:@"-%@%%",model.promote_zhekou];
    }
    [self.promoteLabel sizeToFit];
    self.appLabel.hidden = [model.is_mobile_price boolValue] ? NO : YES;
    self.codLabel.hidden = model.is_cod ? NO : YES;
    if (model.is_cod) {
        self.appLabel.hidden = YES;
    }
}

#pragma mark - Getter
- (UILabel *)shopLabel {
    if (!_shopLabel) {
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        _shopLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _shopLabel;
}

- (UILabel *)marketLabel {
    if (!_marketLabel) {
        _marketLabel = [[UILabel alloc] init];
        _marketLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _marketLabel.font = [UIFont systemFontOfSize:13];
    }
    return _marketLabel;
}

- (ZFLabel *)promoteLabel {
    if (!_promoteLabel) {
        _promoteLabel = [[ZFLabel alloc] init];
        _promoteLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _promoteLabel.font = [UIFont boldSystemFontOfSize:11];
        _promoteLabel.textAlignment = NSTextAlignmentCenter;
        _promoteLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1);
        _promoteLabel.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    }
    return _promoteLabel;
}

- (ZFLabel *)appLabel {
    if (!_appLabel) {
        _appLabel = [[ZFLabel alloc] init];
        _appLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _appLabel.font = [UIFont boldSystemFontOfSize:11];
        _appLabel.textAlignment = NSTextAlignmentCenter;
        _appLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1);
        _appLabel.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _appLabel.text = @"APP";
        [_appLabel sizeToFit];
    }
    return _appLabel;
}

- (ZFLabel *)codLabel {
    if (!_codLabel) {
        _codLabel = [[ZFLabel alloc] init];
        _codLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _codLabel.font = [UIFont boldSystemFontOfSize:11];
        _codLabel.textAlignment = NSTextAlignmentCenter;
        _codLabel.backgroundColor = ZFCOLOR(183, 96, 42, 1);
        _codLabel.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _codLabel.text = @"COD";
        [_codLabel sizeToFit];
        _codLabel.hidden = YES;
    }
    return _codLabel;
}

@end
