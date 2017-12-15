//
//  GoodsImageCell.m
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "GoodsImageCell.h"

@interface GoodsImageCell ()

@property (nonatomic, strong) YYAnimatedImageView *goodsImageView;

@property (nonatomic, strong) UIButton *deleteGoodsButton;

@end

@implementation GoodsImageCell

+ (GoodsImageCell *)goodsImageCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[GoodsImageCell class] forCellWithReuseIdentifier:NSStringFromClass([GoodsImageCell class])];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GoodsImageCell class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _goodsImageView = [[YYAnimatedImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        _goodsImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_goodsImageView];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _deleteGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteGoodsButton.backgroundColor = [UIColor whiteColor];
        [_deleteGoodsButton setBackgroundImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
        [_deleteGoodsButton addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];
        [_goodsImageView addSubview:_deleteGoodsButton];
        
        [_deleteGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(_goodsImageView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
    }
    return self;
}

-(void)setGoodsImage:(UIImage *)goodsImage {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _goodsImage = goodsImage;
    self.goodsImageView.image = goodsImage;
    BOOL isHidden = [goodsImage isEqual:[UIImage imageNamed:@"add_photo"]];
    self.deleteGoodsButton.hidden = isHidden ? YES : NO;
    self.goodsImageView.hidden = self.isNeedHiddenAddView ? YES : NO;
}

-(void)setModel:(SelectGoodsModel *)model {
    _model = model;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:model.imageURL] processorKey:NSStringFromClass([self class]) placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        // CGFloat width = (SCREEN_WIDTH - 5 * KImageMargin) / 4;
        //image = [image yy_imageByResizeToSize:CGSizeMake(width,width * DSCREEN_WIDTH_SCALE) contentMode:UIViewContentModeScaleAspectFit];
        BOOL isHidden = [image isEqual:[UIImage imageNamed:@"add_photo"]];
        self.deleteGoodsButton.hidden = isHidden ? YES : NO;
    }];
}

- (void)deleteGoods:(UIButton *)sender {
    if (self.deleteGoodBlock) {
        self.deleteGoodBlock(self.model);
    }
}

- (void)prepareForReuse {
    [self.goodsImageView yy_cancelCurrentImageRequest];
    self.goodsImageView.image = nil;
    self.goodsImageView.hidden = NO;
    self.deleteGoodsButton.hidden = NO;
}

@end
