
//
//  ZFCommunityAccountShowCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountShowCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityAccountShowsModel.h"
#import "UIView+GBGesture.h"
#import "BigClickAreaButton.h"

@interface ZFCommunityAccountShowCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView               *iconImageView;
@property (nonatomic, strong) UILabel                   *nameLabel;
@property (nonatomic, strong) UILabel                   *timeLabel;
@property (nonatomic, strong) BigClickAreaButton        *deleteButton;
@property (nonatomic, strong) YYLabel                   *contentLabel;
@property (nonatomic, strong) CommunityImageLayoutView  *contentImageView;
@property (nonatomic, strong) BigClickAreaButton        *likeButton;
@property (nonatomic, strong) UILabel                   *likeNumberLabel;
@property (nonatomic, strong) BigClickAreaButton        *reviewButton;
@property (nonatomic, strong) UILabel                   *reviewNumberLabel;
@property (nonatomic, strong) BigClickAreaButton        *shareButton;

@end

@implementation ZFCommunityAccountShowCell
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
- (void)deleteButtonAction:(UIButton *)sender {
    if (self.communityAccountShowsDeleteCompletionHandler) {
        self.communityAccountShowsDeleteCompletionHandler(self.model);
    }
}

- (void)shareButtonAction:(UIButton *)sender {
    if (self.communityAccountShowsShareCompletionHandler) {
        self.communityAccountShowsShareCompletionHandler(self.model);
    }
}

- (void)likeButtonAction:(UIButton *)sender {
    if (self.communityAccountShowsLikeCompletionHandler) {
        self.communityAccountShowsLikeCompletionHandler(self.model);
    }
}

- (void)reviewButtonAction:(UIButton *)sender {
    if (self.communityAccountShowsReviewCompletionHandler) {
        self.communityAccountShowsReviewCompletionHandler();
    }
}

#pragma mark - private methods
- (NSString*)timer:(NSString*)timer {
    NSInteger intervalTime = [timer integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMM dd, yyyy";
    NSString *time = [df stringFromDate:date];
    return time;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.contentImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.shareButton];
    [self.contentView addSubview:self.reviewButton];
    [self.contentView addSubview:self.reviewNumberLabel];
    [self.contentView addSubview:self.likeButton];
    [self.contentView addSubview:self.likeNumberLabel];

}

- (void)zfAutoLayoutView {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.leading.mas_equalTo(self.iconImageView.mas_trailing).offset(16);
        make.height.mas_equalTo(16);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
    }];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(16);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_bottom).offset(8);
        make.leading.trailing.mas_equalTo(self.contentImageView);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_leading).offset(SCREEN_WIDTH / 6.0);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(28);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        make.width.mas_equalTo(100);
    }];
    
    [self.reviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_leading).offset(SCREEN_WIDTH / 2.0);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(28);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        make.width.mas_equalTo(100);
    }];
    
    [self.reviewNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.reviewButton.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_leading).offset(SCREEN_WIDTH / 2.0+30);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_leading).offset(SCREEN_WIDTH / 6.0 * 5.0);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(28);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-12);
        make.width.mas_equalTo(100);
    }];
    
    [self.likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.likeButton.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_leading).offset(SCREEN_WIDTH / 6.0 * 5.0+30);
    }];

}

#pragma mark - setter 
- (void)setModel:(ZFCommunityAccountShowsModel *)model {
    _model = model;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:_model.avatar]
                        processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"account"]
                             options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           transform:^UIImage *(UIImage *image, NSURL *url) {
                               image = [image yy_imageByResizeToSize:CGSizeMake(39,39) contentMode:UIViewContentModeScaleToFill];
                               return [image yy_imageByRoundCornerRadius:18.5];
                           }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                              if (from == YYWebImageFromDiskCache) {
                              }
                          }];
    //昵称
    self.nameLabel.text = _model.nickName;
    NSInteger intervalTime = [_model.addTime integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMM dd, yyyy";
    NSString *time = [df stringFromDate:date];
    self.timeLabel.text = time;
    
    //评论内容
    NSMutableString *contentStr = [NSMutableString string];
    if (_model.topicList.count>0) {
        for (NSString *str in _model.topicList) {
            [contentStr appendString:[NSString stringWithFormat:@"%@ ", str]];
        }
    }
    [contentStr appendString:_model.content];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:contentStr];
    content.yy_font = [UIFont systemFontOfSize:14];
    content.yy_color = ZFCOLOR(102, 102, 102, 1.0);
    
    NSArray *cmps = [contentStr componentsMatchedByRegex:RegularExpression];
    
    [cmps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [contentStr rangeOfString:cmps[idx]];
        [content yy_setColor:ZFCOLOR(255, 168, 0, 1.0) range:range];
        [content yy_setTextHighlightRange:range color:ZFCOLOR(255, 168, 0, 1.0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSString *labName = cmps[idx];
            if (self.communityAccountShowsTopicCompletionHandler) {
                self.communityAccountShowsTopicCompletionHandler(labName);
            }
        }];
    }];
    
    if ([USERID isEqualToString: _model.userId])
    {
        self.deleteButton.hidden = NO;
    }else
    {
        self.deleteButton.hidden = YES;
    }
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        // NSParagraphStyle
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentRight;
        [content addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    }
    //评论内容
    self.contentLabel.attributedText = content;

    self.contentImageView.imagePaths = [_model.reviewPic valueForKeyPath:@"bigPic"];
    
    //用户是否点赞
    self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)[_model.likeCount integerValue]];
    if (_model.isLiked) {
        self.likeButton.selected = YES;
        self.likeNumberLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }else {
        self.likeButton.selected = NO;
        if ([_model.likeCount isEqualToString:@"0"]) {
            self.likeNumberLabel.text = nil;
        }else {
            self.likeNumberLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
    //回复数
    if ([_model.replyCount isEqualToString:@"0"]) {
        self.reviewNumberLabel.text = nil;
    }else {
        self.reviewNumberLabel.text = _model.replyCount;
    }

}


#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_iconImageView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.communityAccountShowsUserAccountCompletionHandler) {
                self.communityAccountShowsUserAccountCompletionHandler(self.model.userId);
            }
        }];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
    }
    return _timeLabel;
}

- (BigClickAreaButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.clickAreaRadious = 60;
        [_deleteButton setImage:[UIImage imageNamed:@"community_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        _contentLabel = [YYLabel new];
        _contentLabel.numberOfLines = 5;
        _contentLabel.linePositionModifier = modifier;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            _contentLabel.textAlignment = NSTextAlignmentRight;
        }
        
    }
    return _contentLabel;
}

- (CommunityImageLayoutView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[CommunityImageLayoutView alloc] initWithFrame:CGRectZero];
    }
    return _contentImageView;
}

- (BigClickAreaButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _likeButton.clickAreaRadious = 44;
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
        _likeNumberLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }
    return _likeNumberLabel;
}

- (BigClickAreaButton *)reviewButton {
    if (!_reviewButton) {
        _reviewButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _reviewButton.clickAreaRadious = 44;
        [_reviewButton addTarget:self action:@selector(reviewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reviewButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        
    }
    return _reviewButton;
}

- (UILabel *)reviewNumberLabel {
    if (!_reviewNumberLabel) {
        _reviewNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reviewNumberLabel.font = [UIFont systemFontOfSize:12];
        _reviewNumberLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }
    return _reviewNumberLabel;
}

- (BigClickAreaButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _shareButton.clickAreaRadious = 44;
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    }
    return _shareButton;
}


@end
