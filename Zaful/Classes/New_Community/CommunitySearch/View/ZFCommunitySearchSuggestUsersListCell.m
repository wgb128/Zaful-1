

//
//  ZFCommunitySearchSuggestUsersListCell.m
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchSuggestUsersListCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunitySuggestedUsersModel.h"
#import "PictureModel.h"

@interface ZFCommunitySearchSuggestUsersListCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView           *userHeadImageView;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UILabel               *postsLabel;
@property (nonatomic, strong) UILabel               *beLikesLabel;
@property (nonatomic, strong) UIButton              *followButton;
@property (nonatomic, strong) UIView                *showImagesContentView;

@end

@implementation ZFCommunitySearchSuggestUsersListCell
- (void)prepareForReuse {
    self.userHeadImageView.image = nil;
    self.nameLabel.text = nil;
    self.postsLabel.text = nil;
    self.beLikesLabel.text = nil;
    [self.showImagesContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    }];
}

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
    if (self.followUserCompletionHandler) {
        self.followUserCompletionHandler(self.model);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.userHeadImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.postsLabel];
    [self.contentView addSubview:self.beLikesLabel];
    [self.contentView addSubview:self.followButton];
    [self.contentView addSubview:self.showImagesContentView];
}

- (void)zfAutoLayoutView {
    [self.userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39, 39));
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
    }];
    self.userHeadImageView.layer.cornerRadius = 39.0 / 2;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userHeadImageView.mas_trailing).offset(10);
        make.bottom.mas_equalTo(self.userHeadImageView.mas_centerY).offset(-2);
    }];
    
    [self.postsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.top.mas_equalTo(self.userHeadImageView.mas_centerY).offset(2);
    }];
    
    [self.beLikesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.postsLabel.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.postsLabel.mas_centerY);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.centerY.mas_equalTo(self.userHeadImageView.mas_centerY).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
    
    [self.showImagesContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.userHeadImageView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-24);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunitySuggestedUsersModel *)model {
    _model = model;
    [self.userHeadImageView setYy_imageURL:[NSURL URLWithString:_model.avatar]];
    self.nameLabel.text = _model.nickname;
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",_model.review_total,ZFLocalizedString(@"FriendsResultCell_Posts",nil)];
        self.beLikesLabel.text = [NSString stringWithFormat:@"%@ %@",_model.likes_total,ZFLocalizedString(@"FriendsResultCell_BeLiked",nil)];
    } else {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"FriendsResultCell_Posts",nil),_model.review_total];
        self.beLikesLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"FriendsResultCell_BeLiked",nil),_model.likes_total];
    }
    self.followButton.hidden = _model.isFollow;
    
    [_model.postlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            CGFloat width = (SCREEN_WIDTH - 47)/4;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            NSString *img = [[_model.postlist objectAtIndex:idx] valueForKey:@"pic"];
            [imageView yy_setImageWithURL:[NSURL URLWithString:img]
                             processorKey:NSStringFromClass([self class])
                              placeholder:[UIImage imageNamed:@"community_loading_default"]
                                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 }
                                transform:^UIImage *(UIImage *image, NSURL *url) {
                                    return image;
                                }
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                   if (from == YYWebImageFromDiskCache) {
                                   }
                               }];
            [self.showImagesContentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.showImagesContentView.mas_centerY);
                make.width.height.mas_equalTo(width);
                make.centerX.mas_equalTo(self.showImagesContentView.mas_leading).offset(width / 2 + (width + 5) * idx + 16);
            }];
        }
    }];
    
}

#pragma mark - getter
- (UIImageView *)userHeadImageView {
    if (!_userHeadImageView) {
        _userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userHeadImageView.contentMode = UIViewContentModeScaleToFill;
        _userHeadImageView.clipsToBounds = YES;
    }
    return _userHeadImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _nameLabel;
}

- (UILabel *)postsLabel {
    if (!_postsLabel) {
        _postsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postsLabel.font = [UIFont systemFontOfSize:12];
        _postsLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
    }
    return _postsLabel;
}

- (UILabel *)beLikesLabel {
    if (!_beLikesLabel) {
        _beLikesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _beLikesLabel.font = [UIFont systemFontOfSize:12];
        _beLikesLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
    }
    return _beLikesLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.layer.borderWidth = 1;
        _followButton.layer.cornerRadius = 2;
        _followButton.layer.masksToBounds = YES;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _followButton.layer.borderColor = ZFCOLOR(255, 168, 0, 1).CGColor;
        [_followButton setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_followButton setTitle:[NSString stringWithFormat:@"%@ ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        } else {
            [_followButton setTitle:[NSString stringWithFormat:@" %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }

    }
    return _followButton;
}

- (UIView *)showImagesContentView {
    if (!_showImagesContentView) {
        _showImagesContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _showImagesContentView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _showImagesContentView;
}
@end
