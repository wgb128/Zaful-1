//
//  ZFGoodsDetailSizeSelectView.m
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailSizeSelectView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"

@interface ZFGoodsDetailSizeSelectView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel           *infoLabel;
@property (nonatomic, strong) UIImageView       *moreImageView;
@property (nonatomic, strong) UIView            *lineView;
@end

@implementation ZFGoodsDetailSizeSelectView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.goodsDetailSizeSelectCompletionHandler) {
                self.goodsDetailSizeSelectCompletionHandler();
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.moreImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.trailing.mas_equalTo(self.moreImageView.mas_leading).offset(-10);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.width.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    __block NSMutableArray *propeties = [NSMutableArray array];
    
    [_model.same_goods_spec.color enumerateObjectsUsingBlock:^(GoodsDetialColorModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_model.goods_id isEqualToString:obj.goods_id]) {
            [propeties addObject:obj.attr_value];
        }
    }];
    
    [_model.same_goods_spec.size enumerateObjectsUsingBlock:^(GoodsDetialSizeModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_model.goods_id isEqualToString:obj.goods_id]) {
            [propeties addObject:obj.attr_value];
        }
    }];
    
    [_model.goods_mulit_attr enumerateObjectsUsingBlock:^(GoodsDetailMulitAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.value enumerateObjectsUsingBlock:^(GoodsDetailMulitAttrInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_model.goods_id isEqualToString:obj.goods_id]) {
                [propeties addObject:obj.attr_value];
            }
        }];
    }];
    
    NSMutableString *info = [NSMutableString string];
    [propeties enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [info appendString:[NSString stringWithFormat:@"%@, ", obj]];
    }];
    
    self.infoLabel.text = [info substringToIndex:info.length-2];
}

#pragma mark - getter
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _infoLabel.font = [UIFont systemFontOfSize:14];
//        _infoLabel.text = @"Black, S, Long Sleeves, Off The Shoulder";
    }
    return _infoLabel;
}

- (UIImageView *)moreImageView {
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _moreImageView.image = [UIImage imageNamed:@"community_delete"];
    }
    return _moreImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return _lineView;
}
@end
