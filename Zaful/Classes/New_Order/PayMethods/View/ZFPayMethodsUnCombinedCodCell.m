
//
//  ZFPayMethodsUnCombinedCodCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsUnCombinedCodCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFPaymentGoodsInfoView.h"
#import "ZFPayMethodsChildModel.h"

@interface ZFPayMethodsUnCombinedCodCell() <ZFInitViewProtocol>
@property (nonatomic, strong) ZFPaymentGoodsInfoView    *codGoodsInfoView;
@property (nonatomic, strong) UILabel                   *codTipsLabel;

@end

@implementation ZFPayMethodsUnCombinedCodCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Setter
- (void)setModel:(ZFPayMethodsChildModel *)model {
    _model = model;
    self.codGoodsInfoView.dataArray = model.goodsList;
}

- (void)setCodMsg:(NSString *)codMsg {
    _codMsg = codMsg;
    self.codTipsLabel.text = codMsg;;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.codGoodsInfoView];
    [self.contentView addSubview:self.codTipsLabel];
}

- (void)zfAutoLayoutView {
    [self.codGoodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(32);
        make.height.mas_equalTo(144);
    }];
    
    [self.codTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codGoodsInfoView.mas_bottom);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(44);
        make.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
    }];
}

#pragma mark - getter
- (ZFPaymentGoodsInfoView *)codGoodsInfoView {
    if (!_codGoodsInfoView) {
        _codGoodsInfoView = [[ZFPaymentGoodsInfoView alloc] initWithFrame:CGRectZero];
    }
    return _codGoodsInfoView;
}

- (UILabel *)codTipsLabel {
    if (!_codTipsLabel) {
        _codTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _codTipsLabel.textColor = ZFCOLOR(153, 153, 153, 1);
        _codTipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _codTipsLabel;
}


@end
