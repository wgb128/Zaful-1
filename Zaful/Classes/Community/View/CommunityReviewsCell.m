//
//  CommunityReviewsCell.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityReviewsCell.h"
#import "CommunityDetailReviewsListMode.h"

@interface CommunityReviewsCell ()

@property (nonatomic,weak) YYAnimatedImageView *iconImg;//头像
@property (nonatomic,weak) UILabel *nameLabel;//昵称
@property (nonatomic,weak) UILabel *contentLabel;//评论内容

@property (nonatomic,weak) UILabel *replyLabel;//回复
@property (nonatomic,weak) UILabel *replyContentLabel;//回复评论内容

@end

@implementation CommunityReviewsCell

+ (CommunityReviewsCell *)communityDetailCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[CommunityReviewsCell class] forCellReuseIdentifier:COMMUNITY_REVIEWS_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:COMMUNITY_REVIEWS_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setReviesModel:(CommunityDetailReviewsListMode *)reviesModel {
    _reviesModel = reviesModel;
    
    //头像
    [self.iconImg yy_setImageWithURL:[NSURL URLWithString:reviesModel.avatar]
                          processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"account"]
                          options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                          transform:^UIImage *(UIImage *image, NSURL *url) {
                              image = [image yy_imageByResizeToSize:CGSizeMake(40,40) contentMode:UIViewContentModeScaleToFill];
                              return [image yy_imageByRoundCornerRadius:20];
                          }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                          }];
    
    //昵称
    self.nameLabel.text = reviesModel.nickname;
    
    //评论内容
    if (![NSStringUtils isEmptyString:reviesModel.isSecondFloorReply]) {
        if ([reviesModel.isSecondFloorReply isEqualToString:@"1"]) {
            self.contentLabel.text = nil;
            NSMutableAttributedString *mutableAttribuedString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Re %@ : %@",reviesModel.replyNickName,reviesModel.content]];
            NSRange range = NSMakeRange(0, reviesModel.replyNickName.length + 5);
            [mutableAttribuedString addAttribute:NSForegroundColorAttributeName value:ZFCOLOR(51, 51, 51, 1.0) range:range];
            [mutableAttribuedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:range];
            self.replyLabel.attributedText = mutableAttribuedString;
        }else {
            self.replyLabel.text = nil;
            self.contentLabel.text = reviesModel.content;
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        __weak typeof(self.contentView) ws = self.contentView;
        
        YYAnimatedImageView *iconImg = [YYAnimatedImageView new];
        iconImg.userInteractionEnabled = YES;
        iconImg.contentMode = UIViewContentModeScaleToFill;
        iconImg.userInteractionEnabled = YES;
        [ws addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_top).offset(12);
            make.leading.mas_equalTo(ws.mas_leading).offset(10);
            make.width.height.mas_equalTo(40);
        }];
        self.iconImg = iconImg;
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = [UIColor blackColor];
        [ws addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).offset(10);
            make.top.mas_equalTo(iconImg.mas_top);
        }];
        self.nameLabel = nameLabel;
        
        UILabel *contentLabel = [UILabel new];
        contentLabel.userInteractionEnabled = YES;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [ws addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(nameLabel.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-10);
            make.top.mas_equalTo(iconImg.mas_bottom).offset(-15);
        }];
        self.contentLabel = contentLabel;
        
        UILabel *replyLabel = [UILabel new];
        replyLabel.userInteractionEnabled = YES;
        replyLabel.numberOfLines = 0;
        replyLabel.font = [UIFont systemFontOfSize:12];
        replyLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [ws addSubview:replyLabel];
        
        [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).offset(10);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-10);
            make.top.mas_equalTo(contentLabel.mas_bottom);
            make.bottom.mas_equalTo(ws.mas_bottom).offset(-12);
        }];
        self.replyLabel = replyLabel;
        
        UITapGestureRecognizer *tapIconImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIconImg:)];
        [iconImg addGestureRecognizer:tapIconImg];
        
        UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent:)];
        [contentLabel addGestureRecognizer:tapContent];
        
        UITapGestureRecognizer *tapReply = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContent:)];
        [replyLabel addGestureRecognizer:tapReply];
    }
    return self;
}

- (void)tapContent:(UITapGestureRecognizer*)sender {
    if (self.replyBlock) {
        self.replyBlock();
    }
}

- (void)tapIconImg:(UITapGestureRecognizer*)sender {
    if (self.jumpMyStyleBlock) {
        self.jumpMyStyleBlock();
    }
}

@end
