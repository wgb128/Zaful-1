//
//  ZFCommunityDetailHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailHeaderView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityDetailLikesShowView.h"
#import "ZFCommunityDetailModel.h"

@interface ZFCommunityDetailHeaderView () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView                       *avatarImageView;
@property (nonatomic, strong) UILabel                           *nameLabel;
@property (nonatomic, strong) UILabel                           *topLabel;
@property (nonatomic, strong) UILabel                           *addTimeLabel;
@property (nonatomic, strong) UIButton                          *followButton;
@property (nonatomic, strong) UIView                            *imageContainerView;
@property (nonatomic, strong) YYLabel                           *contentLabel;
@property (nonatomic, strong) ZFCommunityDetailLikesShowView    *likesShowView;
@property (nonatomic, strong) UIButton                          *shareButton;
@property (nonatomic, strong) UIButton                          *reviewButton;
@property (nonatomic, strong) UILabel                           *reviewNumberLabel;
@property (nonatomic, strong) UIButton                          *likeButton;
@property (nonatomic, strong) UILabel                           *likeNumberLabel;

@end

@implementation ZFCommunityDetailHeaderView
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
- (void)followButtonAction:(UIButton *)sender {
    
}



#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.topLabel];
    [self.contentView addSubview:self.addTimeLabel];
    [self.contentView addSubview:self.followButton];
    [self.contentView addSubview:self.imageContainerView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.likesShowView];
//    [self.contentView addSubview:self.shareButton];
//    [self.contentView addSubview:self.reviewButton];
//    [self.contentView addSubview:self.reviewNumberLabel];
//    [self.contentView addSubview:self.likeButton];
//    [self.contentView addSubview:self.likeNumberLabel];
    
}

- (void)zfAutoLayoutView {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(12);
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(10);
        make.width.height.mas_equalTo(@40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatarImageView.mas_trailing).mas_offset(10);
        make.top.mas_equalTo(self.avatarImageView.mas_top).mas_offset(3);
    }];
    
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.nameLabel.mas_top);
    }];
    
    [self.addTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImageView.mas_bottom).mas_offset(-3);
        make.leading.mas_equalTo(self.nameLabel.mas_leading).mas_offset(2);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatarImageView.mas_centerY);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
        make.size.mas_equalTo(CGSizeMake(94, 26));
    }];
    
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        make.top.mas_equalTo(self.avatarImageView.mas_bottom).mas_offset(8);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(10);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-10);
        make.top.mas_equalTo(self.imageContainerView.mas_bottom).mas_offset(8);
    }];
    
    [self.likesShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing);
        //点赞容器一开始高度为0 根据数据返回是否有点赞用户再设置高度 -> 40h
        make.height.mas_equalTo(@0);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(16);
    }];
    /*
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.reviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.reviewNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
     */
}

#pragma mark - setter
- (void)setModel:(ZFCommunityDetailModel *)model {
    _model = model;
    [self.avatarImageView setYy_imageURL:[NSURL URLWithString:_model.avatar]];
    self.nameLabel.text = _model.nickname;
    self.followButton.hidden = _model.isFollow;
    
    
}

#pragma mark - getter
- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 20.0;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _nameLabel;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.backgroundColor = ZFCOLOR(255, 168, 0, 1.0);
        _topLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _topLabel.text = ZFLocalizedString(@"Community_TOP",nil);
        _topLabel.hidden = YES;
        _topLabel.clipsToBounds = YES;
        _topLabel.layer.masksToBounds = YES;
    }
    return _topLabel;
}

- (UILabel *)addTimeLabel {
    if (!_addTimeLabel) {
        _addTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addTimeLabel.font = [UIFont systemFontOfSize:10];
        _addTimeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    }
    return _addTimeLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.layer.borderColor = ZFCOLOR(102, 102, 102, 1).CGColor;
        [_followButton setTitleColor:ZFCOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_followButton setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        } else {
            [_followButton setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.layer.borderWidth = 1;
        _followButton.layer.cornerRadius = 2;
        _followButton.layer.masksToBounds = YES;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _followButton;
}

- (UIView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _imageContainerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _imageContainerView;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.numberOfLines = 0;
        _contentLabel.linePositionModifier = modifier;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);

    }
    return _contentLabel;
}

- (ZFCommunityDetailLikesShowView *)likesShowView {
    if (!_likesShowView) {
        _likesShowView = [[ZFCommunityDetailLikesShowView alloc] initWithFrame:CGRectZero];
    }
    return _likesShowView;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _shareButton;
}

- (UIButton *)reviewButton {
    if (!_reviewButton) {
        _reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _reviewButton;
}

- (UILabel *)reviewNumberLabel {
    if (!_reviewNumberLabel) {
        _reviewNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _reviewNumberLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _likeButton;
}

- (UILabel *)likeNumberLabel {
    if (!_likeNumberLabel) {
        _likeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _likeNumberLabel;
}
@end
