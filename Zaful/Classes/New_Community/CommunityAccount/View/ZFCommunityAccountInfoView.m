
//
//  ZFCommunityAccountInfoView.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountInfoView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityAccountInfoModel.h"
#import "UIView+GBGesture.h"
#import "ZFCommunityViewModel.h"
#import "BigClickAreaButton.h"

@interface ZFCommunityAccountInfoView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *backgroundView;
@property (nonatomic, strong) UIButton              *backButton;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) BigClickAreaButton    *messageButton;
@property (nonatomic, strong) JSBadgeView           *badgeView;
@property (nonatomic, strong) BigClickAreaButton    *tipsButton;

@property (nonatomic, strong) UIImageView           *avatorImageView;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) BigClickAreaButton    *followButton;
@property (nonatomic, strong) UILabel               *followingNumberLabel;
@property (nonatomic, strong) BigClickAreaButton    *followingButton;
@property (nonatomic, strong) UILabel               *followerNumberLabel;
@property (nonatomic, strong) BigClickAreaButton    *followerButton;
@property (nonatomic, strong) UILabel               *belikeNumberLabel;
@property (nonatomic, strong) UIButton              *belikeButton;

@property (nonatomic, strong) ZFCommunityViewModel  *viewModel;
@end

@implementation ZFCommunityAccountInfoView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        
    }
    return self;
}

#pragma mark - action methods
- (void)backButtonAction:(UIButton *)sender {
    if (self.backButtonActionCompletionHandler) {
        self.backButtonActionCompletionHandler();
    }
}

- (void)messageButtonAction:(UIButton *)sender {
    self.messageCount = nil;
    if (self.messageButtonActionCompletionHandler) {
        self.messageButtonActionCompletionHandler();
    }
}

- (void)tipsButtonAction:(UIButton *)sender {
    if (self.tipsButtonActionCompletionHandler) {
        self.tipsButtonActionCompletionHandler();
    }
}

- (void)followButtonAction:(UIButton *)sender {

    if (self.communityAccountFollowCompletionHandler) {
        self.communityAccountFollowCompletionHandler(self.model);
    }

}

- (void)followingButtonAction:(UIButton *)sender {
    if (self.followingButtonActionCompletionHandler) {
        self.followingButtonActionCompletionHandler();
    }
}

- (void)followersButtonAction:(UIButton *)sender {
    if (self.followerButtonActionCompletionHandler) {
        self.followerButtonActionCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.backgroundView];
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageButton];
    [self addSubview:self.tipsButton];
    
    [self addSubview:self.avatorImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.followButton];
    
    [self addSubview:self.followingNumberLabel];
    [self addSubview:self.followingButton];
    [self addSubview:self.followerNumberLabel];
    [self addSubview:self.followerButton];
    [self addSubview:self.belikeNumberLabel];
    [self addSubview:self.belikeButton];
}

- (void)zfAutoLayoutView {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    CGFloat offsetY = IPHONE_X_5_15 ? 44.0f : 20.0f;
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(offsetY);
        make.leading.mas_equalTo(self.mas_leading);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(60);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).mas_offset(offsetY);
        make.size.mas_equalTo(CGSizeMake(140, 44));
    }];
    
    [self.tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(offsetY);
        make.trailing.mas_equalTo(self.mas_trailing);
        make.width.mas_equalTo(40);
    }];
    
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(offsetY);
        make.trailing.mas_equalTo(self.tipsButton.mas_leading);
        make.width.mas_equalTo(40);
    }];
    
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    self.avatorImageView.layer.cornerRadius = 30;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.avatorImageView.mas_bottom).offset(4);
        make.leading.mas_equalTo(self.mas_leading).offset(16);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-16);
    }];

    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.avatorImageView.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-16);
        make.size.mas_equalTo(CGSizeMake(94, 26));
    }];

    [self.followingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(![SystemConfigUtils isRightToLeftShow] ? -(SCREEN_WIDTH / 4.0) : SCREEN_WIDTH / 4.0);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(16);
    }];
    
    [self.followingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.followingNumberLabel.mas_centerX);
        make.top.mas_equalTo(self.belikeNumberLabel.mas_bottom);
    }];
    
    [self.followerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(16);
    }];
    
    [self.followerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.followerNumberLabel.mas_centerX);
        make.top.mas_equalTo(self.belikeNumberLabel.mas_bottom);
    }];
    
    [self.belikeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset([SystemConfigUtils isRightToLeftShow] ? -(SCREEN_WIDTH / 4.0) : SCREEN_WIDTH / 4.0);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(16);
    }];
    
    [self.belikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.belikeNumberLabel.mas_centerX);
        make.top.mas_equalTo(self.belikeNumberLabel.mas_bottom);
    }];
}

