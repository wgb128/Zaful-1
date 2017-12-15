
//
//  ZFColorSelectCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/12/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFColorSelectCollectionViewCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFColorSelectCollectionViewCell() <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UIView                *colorView;

@end

@implementation ZFColorSelectCollectionViewCell
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum])
        return nil;
    return ColorHex(hexNum);
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.colorView];
    [self.contentView addSubview:self.iconImageView];
}

- (void)zfAutoLayoutView {
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    self.colorView.layer.cornerRadius = 19;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
}

#pragma mark - setter
- (void)setModel:(ZFSizeSelectItemsModel *)model {
    _model = model;
    
    if ([_model.color hasPrefix:@"#"]) {
        NSString *colorStr = [_model.color componentsSeparatedByString:@"#"][1];
        self.colorView.backgroundColor = [self colorWithHexString:colorStr];
    }
    
    if (_model.is_click) {
        if (_model.isSelect) {
            self.iconImageView.image = [UIImage imageNamed:@"select_color_on"];
        } else {
            self.iconImageView.image = [UIImage imageNamed:@"select_color_normal"];
        }
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"select_color_unc"];
    }
}

#pragma mark - getter
- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:CGRectZero];
        _colorView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _colorView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}

@end
