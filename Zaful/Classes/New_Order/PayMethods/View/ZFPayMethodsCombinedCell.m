//
//  ZFPayMethodsCombinedCell.m
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFPayMethodsCombinedCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFPaymentGoodsInfoView.h"
#import "ZFPayMethodsChildModel.h"
#import "ZFPayMethodsWaysModel.h"

@interface ZFPayMethodsCombinedCell() <ZFInitViewProtocol>

@property (nonatomic, strong) UILabel                   *codTitleLabel;
@property (nonatomic, strong) ZFPaymentGoodsInfoView    *codGoodsInfoView;
@property (nonatomic, strong) UILabel                   *codTipsLabel;
@property (nonatomic, strong) UIView                    *lineView;
@property (nonatomic, strong) UILabel                   *onlineTitleLabel;
@property (nonatomic, strong) ZFPaymentGoodsInfoView    *onlineGoodsInfoView;

@end

@implementation ZFPayMethodsCombinedCell
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
    [self.contentView addSubview:self.codTitleLabel];
    [self.contentView addSubview:self.codGoodsInfoView];
    [self.contentView addSubview:self.codTipsLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.onlineTitleLabel];
    [self.contentView addSubview:self.onlineGoodsInfoView];
}

- (void)zfAutoLayoutView {
    [self.codTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(44);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.codGoodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(32);
        make.height.mas_equalTo(144);
        make.top.mas_equalTo(self.codTitleLabel.mas_bottom);
        
    }];
    
    [self.codTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.codTitleLabel);
        make.top.mas_equalTo(self.codGoodsInfoView.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.codTitleLabel);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.codTipsLabel.mas_bottom).offset(12);
    }];
    
    [self.onlineTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(44);
        make.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    [self.onlineGoodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(32);
        make.height.mas_equalTo(144);
        make.top.mas_equalTo(self.onlineTitleLabel.mas_bottom);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
}

#pragma mark - Setter
- (void)setCodMsg:(NSString *)codMsg {
    _codMsg = codMsg;
    self.codTipsLabel.text = codMsg;
}

- (void)setModel:(ZFPayMethodsWaysModel *)model {
    _model = model;
    
    for (ZFPayMethodsChildModel *cellModel in model.child) {
        switch (cellModel.type) {
            case 1:
                self.codGoodsInfoView.dataArray = cellModel.goodsList;
                break;
            case 2:
                self.onlineGoodsInfoView.dataArray = cellModel.goodsList;
                break;
        }
    }
    
}

#pragma mark - getter
- (UILabel *)codTitleLabel {
    if (!_codTitleLabel) {
        _codTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _codTitleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _codTitleLabel.font = [UIFont systemFontOfSize:12];
        _codTitleLabel.text = ZFLocalizedString(@"ZFPaymentCod", nil);
    }
    return _codTitleLabel;
}

- (ZFPaymentGoodsInfoView *)codGoodsInfoView {
    if (!_codGoodsInfoView) {
        _codGoodsInfoView = [[ZFPaymentGoodsInfoView alloc] initWithFrame:CGRectZero];
    }
    return _codGoodsInfoView;
}

- (UILabel *)codTipsLabel {
    if (!_codTipsLabel) {
        _codTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _codTipsLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _codTipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _codTipsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(226, 226, 226, 1.f);
    }
    return _lineView;
}

- (UILabel *)onlineTitleLabel {
    if (!_onlineTitleLabel) {
        _onlineTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _onlineTitleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _onlineTitleLabel.font = [UIFont systemFontOfSize:12];
        _onlineTitleLabel.text = ZFLocalizedString(@"ZFPaymentOnline", nil);
        
    }
    return _onlineTitleLabel;
}

- (ZFPaymentGoodsInfoView *)onlineGoodsInfoView {
    if (!_onlineGoodsInfoView) {
        _onlineGoodsInfoView = [[ZFPaymentGoodsInfoView alloc] initWithFrame:CGRectZero];
    }
    return _onlineGoodsInfoView;
}

@end
