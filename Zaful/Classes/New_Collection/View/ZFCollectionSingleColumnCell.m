//
//  ZFColleciontSingleColumnCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionSingleColumnCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCollectionModel.h"
#import "ZFLabel.h"
#import "ZFMultiAttributeInfoView.h"

@interface ZFCollectionSingleColumnCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView               *productImageView;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UILabel                   *sizeLabel;
@property (nonatomic, strong) UILabel                   *colorLabel;
@property (nonatomic, strong) ZFMultiAttributeInfoView  *attrView;
@property (nonatomic, strong) UILabel                   *shopPriceLabel;
@property (nonatomic, strong) UILabel                   *marketPriceLabel;
@property (nonatomic, strong) UIView                    *marketPriceLineView;
@property (nonatomic, strong) UIButton                  *collectButton;
@property (nonatomic, strong) ZFLabel                   *promoteLabel;
@property (nonatomic, strong) ZFLabel                   *appLabel;
@property (nonatomic, strong) ZFLabel                   *codLabel;
@property (nonatomic, strong) UIView                    *lineView;

@end

@implementation ZFCollectionSingleColumnCell
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)collectionButtonAction:(UIButton *)sender {
    if (self.collectionDelectCompletionHandler) {
        self.collectionDelectCompletionHandler(self.model);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.productImageView];
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.attrView];
    [self.contentView addSubview:self.colorLabel];
    [self.contentView addSubview:self.shopPriceLabel];
    [self.contentView addSubview:self.marketPriceLabel];
    [self.contentView addSubview:self.marketPriceLineView];
    [self.contentView addSubview:self.collectButton];
    [self.contentView addSubview:self.promoteLabel];
    [self.contentView addSubview:self.appLabel];
    [self.contentView addSubview:self.codLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.height.mas_equalTo(120 * SCREEN_WIDTH_SCALE);
        make.width.mas_equalTo(@90);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_top);
        make.leading.mas_equalTo(self.productImageView.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.collectButton.mas_leading).offset(-12);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(17);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.size.mas_equalTo(@40);
    }];
    
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.shopPriceLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.shopPriceLabel.mas_centerY);
    }];
    
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopPriceLabel.mas_bottom).offset(4);
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
    }];
    
//    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(4);
//        make.leading.mas_equalTo(self.titleLabel.mas_leading);
//    }];
    
    [self.attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(4);
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
        make.height.mas_equalTo(0);
    }];
    
    [self.promoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_leading);
        make.bottom.equalTo(self.productImageView.mas_bottom);
    }];
    
    [self.appLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.promoteLabel.mas_trailing).offset(4);
        make.centerY.equalTo(self.promoteLabel.mas_centerY);
    }];
    
    [self.codLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.promoteLabel.mas_trailing).offset(4);
        make.centerY.equalTo(self.promoteLabel.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_bottom).offset(16);
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(12);
    }];

}

#pragma mark - setter
- (void)setModel:(ZFCollectionModel *)model {
    _model = model;
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image]
                         processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"loading_cat_list"]
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                                   ZFLog(@"load from disk cache");
                               }
                           }];
    
    self.titleLabel.text = _model.goods_title;
//    if ([SystemConfigUtils isRightToLeftShow]) {
//        
//        self.colorLabel.text = [NSString stringWithFormat:@"%@ :%@",_model.attr_color,ZFLocalizedString(@"Bag_Color",nil)];
//        self.sizeLabel.text = [NSString stringWithFormat:@"%@ :%@",_model.attr_size,ZFLocalizedString(@"Bag_Size",nil)];
//    } else {
//        self.colorLabel.text = [NSString stringWithFormat:@"%@: %@",ZFLocalizedString(@"Bag_Color",nil),_model.attr_color];
//        self.sizeLabel.text = [NSString stringWithFormat:@"%@: %@",ZFLocalizedString(@"Bag_Size",nil),_model.attr_size];
//    }
    self.colorLabel.text = [NSString stringWithFormat:@"%@/%@", _model.attr_color, _model.attr_size];
//    if ([NSStringUtils isEmptyString:_model.attr_size]) {
//        self.sizeLabel.hidden = YES;
//    }
//    if ([NSStringUtils isEmptyString:_model.attr_color]) {
//        self.colorLabel.hidden = YES;
//    }
    
    if ([NSStringUtils isEmptyString:_model.attr_color] && [NSStringUtils isEmptyString:_model.attr_size]) {
        self.colorLabel.hidden = YES;
    }
    self.attrView.hidden = _model.multi_attr.count <= 0;
    if (_model.multi_attr.count > 0) {
        self.attrView.attrsArray = _model.multi_attr;
        [self.attrView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.colorLabel.mas_bottom).offset(4);
            make.leading.mas_equalTo(self.titleLabel.mas_leading);
            make.height.mas_equalTo(_model.multi_attr.count * 16);
        }];
        
        [self.promoteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLabel.mas_leading);
            make.top.mas_equalTo(self.attrView.mas_bottom).offset(4);
        }];
    }
    
    NSString *marketPrice = [ExchangeManager transforPrice:_model.market_price];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:marketPrice attributes:attribtDic];
    self.marketPriceLabel.attributedText = attribtStr;
    self.shopPriceLabel.text = [ExchangeManager transforPrice:_model.shop_price];
    if ([_model.promote_zhekou isEqualToString:@"0"]) {
        self.promoteLabel.hidden = YES;
        if (model.is_cod) {
            [self.codLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.titleLabel.mas_leading);
                make.bottom.equalTo(self.productImageView.mas_bottom);
            }];
        } else {
            if (_model.is_mobile_price) {
                [self.appLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.titleLabel.mas_leading);
                    make.bottom.equalTo(self.productImageView.mas_bottom);
                }];
            }
        }
    }else{
        self.promoteLabel.hidden = NO;
        self.promoteLabel.text = [NSString stringWithFormat:@"-%@%%",_model.promote_zhekou];
    }
    self.appLabel.hidden = _model.is_mobile_price ? NO : YES;
    self.codLabel.hidden = model.is_cod ? NO : YES;
    if (model.is_cod) {
        self.appLabel.hidden = YES;
    }
}

#pragma mark - getter
- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _productImageView = [[YYAnimatedImageView alloc] init];
        _productImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _productImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _sizeLabel.font = [UIFont boldSystemFontOfSize:12.0];
    }
    return _sizeLabel;
}

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _colorLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _colorLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _colorLabel;
}

- (ZFMultiAttributeInfoView *)attrView {
    if (!_attrView) {
        _attrView = [[ZFMultiAttributeInfoView alloc] initWithFrame:CGRectZero];
    }
    return _attrView;
}

- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _shopPriceLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _shopPriceLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _shopPriceLabel;
}

- (UILabel *)marketPriceLabel {
    if (!_marketPriceLabel) {
        _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _marketPriceLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _marketPriceLabel;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setImage:[UIImage imageNamed:@"collection_liked"] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
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
        _codLabel.hidden = YES;
        [_codLabel sizeToFit];
    }
    return _codLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =ZFCOLOR(245, 245, 245, 1.0);
    }
    return _lineView;
}


@end
