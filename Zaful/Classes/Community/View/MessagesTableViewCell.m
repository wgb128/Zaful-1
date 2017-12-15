//
//  MessagesTableViewCell.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MessagesTableViewCell.h"
#import "YYText.h"
#import "UIButton+GraphicBtn.h"

@interface MessagesTableViewCell ()
@property (nonatomic, strong) YYAnimatedImageView *avatarImageView;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) YYLabel *dateLabel;
@property (nonatomic, strong) UIButton *followBtn;
@property (nonatomic, strong) YYAnimatedImageView *contentImageView;
@property (nonatomic, strong) NSString *userId;
@end

@implementation MessagesTableViewCell

+ (MessagesTableViewCell *)messagesTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[MessagesTableViewCell class] forCellReuseIdentifier:MESSAGES_LIST_CELL_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:MESSAGES_LIST_CELL_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        __weak typeof(self.contentView) ws = self.contentView;
        YYAnimatedImageView *avatarImageView = [YYAnimatedImageView new];
        avatarImageView.contentMode = UIViewContentModeScaleToFill;
        avatarImageView.userInteractionEnabled = YES;
        avatarImageView.clipsToBounds = YES;
        [ws addSubview:avatarImageView];
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(ws).offset(16);
            make.width.height.mas_equalTo(51);
        }];
        self.avatarImageView = avatarImageView;
        
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarBtn:)];
        [self.avatarImageView addGestureRecognizer:tapAvatar];
        
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        
        YYLabel *contentLabel = [YYLabel new];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont boldSystemFontOfSize:16];
        contentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        contentLabel.numberOfLines = 2;
        contentLabel.userInteractionEnabled = YES;
        contentLabel.linePositionModifier = modifier;
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 75-80;
        [ws addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(avatarImageView.mas_trailing).offset(12);
            make.top.mas_equalTo(avatarImageView);
           // make.trailing.mas_equalTo(ws).offset(-75);
        }];
        self.contentLabel = contentLabel;
        
        YYTextLinePositionSimpleModifier *modifiers = [YYTextLinePositionSimpleModifier new];
        modifiers.fixedLineHeight = 14;//行高
        
        YYLabel *dateLabel = [YYLabel new];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        dateLabel.linePositionModifier = modifiers;
        [ws addSubview:dateLabel];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(avatarImageView.mas_trailing).offset(12);
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(14);
        }];
        self.dateLabel = dateLabel;
        
        YYAnimatedImageView *contentImageView = [YYAnimatedImageView new];
        contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        contentImageView.clipsToBounds = YES;
        contentImageView.hidden = YES;
        [ws addSubview:contentImageView];
        
        [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws).offset(16);
            make.trailing.mas_equalTo(ws).offset(-16);
            make.width.height.mas_equalTo(51);
        }];
        self.contentImageView = contentImageView;
        
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.tag = followBtnTag;
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [followBtn initWithTitle:ZFLocalizedString(@"Community_Follow",nil) andImageName:@"message_follow" andTopHeight:5 andTextColor:ZFCOLOR(255, 168, 0, 1)];
        followBtn.hidden = YES;
        [followBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ws addSubview:followBtn];
        
        [followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws).offset(16);
            make.trailing.mas_equalTo(ws).offset(-16);
            make.width.height.mas_equalTo(51);
        }];
        self.followBtn = followBtn;
    }
    return self;
}

- (void) setListModel:(MessagesListModel *)listModel {
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:listModel.avatar]
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
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[listModel.add_time integerValue]]];
    NSMutableString* newStr= [[NSMutableString alloc]initWithString:currentDateStr];
    [newStr insertString:@"at"atIndex:12];
    self.dateLabel.text = newStr;
    
    
    if (listModel.nickname.length > 0) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",listModel.nickname,listModel.content]];
        text.yy_font = [UIFont boldSystemFontOfSize:14.0f];
        text.yy_color = ZFCOLOR(170, 170, 170, 1);
        [text yy_setColor:ZFCOLOR(51, 51, 51, 1) range:NSMakeRange(0, listModel.nickname.length)];
        [text yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, listModel.nickname.length)];
        [text yy_setTextHighlightRange:NSMakeRange(0, listModel.nickname.length)//设置点击的位置
                                 color:ZFCOLOR(51, 51, 51, 1)
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 if (self.messagetapListAvatarBlock) {
                                     self.messagetapListAvatarBlock();
                                 }
                             }];
        self.contentLabel.attributedText = text;
    }else{
        self.contentLabel.text = listModel.content;
    }
    
    
    //     1.关注   2.评论   3.点赞   4.置顶
    switch (listModel.message_type) {
        case MessageListFollowTag:
        {
            self.contentImageView.hidden = YES;
            if (listModel.isFollow) {
                self.followBtn.hidden = YES;
            }else{
                self.followBtn.hidden = NO;
            }
            
        }
            break;
        case MessageListLikeTag:
        case MessageListCommendTag:
        case MessageListGainedPoints:
        {
            self.followBtn.hidden = YES;
            self.contentImageView.hidden = NO;
            [self.contentImageView yy_setImageWithURL:[NSURL URLWithString:listModel.pic_src]
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

#pragma mark - 跳转 My Style ViewController
- (void)tapAvatarBtn:(UITapGestureRecognizer*)sender {
    if (self.messagetapListAvatarBlock) {
        self.messagetapListAvatarBlock();
    }
}

- (void)clickEvent:(UIButton*)sender {
    if (self.clickEventBlock) {
        self.clickEventBlock();
    }
}

@end
