//
//  ZFCommunityVideoDetailHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "YTPlayerView.h"

@interface ZFCommunityVideoDetailHeaderView () <ZFInitViewProtocol>
@property (nonatomic, strong) YTPlayerView      *playerVideo;
@property (nonatomic, strong) YYLabel           *descriptionLabel;
@property (nonatomic, strong) UIButton          *likeButton;
@property (nonatomic, strong) UILabel           *likeNumberLabel;
@property (nonatomic, strong) UIImageView       *viewsIconView;
@property (nonatomic, strong) UILabel           *viewsNumberLabel;
@property (nonatomic, strong) UIView            *lineView;
@end

@implementation ZFCommunityVideoDetailHeaderView
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)likeButtonAction:(UIButton *)sender {
    
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.playerVideo];
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.viewsIconView];
    [self.contentView addSubview:self.viewsNumberLabel];
    [self.contentView addSubview:self.likeNumberLabel];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.playerVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.contentView);
        make.height.mas_equalTo(210 * DSCREEN_WIDTH_SCALE);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.playerVideo.mas_bottom).mas_offset(5);
    }];
    
    [self.viewsIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.descriptionLabel.mas_bottom).offset(20);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
    }];
    
    [self.viewsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.viewsIconView.mas_centerY);
        make.leading.mas_equalTo(self.viewsIconView.mas_trailing).offset(3);
        make.height.mas_equalTo(40);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.viewsIconView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-10);
    }];
    
    [self.likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.viewsIconView.mas_centerY);
        make.trailing.mas_equalTo(self.likeButton.mas_leading).offset(-3);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.likeNumberLabel.mas_bottom);
        make.height.mas_equalTo(10);
    }];
}

#pragma mark - setter


#pragma mark - getter
- (YTPlayerView *)playerVideo {
    if (!_playerVideo) {
        _playerVideo = [[YTPlayerView alloc] initWithFrame:CGRectZero];
        [_playerVideo duration];
    }
    return _playerVideo;
}

- (YYLabel *)descriptionLabel {
    if (!_descriptionLabel) {
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 17;//行高
        _descriptionLabel = [YYLabel new];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.linePositionModifier = modifier;
        _descriptionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;//自动设置高度
        _descriptionLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _descriptionLabel.backgroundColor = ZFCOLOR_WHITE;
    }
    return _descriptionLabel;
}

- (UIImageView *)viewsIconView {
    if (!_viewsIconView) {
        _viewsIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"views"]];
    }
    return _viewsIconView;
}

- (UILabel *)viewsNumberLabel {
    if (!_viewsNumberLabel) {
        _viewsNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewsNumberLabel.font = [UIFont systemFontOfSize:12];
        _viewsNumberLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    }
    return _viewsNumberLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateSelected];
    }
    return _likeButton;
}

- (UILabel *)likeNumberLabel {
    if (!_likeNumberLabel) {
        _likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likeNumberLabel.font = [UIFont systemFontOfSize:12];
        _likeNumberLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    }
    return _likeNumberLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(246, 246, 246, 1.f);
    }
    return _lineView;
}

@end
