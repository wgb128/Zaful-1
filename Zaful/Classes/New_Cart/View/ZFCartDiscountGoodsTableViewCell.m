

//
//  ZFCartDiscountGoodsTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartDiscountGoodsTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCartCountOptionView.h"
#import "ZFCartGoodsModel.h"
#import "BigClickAreaButton.h"
#import "ZFLabel.h"
#import "ZFMultiAttributeInfoView.h"


@interface ZFCartDiscountGoodsTableViewCell () <ZFInitViewProtocol>

@property (nonatomic, strong) BigClickAreaButton        *selectButton;
@property (nonatomic, strong) UIImageView               *goodsImageView;
@property (nonatomic, strong) ZFLabel                   *codLabel;
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UIImageView               *phoneIconView;
@property (nonatomic, strong) UILabel                   *priceLabel;
@property (nonatomic, strong) UILabel                   *shopPriceLabel;
@property (nonatomic, strong) UIView                    *priceDeleteLine;
@property (nonatomic, strong) UILabel                   *sizeLabel;
@property (nonatomic, strong) UILabel                   *colorLabel;
@property (nonatomic, strong) ZFMultiAttributeInfoView  *attrView;
@property (nonatomic, strong) ZFCartCountOptionView     *countOptionView;
@property (nonatomic, strong) BigClickAreaButton        *collectButton;
@property (nonatomic, strong) UIView                    *lineView;

@end

@implementation ZFCartDiscountGoodsTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (CAKeyframeAnimation *)createCollectionOptionAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

#pragma mark - action methods
- (void)selectButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.cartDiscountGoodsSelectCompletionHandler) {
        [self.selectButton.layer addAnimation:[self createCollectionOptionAnimation] forKey:@"kSelectOptionAnimationIdentifier"];
        self.cartDiscountGoodsSelectCompletionHandler(sender.selected);
    }
}

- (void)collectButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.cartDiscountGoodsCollectionCompletionHandler) {
        [self.collectButton.layer addAnimation:[self createCollectionOptionAnimation] forKey:@"kCollectionOptionAnimationIdentifier"];
        self.cartDiscountGoodsCollectionCompletionHandler(sender.selected);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.codLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.phoneIconView];
    [self.contentView addSubview:self.shopPriceLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceDeleteLine];
    [self.contentView addSubview:self.colorLabel];
    [self.contentView addSubview:self.attrView];
    [self.contentView addSubview:self.countOptionView];
    [self.contentView addSubview:self.collectButton];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(64);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.selectButton.mas_trailing).offset(12);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(90, 120));
    }];
    
    [self.codLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.width.mas_equalTo(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.leading.mas_equalTo(self.codLabel.mas_trailing).mas_offset(5.0f);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(16);
    }];
    
    [self.phoneIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(10, 15));
    }];
    
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.phoneIconView.mas_trailing).offset(4);
        make.height.mas_equalTo(21);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.shopPriceLabel.mas_trailing).offset(8);
        make.centerY.mas_equalTo(self.shopPriceLabel.mas_centerY);
        make.height.mas_equalTo(21);
    }];
    
    [self.priceDeleteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.priceLabel);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(self.priceLabel.mas_centerY);
    }];
    
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shopPriceLabel.mas_bottom);
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(18);
    }];
    
    [self.attrView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorLabel.mas_bottom);
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(0);
    }];
    
