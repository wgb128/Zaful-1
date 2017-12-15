
//
//  ZFOrderGoodsInfoCollectionViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderGoodsInfoCollectionViewCell.h"
#import "ZFInitViewProtocol.h"
#import "CheckOutGoodListModel.h"

@interface ZFOrderGoodsInfoCollectionViewCell() <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *goodsImageView;
@property (nonatomic, strong) UIView                *maskView;
@property (nonatomic, strong) UILabel               *goodsNumberLabel;
@end

@implementation ZFOrderGoodsInfoCollectionViewCell
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
    [self.contentView addSubview:self.maskView];
    [self.maskView addSubview:self.goodsNumberLabel];
}

- (void)zfAutoLayoutView {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
    
    [self.goodsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
    }];
}

#pragma mark - setter
- (void)setModel:(CheckOutGoodListModel *)model {
    _model = model;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:_model.wp_image] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"loading_cat_list"]];
    self.goodsNumberLabel.text = [NSString stringWithFormat:@"x%@", _model.goods_number];
    
}

#pragma mark - getter
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _goodsImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [UIView new];
        _maskView.backgroundColor = ZFCOLOR(51, 51, 51, 0.3);
    }
    return _maskView;
}

- (UILabel *)goodsNumberLabel {
    if (!_goodsNumberLabel) {
        _goodsNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNumberLabel.textColor = ZFCOLOR_WHITE;
        _goodsNumberLabel.font = [UIFont systemFontOfSize:20];
        _goodsNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodsNumberLabel;
}

@end
