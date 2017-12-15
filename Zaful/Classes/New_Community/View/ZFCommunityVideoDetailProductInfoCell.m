
//
//  ZFCommunityVideoDetailProductInfoCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailProductInfoCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityVideoDetailProductInfoCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView                *containerView;
@property (nonatomic, strong) UIImageView           *productImageView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIImageView           *arrowImageView;
@property (nonatomic, strong) UILabel               *priceLabel;

@end

@implementation ZFCommunityVideoDetailProductInfoCell
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
    self.contentView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.productImageView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.arrowImageView];
    [self.containerView addSubview:self.priceLabel];
}

- (void)zfAutoLayoutView {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.containerView.mas_bottom).mas_offset(-10);
        make.leading.mas_equalTo(self.containerView.mas_leading).mas_offset(10);
        make.width.height.mas_equalTo(84);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.productImageView.mas_trailing).mas_offset(10);
        make.trailing.mas_equalTo(self.containerView.mas_trailing).mas_offset(-40);
        make.top.mas_equalTo(self.productImageView.mas_top).mas_offset(2);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.containerView.mas_centerY);
        make.trailing.mas_equalTo(self.containerView.mas_trailing).mas_offset(-20);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
        make.bottom.mas_equalTo(self.productImageView.mas_bottom).mas_offset(-2);
    }];
}

#pragma mark - getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containerView;
}

- (UIImageView *)productImageView {
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
    }
    return _productImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.image = [UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"detail_left_arrow" : @"detail_right_arrow"];
        
    }
    return _arrowImageView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:18];
        _priceLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }
    return _priceLabel;
}

@end