//    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.colorLabel.mas_bottom);
//        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
//        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
//        make.height.mas_equalTo(18);
//    }];
    
    [self.countOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        make.size.mas_equalTo(CGSizeMake(112, 30));
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-0.5);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCartGoodsModel *)model {
    _model = model;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image]
                               processorKey:NSStringFromClass([self class])
                                placeholder:[UIImage imageNamed:@"loading_cat_list"]
                                    options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                   }
                                  transform:^UIImage *(UIImage *image, NSURL *url) {
                                      image = [image yy_imageByResizeToSize:CGSizeMake(150 * DSCREEN_WIDTH_SCALE, 200 * DSCREEN_WIDTH_SCALE) contentMode:UIViewContentModeScaleAspectFit];
                                      return image;
                                  }
                                 completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                     if (from == YYWebImageFromDiskCache) {
                                         ZFLog(@"load from disk cache");
                                     }
                                 }];
    
    self.titleLabel.text = _model.goods_title;
    self.phoneIconView.hidden = !_model.is_mobile_price;
    if (!_model.is_mobile_price) {
        [self.shopPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    } else {
        [self.shopPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.phoneIconView.mas_trailing).offset(4);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    self.shopPriceLabel.text = [ExchangeManager transforPrice:_model.shop_price];
    self.priceLabel.text = [ExchangeManager transforPrice:_model.market_price];
    NSMutableString *colorString = [NSMutableString new];
    if (_model.attr_color.length > 0
        && _model.attr_size.length > 0) {
        [colorString appendFormat:@"%@/%@", _model.attr_color, _model.attr_size];
    } else if (_model.attr_color.length > 0) {
        [colorString appendString:_model.attr_color];
    } else if (_model.attr_size.length > 0) {
        [colorString appendString:_model.attr_size];
    }
    self.colorLabel.text = colorString;
    self.attrView.hidden = _model.multi_attr.count <= 0;
    
    if (_model.multi_attr.count > 0) {
        self.attrView.attrsArray = _model.multi_attr;
        [self.attrView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.colorLabel.mas_bottom);
            make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
            make.height.mas_equalTo(_model.multi_attr.count * 16);
        }];
        
        [self.countOptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.attrView.mas_bottom).offset(4);
            make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
            make.size.mas_equalTo(CGSizeMake(112, 30));
        }];
    }
    self.collectButton.selected = _model.if_collect;
    self.countOptionView.maxGoodsNumber = _model.goods_number;
    self.countOptionView.goodsNumber = _model.buy_number;
    self.selectButton.selected = _model.is_selected;
    self.codLabel.hidden = !_model.is_cod;
    // 同个列表有多种样式，得更新
    if (!_model.is_cod) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(12);
            make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
            make.height.mas_equalTo(16);
        }];
    } else {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.codLabel.mas_trailing).mas_offset(5.0f);
        }];
    }
}

#pragma mark - getter
- (BigClickAreaButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _selectButton.clickAreaRadious = 45;
        [_selectButton setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _goodsImageView;
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _titleLabel;
}

- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _shopPriceLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _shopPriceLabel;
}

- (UIImageView *)phoneIconView {
    if (!_phoneIconView) {
        _phoneIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_phone"]];
    }
    return _phoneIconView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _priceLabel;
}

- (UIView *)priceDeleteLine {
    if (!_priceDeleteLine) {
        _priceDeleteLine = [[UIView alloc] initWithFrame:CGRectZero];
        _priceDeleteLine.backgroundColor = ZFCOLOR(152, 152, 152, 1.f);
    }
    return _priceDeleteLine;
}

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _colorLabel.font = [UIFont boldSystemFontOfSize:12];
        _colorLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _colorLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.font = [UIFont boldSystemFontOfSize:12];
        _sizeLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _sizeLabel;
}

- (ZFMultiAttributeInfoView *)attrView {
    if (!_attrView) {
        _attrView = [[ZFMultiAttributeInfoView alloc] initWithFrame:CGRectZero];
        _attrView.hidden = YES;
    }
    return _attrView;
}

- (ZFCartCountOptionView *)countOptionView {
    if (!_countOptionView) {
        _countOptionView = [[ZFCartCountOptionView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _countOptionView.cartGoodsCountChangeCompletionHandler = ^(NSInteger number) {
            @strongify(self);
            self.model.buy_number = number;
            if (self.cartDiscountGoodsChangeCountCompletionHandler) {
                self.cartDiscountGoodsChangeCountCompletionHandler(self.model);
            }
        };
    }
    return _countOptionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (BigClickAreaButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _collectButton.clickAreaRadious = 45;
        [_collectButton setImage:[UIImage imageNamed:@"cart_collection"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"cart_collection_on"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _collectButton;
}

@end
