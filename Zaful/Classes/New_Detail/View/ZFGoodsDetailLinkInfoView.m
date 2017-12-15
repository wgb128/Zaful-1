

//
//  ZFGoodsDetailLinkInfoView.m
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailLinkInfoView.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"

@interface ZFGoodsDetailLinkInfoView() <ZFInitViewProtocol>
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *arrowImageView;
@property (nonatomic, strong) UIView        *lineView;
@end

@implementation ZFGoodsDetailLinkInfoView
#pragma mark - init methods
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        @weakify(self);
        [self addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.goodsDetailLinkJumpCompletionHandler) {
                self.goodsDetailLinkJumpCompletionHandler(self.linkUrl, self.titleLabel.text);
            }
        }];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.width.mas_equalTo(SCREEN_WIDTH / 1.5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel);
        make.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - setter
- (void)setLinkType:(ZFGoodsDetailLinkInfoType)linkType {
    _linkType = linkType;
    switch (_linkType) {
        case ZFGoodsDetailLinkInfoTypeShippingTips: {
            self.titleLabel.text = ZFLocalizedString(@"Detail_Product_Shipping_Tips",nil);
        }
            
            break;
        case ZFGoodsDetailLinkInfoTypeProductDescription: {
            self.titleLabel.text = ZFLocalizedString(@"Detail_Product_Description",nil);

        }
            
            break;
        case ZFGoodsDetailLinkInfoTypeSizeGuide: {
            self.titleLabel.text = ZFLocalizedString(@"Detail_Product_SizeGuides",nil);

        }
            
            break;
        case ZFGoodsDetailLinkInfoTypeModelStats: {
            self.titleLabel.text = ZFLocalizedString(@"Detail_Product_ModelStats",nil);
        }
            break;
    }
}

- (void)setLinkUrl:(NSString *)linkUrl {
    _linkUrl = linkUrl;
}

#pragma mark - getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        if ([SystemConfigUtils isRightToLeftShow]) {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_left"];
        } else {
            _arrowImageView.image = [UIImage imageNamed:@"size_arrow_right"];
        }
    }
    return _arrowImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}
@end
