//
//  ZFRecommendInfoCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/12/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFRecommendInfoCollectionViewCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFRecommendInfoCollectionViewCell() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *iconImageView;
@property (nonatomic, strong) UILabel               *shopPriceLabel;

@end

@implementation ZFRecommendInfoCollectionViewCell
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
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.shopPriceLabel];
}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView);
        make.height.mas_equalTo(200 * SCREEN_WIDTH_SCALE);
        make.width.mas_offset(150 * SCREEN_WIDTH_SCALE);
    }];
    
    [self.shopPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8);
        make.height.mas_equalTo(20);
    }];

}

#pragma mark - setter
- (void)setModel:(GoodsDetailSameModel *)model {
    _model = model;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image]
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
    self.shopPriceLabel.text = [ExchangeManager transforPrice: _model.shop_price];
    
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}

- (UILabel *)shopPriceLabel {
    if (!_shopPriceLabel) {
        _shopPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shopPriceLabel;
}


@end
