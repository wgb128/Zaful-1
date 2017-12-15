//
//  CommentsCell.m
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "CommentsCell.h"
#import "CommunityDetailReviewsListMode.h"
#import "YYText.h"

@interface CommentsCell ()

@property (nonatomic, strong) YYAnimatedImageView *avatar;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *comments;

@end

@implementation CommentsCell

+ (CommentsCell *)commentsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[CommentsCell class] forCellReuseIdentifier:VIDEO_COMMENTS_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:VIDEO_COMMENTS_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setReviesModel:(CommunityDetailReviewsListMode *)reviesModel {
    _reviesModel = reviesModel;
    
    //头像
    [_avatar yy_setImageWithURL:[NSURL URLWithString:reviesModel.avatar]
                  processorKey:NSStringFromClass([self class])
                  placeholder:[UIImage imageNamed:@"account"]
                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                  progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                  transform:^UIImage *(UIImage *image, NSURL *url) {
                      return image;
                  }
                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                  }];
    //昵称
    self.nickName.text = reviesModel.nickname;
    
    //评论内容
    if (![NSStringUtils isEmptyString:reviesModel.isSecondFloorReply]) {
        if ([reviesModel.isSecondFloorReply isEqualToString:@"1"]) {
            NSMutableAttributedString *mutableAttribuedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Re %@ : %@",reviesModel.replyNickName,reviesModel.content]];
            NSRange range = NSMakeRange(0, reviesModel.replyNickName.length + 5);
            [mutableAttribuedString addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(51, 51, 51, 1.0) range:range];
            [mutableAttribuedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:range];
            _comments.attributedText = mutableAttribuedString;
        }else {
            _comments.text = reviesModel.content;
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        __weak typeof(self.contentView) ws = self.contentView;
        
        _avatar = [YYAnimatedImageView new];
        _avatar.contentMode = UIViewContentModeScaleToFill;
        _avatar.clipsToBounds = YES;
        _avatar.userInteractionEnabled = YES;
        _avatar.layer.cornerRadius = 20.0;
        [ws addSubview:_avatar];
        
        [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_top).mas_offset(10);
            make.leading.mas_equalTo(ws.mas_leading).mas_offset(10);
            make.width.height.mas_equalTo(40);
        }];
        
        _nickName = [UILabel new];
        _nickName.font = [UIFont systemFontOfSize:16];
        _nickName.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [ws addSubview:_nickName];
        
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_avatar.mas_trailing).mas_offset(8);
            make.centerY.mas_equalTo(_avatar.mas_centerY);
        }];

        _comments = [UILabel new];
        _comments.userInteractionEnabled = YES;
        _comments.numberOfLines = 0;
        _comments.font = [UIFont systemFontOfSize:12];
        _comments.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [ws addSubview:_comments];
        
        [_comments mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_nickName.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing).mas_offset(-10);
            make.top.mas_equalTo(_nickName.mas_bottom).mas_offset(15);
            make.bottom.mas_equalTo(ws.mas_bottom).mas_offset(-10);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [ws addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.bottom.trailing.mas_equalTo(ws);
            make.leading.mas_equalTo(_nickName.mas_leading);
        }];
        
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatar:)];
        [_avatar addGestureRecognizer:tapAvatar];

        UITapGestureRecognizer *tapComments = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapComments:)];
        [_comments addGestureRecognizer:tapComments];

    }
    return self;
}

- (void)tapAvatar:(UITapGestureRecognizer*)sender {
    if (self.jumpBlock) {
        self.jumpBlock(self.reviesModel.userId);
    }
}

- (void)tapComments:(UITapGestureRecognizer*)sender {
    if (self.replyBlock) {
        self.replyBlock();
    }
}

@end
