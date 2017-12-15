//
//  ZFCollectionMultipleColumnCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/22.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCollectionMultipleColumnCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCollectionModel.h"
#import "ZFPriceView.h"
#import "ZFBaseGoodsModel.h"

@interface ZFCollectionMultipleColumnCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *goodsImageView;
@property (nonatomic, strong) UIButton              *collectButton;
@property (nonatomic, strong) ZFPriceView           *priceView;
@end

@implementation ZFCollectionMultipleColumnCell
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
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.collectButton];
    [self.contentView addSubview:self.priceView];
}

- (void)zfAutoLayoutView {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.goodsImageView.mas_width).multipliedBy(1.33);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(4);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-4);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(8);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCollectionModel *)model {
    _model = model;


    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image]
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
    
    self.priceView.model = [self adapterModel:model];
}

- (ZFBaseGoodsModel *)adapterModel:(ZFCollectionModel *)goodsModel {
    ZFBaseGoodsModel *model = [[ZFBaseGoodsModel alloc] init];
    model.shopPrice = goodsModel.shop_price;
    model.marketPrice = goodsModel.market_price;
    model.is_promote = goodsModel.is_promote;
    model.is_mobile_price = [NSString stringWithFormat:@"%ld",goodsModel.is_mobile_price];
    model.promote_zhekou = goodsModel.promote_zhekou;
    model.is_cod = goodsModel.is_cod;
    return model;
}

#pragma mark - getter
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _goodsImageView;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"collection_liked"] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (ZFPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[ZFPriceView alloc] init];
        [self.contentView addSubview:_priceView];
    }
    return _priceView;
}

@end
