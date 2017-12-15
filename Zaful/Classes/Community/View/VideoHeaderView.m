//
//  VideoHeaderView.m
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoHeaderView.h"
#import "VideoDetailInfoModel.h"
#import "UILabel+StringFrame.h"
#import "YTPlayerView.h"
#import "YYText.h"

@interface VideoHeaderView ()

@property (nonatomic, strong) YTPlayerView  *playerVideo;

@property (nonatomic, strong) YYLabel *descLabel;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UILabel *likeNum;

@property (nonatomic, strong) UILabel *watchNum;

@property (nonatomic, strong) MASConstraint *height;//文本高度

@end

@implementation VideoHeaderView

- (void)setInfoModel:(VideoDetailInfoModel *)infoModel {
    _infoModel = infoModel;
    
    if (infoModel.videoUrl) {
        [_playerVideo loadWithVideoId:infoModel.videoUrl];
    }
    
    if (![NSStringUtils isBlankString:infoModel.videoDescription]) {
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:infoModel.videoDescription];
        content.yy_font = [UIFont systemFontOfSize:14];
        content.yy_color = ZFCOLOR(153, 153, 153, 1.0);
        if ([SystemConfigUtils isRightToLeftShow]) {
            // NSParagraphStyle
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.alignment = NSTextAlignmentRight;
            [content addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
        }
        _descLabel.attributedText = content;
    }
    

    if ([SystemConfigUtils isRightToLeftShow]) {
        _watchNum.text = [NSString stringWithFormat:@"%@ %ld",ZFLocalizedString(@"Community_Little_Views",nil),(long)infoModel.viewNum];
    } else {
        _watchNum.text = [NSString stringWithFormat:@"%ld %@",(long)infoModel.viewNum,ZFLocalizedString(@"Community_Little_Views",nil)];
    }
    if (self.refreshHeadViewBlock) {
        self.refreshHeadViewBlock();
    }
    
    //点赞
    _likeNum.text = infoModel.likeNum;
    if (infoModel.isLike) {
        _likeBtn.selected = YES;
        _likeNum.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }else {
        self.likeBtn.selected = NO;
        if ([infoModel.likeNum isEqualToString:@"0"]) {
            _likeNum.text = nil;
        }else {
            _likeNum.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
}

/*
 *
 *  这个地方的点赞处理有点恶心 因为防止每次会刷新到视频导致视频闪动 所以将点赞单纯抽出来处理了
 *
 */
- (void)setLikeModel:(VideoDetailInfoModel *)likeModel {
    _likeModel = likeModel;
    //点赞
    _likeNum.text = likeModel.likeNum;
    if (likeModel.isLike) {
        _likeBtn.selected = YES;
        _likeNum.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }else {
        self.likeBtn.selected = NO;
        if ([likeModel.likeNum isEqualToString:@"0"]) {
            _likeNum.text = nil;
        }else {
            _likeNum.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        _playerVideo = [YTPlayerView new];
        [_playerVideo duration];
        [backView addSubview:_playerVideo];
        
        [_playerVideo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.mas_equalTo(backView);
            make.height.mas_equalTo(210 * DSCREEN_WIDTH_SCALE);
        }];

        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 17;//行高

        _descLabel = [YYLabel new];
        _descLabel.numberOfLines = 0;
        _descLabel.linePositionModifier = modifier;
        _descLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;//自动设置高度
        _descLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        _descLabel.backgroundColor = ZFCOLOR_WHITE;
        [backView addSubview:_descLabel];
        
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(backView);
            make.top.mas_equalTo(_playerVideo.mas_bottom).mas_offset(5);
        }];
        
        UIView *buttonView = [UIView new];
        buttonView.backgroundColor = ZFCOLOR_WHITE;
        [backView addSubview:buttonView];
        
        [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(backView);
            make.top.mas_equalTo(_descLabel.mas_bottom);
            make.height.mas_equalTo(40);
        }];
        
        YYAnimatedImageView *eyeImg = [YYAnimatedImageView new];
        eyeImg.image = [UIImage imageNamed:@"views"];
        [buttonView addSubview:eyeImg];
        
        [eyeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(buttonView.mas_centerY);
            make.leading.mas_equalTo(buttonView.mas_leading).mas_offset(10);
        }];
        
        _watchNum = [UILabel new];
        _watchNum.font = [UIFont systemFontOfSize:12];
        _watchNum.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [buttonView addSubview:_watchNum];
        
        [_watchNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(buttonView.mas_centerY);
            make.leading.mas_equalTo(eyeImg.mas_trailing).mas_offset(3);
        }];
        
        _likeBtn = [UIButton new];
        [_likeBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateSelected];
        [buttonView addSubview:_likeBtn];
        
        [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(buttonView.mas_centerY);
            make.trailing.mas_equalTo(buttonView.mas_trailing).mas_offset(-10);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
        
        _likeNum = [UILabel new];
        _likeNum.font = [UIFont systemFontOfSize:12];
        _likeNum.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [buttonView addSubview:_likeNum];
        
        [_likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(buttonView.mas_centerY).mas_offset(3);
            make.trailing.mas_equalTo(_likeBtn.mas_leading).mas_offset(-5);
        }];
        
        UIView *line2 = [UIView new];
        line2.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [self addSubview:line2];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(10);
            make.leading.trailing.mas_equalTo(self);
            make.top.mas_equalTo(buttonView.mas_bottom);
            make.bottom.mas_equalTo(backView.mas_bottom);
        }];
    }
    return self;
}

- (void)clickEvent:(UIButton*)sender {
    [_likeBtn.layer addAnimation:[self createFavouriteAnimation] forKey:@"Liked"];
    if (self.likeBlock) {
        self.likeBlock();
    }
}

#pragma mark - Button放大缩小的动画效果
- (CAKeyframeAnimation *)createFavouriteAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

@end
