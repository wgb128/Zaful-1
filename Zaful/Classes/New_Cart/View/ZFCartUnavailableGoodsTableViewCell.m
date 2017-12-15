//
//  ZFCartUnavailableGoodsTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartUnavailableGoodsTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCartGoodsModel.h"

@interface ZFCartUnavailableGoodsTableViewCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView           *goodsImageView;
@property (nonatomic, strong) UILabel               *unavailableLabel;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIImageView           *phoneIconView;
@property (nonatomic, strong) UILabel               *shopPriceLabel;
@property (nonatomic, strong) UILabel               *priceLabel;
@property (nonatomic, strong) UIView                *priceDeleteLine;
@property (nonatomic, strong) UILabel               *sizeLabel;
@property (nonatomic, strong) UILabel               *colorLabel;
@property (nonatomic, strong) UILabel               *stateLabel;
@property (nonatomic, strong) UIView                *lineView;

@end

@implementation ZFCartUnavailableGoodsTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.unavailableLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.phoneIconView];
    [self.contentView addSubview:self.shopPriceLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceDeleteLine];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.colorLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(40);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(90, 120));
    }];
    
    [self.unavailableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.goodsImageView);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    self.unavailableLabel.layer.cornerRadius = 10;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.leading.mas_equalTo(self.goodsImageView.mas_trailing).offset(12);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(32);
    }];
    
    [self.phoneIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel);
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
        make.leading.mas_equalTo(self.titleLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(18);
    }];
    
    [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.colorLabel.mas_bottom);
        make.leading.mas_equalTo(self.titleLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-28);
        make.height.mas_equalTo(18);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self.goodsImageView);
        make.height.mas_equalTo(24);
        make.trailing.mas_equalTo(self.contentView);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.trailing.mas_equalTo(self.contentView);
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
            make.leading.mas_equalTo(self.titleLabel);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    self.shopPriceLabel.text = [ExchangeManager transforPrice:_model.shop_price];
    self.priceLabel.text = [ExchangeManager transforPrice:_model.market_price];
    self.sizeLabel.text = _model.attr_size;
    self.colorLabel.text = _model.attr_color;
    self.stateLabel.text = _model.goods_state == 1 ? ZFLocalizedString(@"CartUnavailableGoodsTypeSoldOut", nil) : _model.goods_state == 2 ? ZFLocalizedString(@"CartUnavailableGoodsTypeOutOfStore", nil) : @"";
//    NSLocalizedString(@"CartUnavailableGoodsTypeSoldOut", nil);
    
}


#pragma mark - getter
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _goodsImageView;
}

- (UILabel *)unavailableLabel {
    if (!_unavailableLabel) {
        _unavailableLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unavailableLabel.backgroundColor = ZFCOLOR(153, 153, 153, 1.f);
        _unavailableLabel.textColor = ZFCOLOR_WHITE;
        _unavailableLabel.font = [UIFont systemFontOfSize:12];
        _unavailableLabel.textAlignment = NSTextAlignmentCenter;
        _unavailableLabel.text = ZFLocalizedString(@"CartUnavailableGoodsTips", nil);
        _unavailableLabel.clipsToBounds = YES;
    }
    return _unavailableLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _titleLabel;
}

- (UIImageView *)phoneIconView {
    if (!_phoneIconView) {
        _phoneIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"category_phone"]];
    }
    return _phoneIconView;
}


- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.font = [UIFont boldSystemFontOfSize:14];
        _shopPriceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _shopPriceLabel;
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
        _priceDeleteLine.backgroundColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _priceDeleteLine;
}

- (UILabel *)colorLabel {
    if (!_colorLabel) {
        _colorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _colorLabel.font = [UIFont boldSystemFontOfSize:12];
        _colorLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _colorLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sizeLabel.font = [UIFont boldSystemFontOfSize:12];
        _sizeLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
    }
    return _sizeLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLabel.font = [UIFont boldSystemFontOfSize:16];
        _stateLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _stateLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

@end
