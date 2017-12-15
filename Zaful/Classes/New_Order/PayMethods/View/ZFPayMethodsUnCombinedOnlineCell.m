
//
//  ZFPayMethodsUnCombinedOnlineCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsUnCombinedOnlineCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFPaymentGoodsInfoView.h"
#import "ZFPayMethodsChildModel.h"

@interface ZFPayMethodsUnCombinedOnlineCell() <ZFInitViewProtocol>
@property (nonatomic, strong) ZFPaymentGoodsInfoView    *codGoodsInfoView;
@property (nonatomic, strong) UIView                    *bottomSepareView;
@end

@implementation ZFPayMethodsUnCombinedOnlineCell
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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.codGoodsInfoView];
//    [self.contentView addSubview:self.bottomSepareView];
}

- (void)zfAutoLayoutView {
    [self.codGoodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(32);
        make.height.mas_equalTo(144);
         make.bottom.mas_equalTo(self.contentView);
    }];
    
//    [self.bottomSepareView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.codGoodsInfoView.mas_bottom);
//        make.height.mas_equalTo(12);
//        make.leading.trailing.bottom.mas_equalTo(self.contentView);
//    }];
}

#pragma mark - Setter
- (void)setModel:(ZFPayMethodsChildModel *)model {
    _model = model;
    self.codGoodsInfoView.dataArray = model.goodsList;
}

#pragma mark - getter
- (ZFPaymentGoodsInfoView *)codGoodsInfoView {
    if (!_codGoodsInfoView) {
        _codGoodsInfoView = [[ZFPaymentGoodsInfoView alloc] initWithFrame:CGRectZero];
    }
    return _codGoodsInfoView;
}

- (UIView *)bottomSepareView {
    if (!_bottomSepareView) {
        _bottomSepareView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomSepareView.backgroundColor = ZFCOLOR(226, 226, 226, 1.f);
    }
    return _bottomSepareView;
}
@end
