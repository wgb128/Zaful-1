//
//  FavesCell.m
//  Zaful
//
//  Created by DBP on 17/1/18.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FavesCell.h"
#import "UILabel+StringFrame.h"
#import "FavesItemsModel.h"
#import "PictureModel.h"
#import "YYText.h"

@interface FavesCell ()
@property (nonatomic, weak) YYAnimatedImageView *iconImg;//头像
@property (nonatomic, weak) UILabel *nameLabel;//昵称
@property (nonatomic, weak) UILabel *timeLabel;//评论发布时间
@property (nonatomic, weak) UIButton *followBtn;//关注按钮
@property (nonatomic, weak) YYLabel *contentLabel;//评论内容
@property (nonatomic, weak) CommunityImageLayoutView *contentImgView;//评论图片容器

@property (nonatomic, weak) UIButton *likeBtn;//点赞按钮
@property (nonatomic, weak) UILabel *likeNumLabel;//点赞数
@property (nonatomic, weak) UIButton *reviewBtn;//评论按钮
@property (nonatomic, weak) UILabel *reviewNumLabel;//评论数
@property (nonatomic, weak) UIButton *shareBtn;//分享按钮

@end

@implementation FavesCell

+ (FavesCell *)favesCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[FavesCell class] forCellReuseIdentifier:FAVES_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:FAVES_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setItemsModel:(FavesItemsModel *)itemsModel {
    _itemsModel = itemsModel;
    //清除子视图防止二次创建
    [self.contentImgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [obj removeFromSuperview];
    }];
    //头像
    [self.iconImg yy_setImageWithURL:[NSURL URLWithString:itemsModel.avatar]
                        processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"index_cat_loading"]
                             options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                           transform:^UIImage *(UIImage *image, NSURL *url) {
                               image = [image yy_imageByResizeToSize:CGSizeMake(39,39) contentMode:UIViewContentModeScaleToFill];
                               return [image yy_imageByRoundCornerRadius:19.5];
                           }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                          }];
    //昵称
    self.nameLabel.text = itemsModel.nickname;
    //评论时间
    self.timeLabel.text = [self timer:itemsModel.addTime];
    
    if ([USERID isEqualToString: itemsModel.userId]) {
        self.followBtn.hidden = YES;
    }else {
        //        self.followBtn.hidden = NO;
        //是否关注
        if (itemsModel.isFollow) {
            self.followBtn.hidden = YES;
        }else{
            self.followBtn.hidden = NO;
        }
    }
    
    NSMutableString *contentStr = [NSMutableString string];
    if (itemsModel.topicList.count>0) {
        for (NSString *str in itemsModel.topicList) {
            [contentStr appendString:[NSString stringWithFormat:@"%@ ", str]];
        }
    }
    [contentStr appendString:itemsModel.content];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:contentStr];
    content.yy_font = [UIFont systemFontOfSize:14];
    content.yy_color = ZFCOLOR(102, 102, 102, 1.0);
    
    NSArray *cmps = [contentStr componentsMatchedByRegex:RegularExpression];
    
    [cmps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [contentStr rangeOfString:cmps[idx]];
        [content yy_setColor:ZFCOLOR(255, 168, 0, 1.0) range:range];
        [content yy_setTextHighlightRange:range color:ZFCOLOR(255, 168, 0, 1.0) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSString *labName = cmps[idx];
            if (self.topicDetailBlock) {
                self.topicDetailBlock(labName);
            }
        }];
    }];
    
    //评论内容
    self.contentLabel.attributedText = content;
    
    self.contentImgView.imagePaths = [itemsModel.reviewPic valueForKeyPath:@"bigPic"];
    
    //用户是否点赞
    self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[itemsModel.likeCount integerValue]];
    if (itemsModel.isLiked) {
        self.likeBtn.selected = YES;
        self.likeNumLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }else {
        self.likeBtn.selected = NO;
        if ([itemsModel.likeCount isEqualToString:@"0"]) {
            self.likeNumLabel.text = nil;
        }else {
            self.likeNumLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
    //回复数
    if ([itemsModel.replyCount isEqualToString:@"0"]) {
        self.reviewNumLabel.text = nil;
    }else {
        self.reviewNumLabel.text = itemsModel.replyCount;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        __weak typeof(self.contentView) ws = self.contentView;
        
        UIView *topView = [UIView new];
        [ws addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_top);
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
        }];
        
        UIView *touchView = [UIView new];
        touchView.backgroundColor = [UIColor clearColor];
        [topView addSubview:touchView];
        [touchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_top);
            make.leading.mas_equalTo(topView.mas_leading);
            make.bottom.equalTo(topView.mas_bottom);
            make.width.equalTo(self.contentView).multipliedBy(0.7);
        }];
        
        UITapGestureRecognizer *tapMyStyle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMyStyleBtn:)];
        [touchView addGestureRecognizer:tapMyStyle];
        
        YYAnimatedImageView *iconImg = [YYAnimatedImageView new];
        iconImg.contentMode = UIViewContentModeScaleToFill;
        iconImg.clipsToBounds = YES;
        [topView addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_top).offset(12);
            make.bottom.equalTo(topView.mas_bottom);
            make.leading.mas_equalTo(topView.mas_leading).offset(10);
            make.width.height.mas_equalTo(@39);
        }];
        self.iconImg = iconImg;
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        [topView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).offset(10);
            make.top.mas_equalTo(iconImg.mas_top).mas_offset(3);
        }];
        self.nameLabel = nameLabel;
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        [topView addSubview:timeLabel];
        
        [timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImg.mas_bottom).mas_offset(1);
            make.leading.mas_equalTo(nameLabel.mas_leading);
        }];
        self.timeLabel = timeLabel;
        
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.tag = followBtnTag;
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        followBtn.layer.borderColor = ZFCOLOR(255, 168, 0, 1).CGColor;
        [followBtn setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [followBtn setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        } else {
            [followBtn setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }
        
        followBtn.layer.borderWidth = 1;
        followBtn.layer.cornerRadius = 2;
        followBtn.layer.masksToBounds = YES;
        [followBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:followBtn];
        
        [followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(topView.mas_bottom).mas_offset(-5);
            make.trailing.mas_equalTo(topView.mas_trailing).offset(-10);
            make.height.mas_equalTo(@26);
            make.width.mas_equalTo(@94);
        }];
        self.followBtn = followBtn;
        
        CommunityImageLayoutView *contentImgView = [CommunityImageLayoutView new];
        [ws addSubview:contentImgView];
        
        [contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.top.mas_equalTo(topView.mas_bottom).offset(8);
            //            self.contentImgHeight = make.height.mas_equalTo(0);
        }];
        self.contentImgView = contentImgView;
        
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        
        YYLabel *contentLabel = [YYLabel new];
        contentLabel.numberOfLines = 5;
        contentLabel.linePositionModifier = modifier;
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [ws addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading).offset(10);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-10);
            make.top.mas_equalTo(contentImgView.mas_bottom).offset(8);
        }];
        self.contentLabel = contentLabel;
        
        UIButton *shareBtn = [UIButton new];
        shareBtn.tag = shareBtnTag;
        [shareBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [ws addSubview:shareBtn];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(16);
            make.bottom.equalTo(ws.mas_bottom).offset(-10);
            make.leading.mas_equalTo(ws.mas_leading).offset(11);
        }];
        self.shareBtn = shareBtn;
        
        UIView *reviewBgView = [[UIView alloc] init];
        [ws addSubview:reviewBgView];
        [reviewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.centerY.mas_equalTo(shareBtn.mas_centerY);
        }];
        
        UIButton *reviewBtn = [UIButton new];
        reviewBtn.tag = reviewBtnTag;
        [reviewBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [reviewBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [reviewBgView addSubview:reviewBtn];
        
        [reviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(reviewBgView);
            make.leading.mas_equalTo(0);
            make.centerY.mas_equalTo(reviewBgView.mas_centerY);
        }];
        self.reviewBtn = reviewBtn;
        
        UILabel *reviewNumLabel = [UILabel new];
        reviewNumLabel.font = [UIFont systemFontOfSize:12];
        reviewNumLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        [reviewBgView addSubview:reviewNumLabel];
        
        [reviewNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(0);
            make.centerY.mas_equalTo(reviewBgView.mas_centerY);
            make.leading.mas_equalTo(reviewBtn.mas_trailing).offset(5);
        }];
        self.reviewNumLabel = reviewNumLabel;
        
        UIButton *likeBtn = [UIButton new];
        likeBtn.tag = likeBtnTag;
        [likeBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [likeBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateSelected];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        }else{
            [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
        }
        
        [ws addSubview:likeBtn];
        self.likeBtn = likeBtn;
        
        UILabel *likeNumLabel = [UILabel new];
        likeNumLabel.font = [UIFont systemFontOfSize:12];
        likeNumLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
        [ws addSubview:likeNumLabel];
        
        [likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-10);
            make.centerY.mas_equalTo(shareBtn.mas_centerY).mas_offset(3);
        }];
        self.likeNumLabel = likeNumLabel;
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(likeNumLabel.mas_leading).offset(0);
            make.centerY.mas_equalTo(shareBtn.mas_centerY);
            make.width.mas_equalTo(60);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        [ws addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(ws.mas_bottom).offset(-1);
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.height.mas_equalTo(@1);
            make.top.mas_equalTo(likeBtn.mas_bottom).offset(10);
        }];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [ws addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom);
            make.leading.trailing.mas_equalTo(ws);
            make.height.mas_equalTo(@10);
            make.bottom.mas_equalTo(ws.mas_bottom).offset(-1);
        }];
    }
    return self;
}

#pragma mark - 跳转 My Style ViewController
- (void)tapMyStyleBtn:(UITapGestureRecognizer*)sender {
    if (self.communtiyMyStyleBlock) {
        self.communtiyMyStyleBlock();
    }
}

- (NSString*)timer:(NSString*)timer {
    NSInteger intervalTime = [timer integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMM dd, yyyy";
    NSString *time = [df stringFromDate:date];
    return time;
}

#pragma mark - Button放大缩小的动画效果
- (CAKeyframeAnimation *)createFavouriteAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

#pragma mark - Button Click Event
- (void)clickEvent:(UIButton*)sender {
    switch (sender.tag) {
        case likeBtnTag:
        {
            [self.likeBtn.layer addAnimation:[self createFavouriteAnimation] forKey:@"Liked"];
            if (self.clickEventBlock) {
                self.clickEventBlock(sender);
            }
        }
            break;
        case reviewBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(sender);
            }
        }
            break;
        case shareBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(sender);
            }
        }
            break;
        case followBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(sender);
            }
        }
            break;
        default:
            break;
    }
}

@end
