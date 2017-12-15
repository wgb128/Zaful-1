//
//  StyleHeaderView.m
//  Yoshop
//
//  Created by zhaowei on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleHeaderView.h"
#import "UserInfoModel.h"

@interface StyleHeaderView ()
@property (nonatomic, strong) YYAnimatedImageView *bgImageView; // 大背景
@property (nonatomic, strong) YYAnimatedImageView *headImageView; // 图片
@property (nonatomic, strong) UIButton *followingBtn;
@property (nonatomic, strong) UIButton *followersBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) UIButton *beLikedBtn;
@end

@implementation StyleHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ZFCOLOR(255, 168, 0, 1);
        
        _bgImageView = [YYAnimatedImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.image = [UIImage imageNamed:@"styleHeaderbg"];
        _bgImageView.clipsToBounds = YES;
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make){
             make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        _headImageView = [YYAnimatedImageView new];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.contentMode = UIViewContentModeScaleToFill;
        _headImageView.image = [UIImage imageNamed:@"account_empty"];
        _headImageView.clipsToBounds = YES;
        _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImageView.layer.borderWidth = 3*DSCREEN_WIDTH_SCALE;
        _headImageView.layer.cornerRadius = 27;
        _headImageView.layer.masksToBounds = YES;
        
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.leading.mas_equalTo(36);
            make.top.mas_equalTo(self.mas_top).offset(16);
            make.size.mas_equalTo(54);
        }];
        
        _nameLabel = [UILabel new];
        _nameLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_headImageView.mas_centerY);
            make.leading.mas_equalTo(_headImageView.mas_trailing).offset(12);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-120);
        }];
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor = [UIColor whiteColor];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followBtn setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        _followBtn.adjustsImageWhenHighlighted = NO;
        _followBtn.layer.cornerRadius = 2;
        _followBtn.layer.masksToBounds = YES;
        _followBtn.layer.borderColor = ZFCOLOR(221, 221, 221, 1).CGColor;
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_followBtn setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
        } else {
            [_followBtn setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
        }
        _followBtn.layer.borderWidth = MIN_PIXEL;
        [_followBtn addTarget:self action:@selector(followBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_followBtn];
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-10);
            make.centerY.mas_equalTo(_headImageView.mas_centerY);
            make.width.mas_equalTo(108);
            make.height.mas_equalTo(26);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            make.leading.trailing.mas_equalTo(0);
        }];
        
        _followingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followingBtn.backgroundColor = [UIColor clearColor];
        _followingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _followingBtn.titleLabel.numberOfLines = 0;
        [_followingBtn addTarget:self action:@selector(followingBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _followingBtn.enabled = NO;

        [bgView addSubview:_followingBtn];
//        [_followingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_headImageView.mas_centerY);
//            make.trailing.mas_equalTo(_headImageView.mas_leading).offset(-22);
//        }];
        
        
        _followersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followersBtn.backgroundColor = [UIColor clearColor];
        _followersBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _followersBtn.titleLabel.numberOfLines = 0;
        [_followersBtn addTarget:self action:@selector(followersBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _followersBtn.enabled = NO;
        
        [bgView addSubview:_followersBtn];
        
//        [_followersBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(_headImageView.mas_centerY);
//            make.leading.mas_equalTo(_headImageView.mas_trailing).offset(22);
//        }];
        
        _beLikedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _beLikedBtn.backgroundColor = [UIColor clearColor];
        _beLikedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _beLikedBtn.titleLabel.numberOfLines = 0;
        [_beLikedBtn addTarget:self action:@selector(beLikedBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _beLikedBtn.enabled = NO;
        
        [bgView addSubview:_beLikedBtn];
        
        NSArray *btnArr = @[_followingBtn,_followersBtn,_beLikedBtn];
        [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
    }
    return self;
}

- (void)followBtnAction
{
    if (!self.userInfoModel.userId) return;
    if (_followTouchBlock) {
        _followTouchBlock(self.userInfoModel);
    }
}

- (void)beLikedBtnAction
{
    if (_beLikedTouchBlock) {
        _beLikedTouchBlock(self.userInfoModel);
    }
}

- (void)followingBtnAction
{
    if (_followingTouchBlock) {
        _followingTouchBlock(self.userInfoModel);
    }
}

- (void)followersBtnAction
{
    if (_followersTouchBlock) {
        _followersTouchBlock(self.userInfoModel);
    }
}

- (void)setUserInfoModel:(UserInfoModel *)userInfoModel {
    
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:userInfoModel.avatar]
                               processorKey:NSStringFromClass([self class])
                                  placeholder:[[UIImage imageNamed:@"account_empty"]yy_imageByRoundCornerRadius:27 borderWidth:2 borderColor:[UIColor whiteColor]]
                                      options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     }
                                    transform:^UIImage *(UIImage *image, NSURL *url) {
                                        image = [image yy_imageByResizeToSize:CGSizeMake(54, 54) contentMode:UIViewContentModeScaleToFill];
//
//                                        return [image yy_imageByRoundCornerRadius:35 borderWidth:2 borderColor:[UIColor whiteColor]];
                                        return image;
                                        
                                    }
                                   completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                       if (from == YYWebImageFromDiskCache) {
                                           ZFLog(@"load from disk cache");
                                           
                                       }
                                   }];
    
    _userInfoModel = userInfoModel;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        NSString *following = [NSString stringWithFormat:@"%@ %ld",ZFLocalizedString(@"StyleHeaderView_Following",nil),(long)userInfoModel.followingCount];
        
        NSMutableAttributedString *followingAttrStr = [[NSMutableAttributedString alloc] initWithString:following];
        NSRange followingRange = [following rangeOfString:ZFLocalizedString(@"StyleHeaderView_Following",nil)];
        [followingAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:followingRange];
        [followingAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(followingRange.length, [following length] - followingRange.length)];
        
        
        [_followingBtn setAttributedTitle:followingAttrStr forState:UIControlStateNormal];
        
        NSString *followers = [NSString stringWithFormat:@"%@ %ld",ZFLocalizedString(@"StyleHeaderView_Followers",nil),(long)userInfoModel.followersCount];
        
        NSMutableAttributedString *followersAttrStr = [[NSMutableAttributedString alloc] initWithString:followers];
        NSRange followersRange = [followers rangeOfString:ZFLocalizedString(@"StyleHeaderView_Followers",nil)];
        [followersAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:followersRange];
        [followersAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(followersRange.length, [followers length] - followersRange.length)];
        [_followersBtn setAttributedTitle:followersAttrStr forState:UIControlStateNormal];
        
        NSString *beLiked = [NSString stringWithFormat:@"%@ %ld",ZFLocalizedString(@"StyleHeaderView_BeLiked",nil),(long)userInfoModel.likeCount];
        
        NSMutableAttributedString *beLikedAttrStr = [[NSMutableAttributedString alloc] initWithString:beLiked];
        NSRange beLikedRange = [beLiked rangeOfString:ZFLocalizedString(@"StyleHeaderView_BeLiked",nil)];
        [beLikedAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                         NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:beLikedRange];
        [beLikedAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                         NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(beLikedRange.length, [beLiked length] - beLikedRange.length)];
        [_beLikedBtn setAttributedTitle:beLikedAttrStr forState:UIControlStateNormal];
    } else {
        NSString *following = [NSString stringWithFormat:@"%ld %@",(long)userInfoModel.followingCount,ZFLocalizedString(@"StyleHeaderView_Following",nil)];
        
        NSMutableAttributedString *followingAttrStr = [[NSMutableAttributedString alloc] initWithString:following];
        NSRange followingRange = [following rangeOfString:ZFLocalizedString(@"StyleHeaderView_Following",nil)];
        [followingAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:followingRange];
        [followingAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(0, [following length] - followingRange.length)];
        
        
        [_followingBtn setAttributedTitle:followingAttrStr forState:UIControlStateNormal];
        
        NSString *followers = [NSString stringWithFormat:@"%ld %@",(long)userInfoModel.followersCount,ZFLocalizedString(@"StyleHeaderView_Followers",nil)];
        
        NSMutableAttributedString *followersAttrStr = [[NSMutableAttributedString alloc] initWithString:followers];
        NSRange followersRange = [followers rangeOfString:ZFLocalizedString(@"StyleHeaderView_Followers",nil)];
        [followersAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:followersRange];
        [followersAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                           NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(0, [followers length] - followersRange.length)];
        [_followersBtn setAttributedTitle:followersAttrStr forState:UIControlStateNormal];
        
        NSString *beLiked = [NSString stringWithFormat:@"%ld %@",(long)userInfoModel.likeCount,ZFLocalizedString(@"StyleHeaderView_BeLiked",nil)];
        
        NSMutableAttributedString *beLikedAttrStr = [[NSMutableAttributedString alloc] initWithString:beLiked];
        NSRange beLikedRange = [beLiked rangeOfString:ZFLocalizedString(@"StyleHeaderView_BeLiked",nil)];
        [beLikedAttrStr addAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize: 12],
                                         NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:beLikedRange];
        [beLikedAttrStr addAttributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                         NSForegroundColorAttributeName: ZFCOLOR(255, 255, 255, 1.0) } range:NSMakeRange(0, [beLiked length] - beLikedRange.length)];
        [_beLikedBtn setAttributedTitle:beLikedAttrStr forState:UIControlStateNormal];
    }
    
    
    _nameLabel.text = userInfoModel.nickName;
    _followingBtn.enabled = _followingBtn.titleLabel.attributedText ? YES : NO;
    _followersBtn.enabled = _followersBtn.titleLabel.attributedText ? YES : NO;
    _beLikedBtn.enabled   = _followersBtn.titleLabel.attributedText ? YES : NO;
    
    if ([userInfoModel.userId isEqualToString:USERID]) {
        _followBtn.hidden = YES;
    }else{
        _followBtn.hidden = NO;
        if (userInfoModel.isFollow) {
            if ([SystemConfigUtils isRightToLeftShow]) {
                [_followBtn setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"StyleHeaderView_Followed",nil)] forState:UIControlStateNormal];
            } else {
                [_followBtn setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"StyleHeaderView_Followed",nil)] forState:UIControlStateNormal];
            }
            [_followBtn setImage:[UIImage imageNamed:@"followed"] forState:UIControlStateNormal];
        }else{
            if ([SystemConfigUtils isRightToLeftShow]) {
                [_followBtn setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            } else {
                [_followBtn setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            }
            [_followBtn setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        }
    }
}

@end
