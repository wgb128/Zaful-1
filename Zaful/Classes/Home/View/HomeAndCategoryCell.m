//
//  HomeAndCategoryCell.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeAndCategoryCell.h"
#import "ZFPriceView.h"
#import "ZFBaseGoodsModel.h"

static CGFloat const KImgViewHeight = 218.0; // 图片高度

@interface HomeAndCategoryCell ()
@property (nonatomic, strong) YYAnimatedImageView       * goodsImageView;
@property (nonatomic, strong) YYAnimatedImageView       * activityView;
@property (nonatomic, strong) ZFPriceView               *priceView;
@property (nonatomic, assign) NSInteger                 index_row;
@end

@implementation HomeAndCategoryCell

+ (HomeAndCategoryCell *)homeAndCategoryCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath  forRow:(NSInteger)row {
    [collectionView registerClass:[HomeAndCategoryCell class]  forCellWithReuseIdentifier:NSStringFromClass([self class])];
    HomeAndCategoryCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    cell.index_row = row;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setMasMake];
    }
    return self;
}

- (void)setGoodsModel:(GoodsModel *)goodsModel {
    _goodsModel = goodsModel;
    
    /** 商品图片*/
    [self.goodsImageView  yy_setImageWithURL:[NSURL URLWithString:goodsModel.wp_image]
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
                                      }
                                  }];

    switch (_goodsModel.activityType) {
        case ZFActivityTypeBlackFive:
            self.activityView.image = [UIImage imageNamed:@"blackfive"];
            break;
        case ZFActivityTypeDoubleEleven:
            self.activityView.image = [UIImage imageNamed:@"double11"];
            break;
        case ZFActivityTypeUnknown:
            self.activityView.image = nil;
            break;
    }
    
    self.priceView.model = [self adapterModel:goodsModel];

}

- (ZFBaseGoodsModel *)adapterModel:(GoodsModel *)goodsModel {
    ZFBaseGoodsModel *model = [[ZFBaseGoodsModel alloc] init];
    model.shopPrice         = [NSString stringWithFormat:@"%0.2f",goodsModel.shop_price];
    model.marketPrice       = [NSString stringWithFormat:@"%0.2f",goodsModel.market_price];
    model.is_promote        = goodsModel.is_promote;
    model.promote_zhekou    = [NSString stringWithFormat:@"%lu", goodsModel.promote_zhekou];
    model.is_mobile_price   = [NSString stringWithFormat:@"%ld",goodsModel.is_mobile_price];
    model.is_cod            = goodsModel.is_cod;
    return model;
}

- (void)setMasMake {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = self.bounds.size.width;
        CGFloat height = KImgViewHeight * SCREEN_WIDTH_SCALE;
        make.top.leading.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(width,height));
    }];
    
    //活动的图标
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
        make.leading.mas_equalTo(self.goodsImageView.mas_leading).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 44));
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(8);
    }];
}

#pragma mark - 懒加载
- (YYAnimatedImageView *)goodsImageView {
    if (_goodsImageView == nil) {
        _goodsImageView = [[YYAnimatedImageView alloc] init];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goodsImgClick:)];
        [_goodsImageView addGestureRecognizer:gest];
        [_goodsImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_goodsImageView];
    }
    return _goodsImageView;
}

- (YYAnimatedImageView *)activityView {
    if (_activityView == nil) {
        _activityView = [[YYAnimatedImageView alloc]init];
        [_activityView setImage:[UIImage imageNamed:@"blackfive"]];
        [self.contentView addSubview:_activityView];
    }
    return _activityView;
}

- (ZFPriceView *)priceView {
    if (!_priceView) {
        _priceView = [[ZFPriceView alloc] init];
        [self.contentView addSubview:_priceView];
    }
    return _priceView;
}

#pragma mark - Action
- (void)goodsImgClick:(UIGestureRecognizer *)gest {
    if (self.goodsClick) {
        _goodsClick(_goodsModel);
    }
}

- (void)prepareForReuse {
    self.goodsClick = nil;
    [self.goodsImageView yy_cancelCurrentImageRequest];
    self.goodsImageView.image = nil;
    self.activityView.image = nil;
    [self.priceView clearAllData];
}

@end
