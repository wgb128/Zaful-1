


//
//  ZFCartRecentHistoryCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartRecentHistoryCollectionViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFPriceView.h"
#import "CommendModel.h"
#import "ZFBaseGoodsModel.h"

@interface ZFCartRecentHistoryCollectionViewCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView               *goodsImageView;
@property (nonatomic, strong) ZFPriceView               *priceView;
@end

@implementation ZFCartRecentHistoryCollectionViewCell
- (void)prepareForReuse {
    [self.goodsImageView yy_cancelCurrentImageRequest];
    self.goodsImageView.image = nil;
    [self.priceView clearAllData];
}


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
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.priceView];
}

- (void)zfAutoLayoutView {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(150 * SCREEN_WIDTH_SCALE, 200 * SCREEN_WIDTH_SCALE));
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(8);
    }];
}

#pragma mark - setter

- (void)setItemModel:(CommendModel *)itemModel {
    _itemModel = itemModel;
    
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:itemModel.wp_image]
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
    
    self.priceView.model = [self adapterModel:itemModel];
}

- (ZFBaseGoodsModel *)adapterModel:(CommendModel *)goodsModel {
    ZFBaseGoodsModel *model = [[ZFBaseGoodsModel alloc] init];
    model.shopPrice = goodsModel.goodsPrice;
    model.marketPrice = goodsModel.promotePrice;
    model.is_promote = goodsModel.is_promote;
    model.promote_zhekou = goodsModel.promote_zhekou;
    ZFLog(@"====> %@",goodsModel.promote_zhekou);
    model.is_mobile_price =  goodsModel.is_mobile_price;
    model.is_cod = goodsModel.is_cod;
    return model;
}


#pragma mark - getter
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsImageView.layer.borderWidth = 0.5;
        _goodsImageView.layer.borderColor = ZFCOLOR(241, 241, 241, 1.0).CGColor;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}

- (ZFPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[ZFPriceView alloc] initWithFrame:CGRectZero];
    }
    return _priceView;
}

@end
