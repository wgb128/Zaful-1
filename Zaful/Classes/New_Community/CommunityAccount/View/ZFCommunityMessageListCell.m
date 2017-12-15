//
//  ZFCommunityMessageListCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMessageListCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityMessageModel.h"
#import "UIButton+GraphicBtn.h"
#import "UIView+GBGesture.h"

@interface ZFCommunityMessageListCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIImageView           *userHeadImageView;

@property (nonatomic, strong) YYLabel               *contentLabel;
@property (nonatomic, strong) YYLabel               *creatTimeLabel;
@property (nonatomic, strong) UIImageView           *photoImageView;
@property (nonatomic, strong) UIButton              *followButton;
@end

@implementation ZFCommunityMessageListCell
- (void)prepareForReuse {
    
}

#pragma mark - Life Cycle
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
    if (self.communityMessageListFollowUserCompletionHandler) {
        self.communityMessageListFollowUserCompletionHandler(self.model.user_id);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.userHeadImageView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.creatTimeLabel];
    [self.contentView addSubview:self.photoImageView];
    [self.contentView addSubview:self.followButton];
}

- (void)zfAutoLayoutView {
    [self.userHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(self.contentView).offset(16);
        make.width.height.mas_equalTo(51);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userHeadImageView.mas_trailing).offset(12);
        make.top.mas_equalTo(self.userHeadImageView);
    }];
    
    [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userHeadImageView.mas_trailing).offset(12);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(14);
    }];
    
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.trailing.mas_equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(51);
    }];
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.trailing.mas_equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(51);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunityMessageModel *)model {
    _model = model;
    [self.userHeadImageView yy_setImageWithURL:[NSURL URLWithString:_model.avatar]
                                processorKey:NSStringFromClass([self class])
                                 placeholder:[UIImage imageNamed:@"index_cat_loading"]
                                     options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                   transform:^UIImage *(UIImage *image, NSURL *url) {
                                       image = [image yy_imageByResizeToSize:CGSizeMake(51,51) contentMode:UIViewContentModeScaleToFill];
                                       return [image yy_imageByRoundCornerRadius:25.5];
                                   }
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                  }];
    
    //回复时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM.dd,yyyy  HH:mm:ss"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_model.add_time integerValue]]];
    NSMutableString* newStr= [[NSMutableString alloc]initWithString:currentDateStr];
    [newStr insertString:@"at"atIndex:12];
    self.creatTimeLabel.text = newStr;
    
    
    if (_model.nickname.length > 0) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",_model.nickname,_model.content]];
        text.yy_font = [UIFont boldSystemFontOfSize:14.0f];
        text.yy_color = ZFCOLOR(170, 170, 170, 1);
        [text yy_setColor:ZFCOLOR(51, 51, 51, 1) range:NSMakeRange(0, _model.nickname.length)];
        [text yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, _model.nickname.length)];
        [text yy_setTextHighlightRange:NSMakeRange(0, _model.nickname.length)//设置点击的位置
                                 color:ZFCOLOR(51, 51, 51, 1)
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             }];
        self.contentLabel.attributedText = text;
    }else{
        self.contentLabel.text = _model.content;
    }
    
    
    //     1.关注   2.评论   3.点赞   4.置顶
    switch (_model.message_type) {
        case MessageListFollowTag:
        {
            self.photoImageView.hidden = YES;
            if (_model.isFollow) {
                self.followButton.hidden = YES;
            }else{
                self.followButton.hidden = NO;
            }
            
        }
            break;
        case MessageListLikeTag:
        case MessageListCommendTag:
        case MessageListGainedPoints:
        {
            self.followButton.hidden = YES;
            self.photoImageView.hidden = NO;
            [self.photoImageView yy_setImageWithURL:[NSURL URLWithString:_model.pic_src]
                                         processorKey:NSStringFromClass([self class])
                                          placeholder:[UIImage imageNamed:@"index_cat_loading"]
                                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                             progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                                //                                           image = [image yy_imageByResizeToSize:CGSizeMake(51,51) contentMode:UIViewContentModeScaleAspectFill];
                                                return image;
                                            }
                                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                           }];
            
            
        }
            break;
        default:
            break;
    }

}

#pragma mark - getter
- (UIImageView *)userHeadImageView {
    if (!_userHeadImageView) {
        _userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userHeadImageView.contentMode = UIViewContentModeScaleToFill;
        _userHeadImageView.userInteractionEnabled = YES;
        _userHeadImageView.clipsToBounds = YES;
        @weakify(self);
        [_userHeadImageView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.communityMessageAccountDetailCompletioinHandler) {
                self.communityMessageAccountDetailCompletioinHandler(self.model.user_id);
            }
        }];
    }
    return _userHeadImageView;
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:16];
        _contentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _contentLabel.numberOfLines = 2;
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.linePositionModifier = modifier;
        _contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 75-80;

    }
    return _contentLabel;
}

- (YYLabel *)creatTimeLabel {
    if (!_creatTimeLabel) {
        YYTextLinePositionSimpleModifier *modifiers = [YYTextLinePositionSimpleModifier new];
        modifiers.fixedLineHeight = 14;//行高
        
        _creatTimeLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _creatTimeLabel.textAlignment = NSTextAlignmentLeft;
        _creatTimeLabel.font = [UIFont systemFontOfSize:12];
        _creatTimeLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        _creatTimeLabel.linePositionModifier = modifiers;
    }
    return _creatTimeLabel;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.hidden = YES;

    }
    return _photoImageView;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followButton initWithTitle:ZFLocalizedString(@"Community_Follow",nil) andImageName:@"message_follow" andTopHeight:5 andTextColor:ZFCOLOR(255, 168, 0, 1)];
        _followButton.hidden = YES;
        [_followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _followButton;
}

@end