#pragma mark - setter
- (void)setMessageCount:(NSString *)messageCount {
    _messageCount = messageCount;
    self.badgeView.badgeText = _messageCount;
    
}

- (void)setModel:(ZFCommunityAccountInfoModel *)model {
    _model = model;
    [self.avatorImageView yy_setImageWithURL:[NSURL URLWithString:_model.avatar]
                      processorKey:NSStringFromClass([self class])
                       placeholder:[UIImage imageNamed:@"Account"]
                           options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                         transform:^UIImage *(UIImage *image, NSURL *url) {
                             return image;
                         }
                        completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                        }];

    self.nameLabel.text = _model.nickName;
    self.followingNumberLabel.text = [NSString stringWithFormat:@"%lu", _model.followingCount];
    self.followerNumberLabel.text = [NSString stringWithFormat:@"%lu", _model.followersCount];
    self.belikeNumberLabel.text = [NSString stringWithFormat:@"%lu", _model.likeCount];
    

    self.isFollow = _model.isFollow;
    
    if ([_model.userId isEqualToString:USERID]) {
        self.messageButton.hidden = NO;
        self.tipsButton.hidden = NO;
    }
}

- (void)setIsFollow:(BOOL)isFollow {
    _isFollow = isFollow;
    _model.isFollow = _isFollow;
    if ([_model.userId isEqualToString:USERID]) {
        self.followButton.hidden = YES;
    }else{
        self.followButton.hidden = NO;
        if (_isFollow) {
            if ([SystemConfigUtils isRightToLeftShow]) {
                [self.followButton setTitle:[NSString stringWithFormat:@"%@ ",ZFLocalizedString(@"StyleHeaderView_Followed",nil)] forState:UIControlStateNormal];
            } else {
                [self.followButton setTitle:[NSString stringWithFormat:@" %@",ZFLocalizedString(@"StyleHeaderView_Followed",nil)] forState:UIControlStateNormal];
            }
            [self.followButton setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateNormal];
        }else{
            if ([SystemConfigUtils isRightToLeftShow]) {
                [self.followButton setTitle:[NSString stringWithFormat:@"%@ ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            } else {
                [self.followButton setTitle:[NSString stringWithFormat:@" %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            }
            [self.followButton setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - getter
- (ZFCommunityViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityViewModel alloc] init];
    }
    return _viewModel;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"styleHeaderbg"]];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundView.clipsToBounds = YES;
    }
    return _backgroundView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (![SystemConfigUtils isRightToLeftShow]) {
            [_backButton setImage:[UIImage imageNamed:@"back_w_left"] forState:UIControlStateNormal];
        } else {
            [_backButton setImage:[UIImage imageNamed:@"back_w_right"] forState:UIControlStateNormal];
        }
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = ZFLocalizedString(@"MyStylePage_VC_Title",nil);
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = ZFCOLOR_WHITE;
    }
    return _titleLabel;
}

- (BigClickAreaButton *)messageButton {
    if (!_messageButton) {
        _messageButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _messageButton.clickAreaRadious = 60;
        [_messageButton setImage:[UIImage imageNamed:@"Message-1"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _messageButton.hidden = YES;
    }
    return _messageButton;
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        if ([SystemConfigUtils isRightToLeftShow]) {
            _badgeView = [[JSBadgeView alloc]initWithParentView:self.messageButton alignment:JSBadgeViewAlignmentTopLeft];
            _badgeView.badgePositionAdjustment = CGPointMake(6, 0);
        } else {
            _badgeView = [[JSBadgeView alloc]initWithParentView:self.messageButton alignment:JSBadgeViewAlignmentTopRight];
            _badgeView.badgePositionAdjustment = CGPointMake(8, -15);
        }
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:9];
        _badgeView.badgeBackgroundColor = ZFCOLOR_WHITE;
        _badgeView.badgeTextColor = BADGE_BACKGROUNDCOLOR;
    }
    return _badgeView;
}

- (BigClickAreaButton *)tipsButton {
    if (!_tipsButton) {
        _tipsButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _tipsButton.clickAreaRadious = 60;
        [_tipsButton setImage:[UIImage imageNamed:@"style_how"] forState:UIControlStateNormal];
        [_tipsButton addTarget:self action:@selector(tipsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _tipsButton.hidden = YES;
    }
    return _tipsButton;
}

- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatorImageView.userInteractionEnabled = YES;
        _avatorImageView.contentMode = UIViewContentModeScaleToFill;
        _avatorImageView.image = [UIImage imageNamed:@"account_empty"];
        _avatorImageView.clipsToBounds = YES;
        _avatorImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatorImageView.layer.borderWidth = 3*DSCREEN_WIDTH_SCALE;
        
        _avatorImageView.layer.masksToBounds = YES;
    }
    return _avatorImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (BigClickAreaButton *)followButton {
    if (!_followButton) {
        _followButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _followButton.backgroundColor = [UIColor whiteColor];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followButton setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        _followButton.adjustsImageWhenHighlighted = NO;
        _followButton.layer.cornerRadius = 13;
        _followButton.layer.masksToBounds = YES;
        _followButton.layer.borderColor = ZFCOLOR(221, 221, 221, 1).CGColor;
        _followButton.hidden = YES;
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_followButton setTitle:[NSString stringWithFormat:@"%@ ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
        } else {
            [_followButton setTitle:[NSString stringWithFormat:@" %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
        }
        _followButton.layer.borderWidth = MIN_PIXEL;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followButton;
}

- (UILabel *)followingNumberLabel {
    if (!_followingNumberLabel) {
        _followingNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _followingNumberLabel.textColor = ZFCOLOR_WHITE;
        _followingNumberLabel.font = [UIFont boldSystemFontOfSize:18];
        _followingNumberLabel.textAlignment = NSTextAlignmentCenter;
        _followingNumberLabel.text = @"0";
    }
    return _followingNumberLabel;
}

- (BigClickAreaButton *)followingButton {
    if (!_followingButton) {
        _followingButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _followingButton.backgroundColor = [UIColor clearColor];
        _followingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _followingButton.titleLabel.numberOfLines = 0;
        _followingButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followingButton setTitle:ZFLocalizedString(@"StyleHeaderView_Following",nil) forState:UIControlStateNormal];
        [_followingButton addTarget:self action:@selector(followingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _followingButton;
}

- (UILabel *)followerNumberLabel {
    if (!_followerNumberLabel) {
        _followerNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _followerNumberLabel.textColor = ZFCOLOR_WHITE;
        _followerNumberLabel.font = [UIFont boldSystemFontOfSize:18];
        _followerNumberLabel.textAlignment = NSTextAlignmentCenter;
        _followerNumberLabel.text = @"0";
    }
    return _followerNumberLabel;
}

- (BigClickAreaButton *)followerButton {
    if (!_followerButton) {
        _followerButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _followerButton.backgroundColor = [UIColor clearColor];
        _followerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _followerButton.titleLabel.numberOfLines = 0;
        _followerButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_followerButton setTitle:ZFLocalizedString(@"StyleHeaderView_Followers",nil) forState:UIControlStateNormal];
        [_followerButton addTarget:self action:@selector(followersButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followerButton;
}

- (UILabel *)belikeNumberLabel {
    if (!_belikeNumberLabel) {
        _belikeNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _belikeNumberLabel.textColor = ZFCOLOR_WHITE;
        _belikeNumberLabel.font = [UIFont boldSystemFontOfSize:18];
        _belikeNumberLabel.textAlignment = NSTextAlignmentCenter;
        _belikeNumberLabel.text = @"0";
    }
    return _belikeNumberLabel;
}

- (UIButton *)belikeButton {
    if (!_belikeButton) {
        _belikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _belikeButton.backgroundColor = [UIColor clearColor];
        _belikeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _belikeButton.titleLabel.numberOfLines = 0;
        [_belikeButton setTitle:ZFLocalizedString(@"StyleHeaderView_BeLiked",nil) forState:UIControlStateNormal];
        _belikeButton.titleLabel.font = [UIFont systemFontOfSize:12];
//        [_belikeButton addTarget:self action:@selector(beLikedBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _belikeButton.enabled = NO;
    }
    return _belikeButton;
}
@end
