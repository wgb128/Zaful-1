

//
//  ZFCommunityFollowingCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityFollowingCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityFollowModel.h"

@interface ZFCommunityFollowingCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView           *avatorImageView;
@property (nonatomic, strong) UILabel               *nameLabel;
@property (nonatomic, strong) UIButton              *followButton;
@end

@implementation ZFCommunityFollowingCell
- (void)prepareForReuse {
    self.avatorImageView.image = nil;
    self.nameLabel.text = nil;
}

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
    if (self.communityFollowUserCompletionHandler) {
        self.communityFollowUserCompletionHandler(self.model);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.followButton];
}

- (void)zfAutoLayoutView {
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(39, 39));
    }];
    
    self.avatorImageView.layer.cornerRadius = 39.0 / 2;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatorImageView.mas_trailing).offset(8);
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
        make.size.mas_equalTo(CGSizeMake(80, 26));
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunityFollowModel *)model {
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
    self.nameLabel.text = _model.nikename;
    self.followButton.hidden = _model.isFollow;
}

#pragma mark - getter
- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatorImageView.contentMode = UIViewContentModeScaleToFill;
        _avatorImageView.userInteractionEnabled = YES;
        _avatorImageView.clipsToBounds = YES;

    }
    return _avatorImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _nameLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _followButton.titleLabel.textColor = ZFCOLOR(255, 168, 0, 1);
        _followButton.layer.cornerRadius = 2;
        _followButton.layer.masksToBounds = YES;
        _followButton.layer.borderWidth = MIN_PIXEL;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _followButton.layer.borderColor = ZFCOLOR(255, 168, 0, 1).CGColor;
        [_followButton setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        [_followButton setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_followButton setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        } else {
            [_followButton setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            _followButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            _followButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }
    }
    return _followButton;
}
@end
