//
//  ListPageCell.m
//  ListPageViewController
//
//  Created by TsangFa on 19/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryListPageCell.h"
#import "CategoryGoodsModel.h"
#import "ZFPriceView.h"
#import "ZFBaseGoodsModel.h"

static CGFloat const KImgViewHeight = 226.0; // 图片高度

@interface CategoryListPageCell ()
@property (nonatomic, strong) YYLightView               *goodsImgView;
@property (nonatomic, strong) ZFPriceView               *priceView;
@end

@implementation CategoryListPageCell
#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.goodsImgView];
    [self.contentView addSubview:self.priceView];
}

- (void)autoLayoutSubViews {
    [self.goodsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = KImgViewHeight * SCREEN_WIDTH_SCALE;
        make.top.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(width,height));
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.goodsImgView.mas_bottom).offset(8);
    }];
}

#pragma mark - Setter
- (void)setModel:(CategoryGoodsModel *)model {
    _model = model;
    
    [self.goodsImgView.layer removeAnimationForKey:@"contents"];

    [self.goodsImgView.layer yy_setImageWithURL:[NSURL URLWithString:model.wp_image]
                                   processorKey:NSStringFromClass([self class])
                                    placeholder:nil
                                        options:YYWebImageOptionAvoidSetImage
                                     completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                         if (image && stage == YYWebImageStageFinished) {
                                             self.goodsImgView.image = image;
                                             if (from != YYWebImageFromMemoryCacheFast) {
                                                 CATransition *transition = [CATransition animation];
                                                 transition.duration = 0.25;
                                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                 transition.type = kCATransitionFade;
                                                 [self.goodsImgView.layer addAnimation:transition forKey:@"contents"];
                                             }
                                         }
                                     }];
    
    self.priceView.model = [self adapterModel:model];
}

- (ZFBaseGoodsModel *)adapterModel:(CategoryGoodsModel *)goodsModel {
    ZFBaseGoodsModel *model = [[ZFBaseGoodsModel alloc] init];
    model.shopPrice = goodsModel.shop_price;
    model.marketPrice = goodsModel.market_price;
    model.is_promote = goodsModel.is_promote;
    model.promote_zhekou = goodsModel.discount;
    model.is_mobile_price =  goodsModel.isExclusive;
    model.is_cod = goodsModel.is_cod;
    return model;
}

#pragma mark - Public Methods
+ (NSString *)setIdentifier {
    return @"ListPageCell_identifier";
}

#pragma mark - Rewrite Methods
- (void)prepareForReuse {
    [self.goodsImgView.layer yy_cancelCurrentImageRequest];
    self.goodsImgView.image = nil;
    [self.priceView clearAllData];
}

#pragma mark - Getter
- (YYLightView *)goodsImgView {
    if (!_goodsImgView) {
        _goodsImgView = [[YYLightView alloc] init];
        _goodsImgView.clipsToBounds = YES;
        _goodsImgView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    }
    return _goodsImgView;
}

- (ZFPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[ZFPriceView alloc] init];
        [self.contentView addSubview:_priceView];
    }
    return _priceView;
}


@end
