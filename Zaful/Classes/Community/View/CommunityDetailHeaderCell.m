//
//  CommunityDetailHeaderCell.m
//  Yoshop
//
//  Created by huangxieyue on 16/8/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailHeaderCell.h"

#import "CommunityDetailModel.h"
#import "CommunityDetailGoodsView.h"
#import "CommunityDetailLikeUserModel.h"
#import "PictureModel.h"
#import "YYText.h"
#import "UIButton+EnlargeEdge.h"

#import "YYPhotoBrowseView.h"

@interface CommunityDetailHeaderCell ()

@property (nonatomic,weak) YYAnimatedImageView *iconImg;//头像
@property (nonatomic,weak) UILabel *nameLabel;//昵称
@property (nonatomic, weak) UILabel *topLabel;
@property (nonatomic,weak) UILabel *timeLabel;//评论发布时间
@property (nonatomic,weak) UIButton *followBtn;//关注按钮
@property (nonatomic,weak) YYLabel *contentLabel;//评论内容
@property (nonatomic,weak) UIView *contentImgView;//图片容器
@property (nonatomic,weak) YYAnimatedImageView *comtentImg;//评论图片

@property (nonatomic,weak) UIView *contentLikeView;//点赞列表容器
@property (nonatomic,weak) UIView *likeIconView;//点赞用户头像容器
@property (nonatomic,weak) YYAnimatedImageView *likeIconImg;//点赞用户头像
@property (nonatomic,weak) UILabel *likeNum;//点赞数
@property (nonatomic,weak) UILabel *likeLabel;//固定字串 Likes

@property (nonatomic,weak) UIView *contentGoodsView;//商品列表容器
@property (nonatomic,weak) UIView *bottomView;//底部点击按钮容器

@property (nonatomic,weak) UIButton *likeBtn;//点赞按钮
@property (nonatomic,weak) UILabel *likeNumLabel;//点赞数
@property (nonatomic,weak) UIButton *reviewBtn;//评论按钮
@property (nonatomic,weak) UILabel *reviewNumLabel;//评论数
@property (nonatomic,weak) UIButton *shareBtn;//分享按钮

@property (nonatomic,strong) MASConstraint *contentLikeHeight;//点赞容器的高度

@property (nonatomic,weak) BigClickAreaButton *deleteBtn;//删除按钮

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSMutableArray *imgArrays;

@end

@implementation CommunityDetailHeaderCell

+ (CommunityDetailHeaderCell *)communityDetailHeaderCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CommunityDetailHeaderCell class] forCellReuseIdentifier:COMMUNITY_DETAIL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:COMMUNITY_DETAIL_INENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //添加约束，进行自动布局
        __weak typeof(self.contentView) ws = self.contentView;
        
        ws.backgroundColor = ZFCOLOR_WHITE;
        
        YYAnimatedImageView *iconImg = [YYAnimatedImageView new];
        iconImg.contentMode = UIViewContentModeScaleToFill;
        iconImg.clipsToBounds = YES;
        iconImg.layer.cornerRadius = 20.0;
        iconImg.layer.masksToBounds = YES;
        [ws addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_top).offset(12);
            make.leading.mas_equalTo(ws.mas_leading).mas_offset(10);
            make.width.height.mas_equalTo(@40);
        }];
        self.iconImg = iconImg;
        
        UILabel *nameLabel = [UILabel new];
        // nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [ws addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).mas_offset(10);
            make.top.mas_equalTo(iconImg.mas_top).mas_offset(3);
        }];
        self.nameLabel = nameLabel;
        
        
        UILabel *topLabel = [UILabel new];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.font = [UIFont systemFontOfSize:10];
        topLabel.backgroundColor = ZFCOLOR(255, 168, 0, 1.0);
        topLabel.textColor = ZFCOLOR(255, 255, 255, 1);
        topLabel.text = ZFLocalizedString(@"Community_TOP",nil);
        topLabel.hidden = YES;
        topLabel.clipsToBounds = YES;
        topLabel.layer.masksToBounds = YES;
        [ws addSubview:topLabel];
        
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel);
            make.size.mas_equalTo(CGSizeMake(24, 16));
            make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(8);
        }];
        self.topLabel = topLabel;
        
        
        BigClickAreaButton *deleteBtn = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = deleteBtnTag;
        deleteBtn.clickAreaRadious = 60;
        
        deleteBtn.layer.borderColor = ZFCOLOR(102, 102, 102, 1).CGColor;
        [deleteBtn setTitleColor:ZFCOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"community_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ws addSubview:deleteBtn];
        
        [deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.mas_top).offset(36);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-16);
            make.height.mas_equalTo(@4);
            make.width.mas_equalTo(@24);
        }];
        self.deleteBtn = deleteBtn;
        
        
        UIButton *jumpToMystyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jumpToMystyleBtn.backgroundColor = [UIColor clearColor];
        jumpToMystyleBtn.tag = mystyleBtnTag;
        [jumpToMystyleBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ws addSubview:jumpToMystyleBtn];
        [jumpToMystyleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_leading);
            make.top.mas_equalTo(iconImg.mas_top);
            make.bottom.mas_equalTo(iconImg.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/2);
        }];
        
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.tag = followBtnTag;
        followBtn.titleLabel.textColor = ZFCOLOR(255, 168, 0, 1);
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
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        followBtn.layer.borderWidth = 1;
        followBtn.layer.cornerRadius = 2;
        followBtn.layer.masksToBounds = YES;
        [followBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [ws addSubview:followBtn];
        
        [followBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(iconImg.mas_centerY);
            make.trailing.mas_equalTo(ws.mas_trailing).offset(-10);
            make.height.mas_equalTo(@26);
            make.width.mas_equalTo(@94);
        }];
        self.followBtn = followBtn;
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        [ws addSubview:timeLabel];
        
        [timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImg.mas_bottom).mas_offset(-3);
            make.leading.mas_equalTo(nameLabel.mas_leading).mas_offset(2);
        }];
        self.timeLabel = timeLabel;
        
        UIView *contentImgView = [UIView new];
        contentImgView.backgroundColor = ZFCOLOR_WHITE;
        [ws addSubview:contentImgView];
        
        [contentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.top.mas_equalTo(iconImg.mas_bottom).mas_offset(8);
        }];
        self.contentImgView = contentImgView;
        
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        
        YYLabel *contentLabel = [YYLabel new];
        contentLabel.numberOfLines = 0;
        contentLabel.linePositionModifier = modifier;
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-20;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [ws addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading).mas_offset(10);
            make.trailing.mas_equalTo(ws.mas_trailing).mas_offset(-10);
            make.top.mas_equalTo(contentImgView.mas_bottom).mas_offset(8);
        }];
        self.contentLabel = contentLabel;
        
        UIView *contentLikeView = [UIView new];
        contentLikeView.backgroundColor = ZFCOLOR_WHITE;
        [ws addSubview:contentLikeView];
        
        [contentLikeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            //点赞容器一开始高度为0 根据数据返回是否有点赞用户再设置高度 -> 40h
            self.contentLikeHeight = make.height.mas_equalTo(@0);
            make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(16);
        }];
        self.contentLikeView = contentLikeView;
        
        UIView *likeIconView = [UIView new];
        [contentLikeView addSubview:likeIconView];
        
        [likeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(contentLikeView.mas_leading);
            make.top.mas_equalTo(contentLikeView.mas_top);
            make.bottom.mas_equalTo(contentLikeView.mas_bottom);
        }];
        self.likeIconView = likeIconView;
        
        UITapGestureRecognizer *taplikeView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplikeView:)];
        [contentLikeView addGestureRecognizer:taplikeView];
        
        UILabel *likeLabel = [UILabel new];
        likeLabel.font = [UIFont systemFontOfSize:12];
        likeLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [contentLikeView addSubview:likeLabel];
        
        [likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(contentLikeView.mas_trailing).offset(-10);
            make.centerY.mas_equalTo(contentLikeView.mas_centerY);
        }];
        self.likeLabel = likeLabel;
        
        UILabel *likeNum = [UILabel new];
        likeNum.font = [UIFont systemFontOfSize:12];
        likeNum.textColor = ZFCOLOR(255, 111, 0, 1.0);
        [contentLikeView addSubview:likeNum];
        
        [likeNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(likeLabel.mas_leading).offset(-3);
            make.centerY.mas_equalTo(likeLabel.mas_centerY);
        }];
        self.likeNum = likeNum;
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = ZFCOLOR_WHITE;
        [ws addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.height.mas_equalTo(@40);
            make.top.mas_equalTo(contentLikeView.mas_bottom).mas_offset(15);
        }];
        self.bottomView = bottomView;
        
        UIButton *shareBtn = [UIButton new];
        shareBtn.tag = shareBtnTag;
        [shareBtn  setEnlargeEdge:40];
        [shareBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [bottomView addSubview:shareBtn];
        
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.leading.mas_equalTo(bottomView.mas_leading).mas_offset(11);
        }];
        self.shareBtn = shareBtn;
        
        UIView *reviewBgView = [[UIView alloc] init];
        [bottomView addSubview:reviewBgView];
        [reviewBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(bottomView.mas_centerX);
        }];
        
        UIButton *reviewBtn = [UIButton new];
        reviewBtn.tag = reviewBtnTag;
         [reviewBtn  setEnlargeEdge:40];
        [reviewBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [reviewBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [reviewBgView addSubview:reviewBtn];
        
        [reviewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.centerY.mas_equalTo(reviewBgView.mas_centerY);
        }];
        self.reviewBtn = reviewBtn;
        
        UILabel *reviewNumLabel = [UILabel new];
        reviewNumLabel.font = [UIFont systemFontOfSize:12];
        reviewNumLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [reviewBgView addSubview:reviewNumLabel];
        
        [reviewNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(0);
            make.centerY.mas_equalTo(reviewBgView.mas_centerY);
            make.leading.mas_equalTo(reviewBtn.mas_trailing).offset(5);
        }];
        self.reviewNumLabel = reviewNumLabel;
        
        
        UIButton *likeBtn = [UIButton new];
        likeBtn.tag = likeBtnTag;
        [likeBtn setEnlargeEdge:40];
        [likeBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [likeBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"collection_on"] forState:UIControlStateSelected];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
        }else{
            [likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, -15)];
        }
        [bottomView addSubview:likeBtn];
        self.likeBtn = likeBtn;
        
        UILabel *likeNumLabel = [UILabel new];
        likeNumLabel.font = [UIFont systemFontOfSize:12];
        likeNumLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
        [bottomView addSubview:likeNumLabel];
        
        [likeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(bottomView.mas_trailing).offset(-10);
            make.centerY.mas_equalTo(shareBtn.mas_centerY).mas_offset(3);
        }];
        self.likeNumLabel = likeNumLabel;
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(likeNumLabel.mas_leading);
            make.centerY.mas_equalTo(shareBtn.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(24);
        }];
        self.likeNumLabel = likeNumLabel;

        UIView *contentGoodsView = [UIView new];
        contentGoodsView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [ws addSubview:contentGoodsView];
        
        [contentGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.top.mas_equalTo(bottomView.mas_bottom).mas_offset(10);
        }];
        self.contentGoodsView = contentGoodsView;
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [ws addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.top.mas_equalTo(contentGoodsView.mas_bottom);
            make.height.mas_equalTo(@10);
        }];
        
        UIView *reviewsLbView = [UIView new];
        reviewsLbView.backgroundColor = ZFCOLOR_WHITE;
        [ws addSubview:reviewsLbView];
        
        [reviewsLbView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
            make.height.mas_equalTo(@40);
            make.top.mas_equalTo(line.mas_bottom);
            make.bottom.mas_equalTo(ws.bottom).mas_offset(-1);
        }];
        
        UIView *line1 = [UIView new];
        line1.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [reviewsLbView addSubview:line1];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(16);
            make.centerY.mas_equalTo(reviewsLbView.mas_centerY);
            make.leading.mas_equalTo(reviewsLbView.mas_leading);
        }];
        
        UILabel *reviewsTitle = [UILabel new];
        reviewsTitle.text = ZFLocalizedString(@"TopicDetailView_Reviews",nil);
        reviewsTitle.font = [UIFont systemFontOfSize:18];
        reviewsTitle.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [reviewsLbView addSubview:reviewsTitle];
        
        [reviewsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(reviewsLbView.mas_centerY);
            make.leading.mas_equalTo(reviewsLbView.mas_leading).mas_offset(10);
        }];
    }
    return self;
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
            if (self.clickDetailBlock) {
                self.clickDetailBlock(likeBtnTag);
            }
        }
            break;
        case reviewBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(reviewBtnTag);
            }
        }
            break;
        case integralBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(integralBtnTag);
            }
        }
            break;
        case shareBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(shareBtnTag);
            }
        }
            break;
        case mystyleBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(mystyleBtnTag);
            }
        }
            break;
        case followBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(followBtnTag);
            }
        }
            break;
        case deleteBtnTag:
        {
            if (self.clickDetailBlock) {
                self.clickDetailBlock(deleteBtnTag);
            }
        }
            break;
        default:
            break;
    }
}

- (void) initWithDetailModel:(CommunityDetailModel*)detailModel ListUser:(NSMutableArray*)listUser {
    //清除子视图防止二次创建
    [self.contentImgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [obj removeFromSuperview];
    }];
    
    [self.likeIconView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [obj removeFromSuperview];
    }];
    
    if (!detailModel) {
        return;
    }
    //头像
    [self.iconImg yy_setImageWithURL:[NSURL URLWithString:detailModel.avatar]
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
    self.nameLabel.text = detailModel.nickname;
    //热榜
    if (![detailModel.sort isEqualToString:@"999"]) {
        self.topLabel.hidden = NO;
    }else {
        self.topLabel.hidden = YES;
    }
    
    //评论时间
    self.timeLabel.text = [NSStringUtils timeLapse:[detailModel.addTime integerValue]];
    
    if ([USERID isEqualToString: detailModel.userId]) {
        self.deleteBtn.hidden = NO;
    } else {
        self.deleteBtn.hidden = YES;
    }
    
    
    NSMutableString *contentStr = [NSMutableString string];
    if (detailModel.labelInfo.count>0) {
        for (NSString *str in detailModel.labelInfo) {
            [contentStr appendString:[NSString stringWithFormat:@"%@ ", str]];
        }
    }
    [contentStr appendString:detailModel.content ?: @""];
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
    if ([SystemConfigUtils isRightToLeftShow]) {
        // NSParagraphStyle
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentRight;
        [content addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    }
    //评论内容
    self.contentLabel.attributedText = content;
    
    //判断关注
    if ([USERID isEqualToString: detailModel.userId]) {
        self.followBtn.hidden = YES;
    }else {
        self.followBtn.hidden = NO;
        //是否关注
        if (detailModel.isFollow) {
            self.followBtn.hidden = YES;
        }else{
            self.followBtn.hidden = NO;
        }
    }
    

    [self.imgArrays removeAllObjects];
    [self.items removeAllObjects];
    
    //图片布局
    if (![NSArrayUtils isEmptyArray:detailModel.reviewPic]) {
        
        CGFloat fixedSpacing = 10;
        CGFloat width = SCREEN_WIDTH - 2 * fixedSpacing;
        
        if (detailModel.reviewPic.count < 2) {
            YYAnimatedImageView *comtentImg = [YYAnimatedImageView new];
            comtentImg.contentMode = UIViewContentModeScaleAspectFill;
            comtentImg.clipsToBounds = YES;
            
            CGFloat height =  [[detailModel.reviewPic.firstObject valueForKey:@"bigPicHeight"] floatValue] / [[detailModel.reviewPic.firstObject valueForKey:@"bigPicWidth"] floatValue] * width;
            
            [comtentImg yy_setImageWithURL:[NSURL URLWithString:[detailModel.reviewPic.firstObject valueForKey:@"bigPic"]]
                              processorKey:NSStringFromClass([self class])
                               placeholder:[UIImage imageNamed:@"community_loading_product"]
                                   options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                  progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                 transform:^UIImage *(UIImage *image, NSURL *url) {
                                     return image;
                                 }
                                completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                }];
            [self.contentImgView addSubview:comtentImg];
            
            comtentImg.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
            [comtentImg addGestureRecognizer:tap];

            
            
            [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentImgView.mas_top);
                make.bottom.mas_equalTo(self.contentImgView.mas_bottom);
                make.centerX.mas_equalTo(self.contentImgView.mas_centerX);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];
            
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = comtentImg;
            NSString *imgString = [detailModel.reviewPic.firstObject valueForKey:@"bigPic"];
            NSURL *url = [NSURL URLWithString:imgString];
            item.largeImageURL = url;
            [self.items addObject:item];
            [self.imgArrays addObject:comtentImg];
            
        }else {
            __block YYAnimatedImageView *tempImg = [YYAnimatedImageView new];
            [detailModel.reviewPic enumerateObjectsUsingBlock:^(PictureModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                YYAnimatedImageView *comtentImg = [YYAnimatedImageView new];
                comtentImg.contentMode = UIViewContentModeScaleAspectFill;
                comtentImg.clipsToBounds = YES;
                comtentImg.tag = idx;
                
                CGFloat height =  [obj.bigPicHeight floatValue] / [obj.bigPicWidth floatValue] * width;
                [comtentImg yy_setImageWithURL:[NSURL URLWithString:obj.bigPic]
                                  processorKey:NSStringFromClass([self class])
                                   placeholder:[UIImage imageNamed:@"community_loading_product"]
                                       options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                     transform:^UIImage *(UIImage *image, NSURL *url) {
                                         return image;
                                     }
                                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                    }];
                [self.contentImgView addSubview:comtentImg];
                
                if (idx == 0) {
                    [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(self.contentImgView.mas_top).offset(10);
                        make.centerX.mas_equalTo(self.contentImgView.mas_centerX);
                        make.width.mas_equalTo(width) ;
                        make.height.mas_equalTo(height);
                    }];
                } else if (idx == detailModel.reviewPic.count - 1) {
                    [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(tempImg.mas_bottom).offset(7);
                        make.bottom.mas_equalTo(self.contentImgView.mas_bottom);
                        make.centerX.mas_equalTo(self.contentImgView.mas_centerX);
                        make.width.mas_equalTo(width) ;
                        make.height.mas_equalTo(height);
                    }];
                } else {
                    [comtentImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(tempImg.mas_bottom).offset(7);
                        make.centerX.mas_equalTo(self.contentImgView.mas_centerX);
                        make.width.mas_equalTo(width) ;
                        make.height.mas_equalTo(height);
                    }];
                }
                tempImg = comtentImg;
                
                comtentImg.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
                [comtentImg addGestureRecognizer:tap];
                
                YYPhotoGroupItem *item = [YYPhotoGroupItem new];
                item.thumbView = comtentImg;
                NSString *imgString = obj.bigPic;
                NSURL *url = [NSURL URLWithString:imgString];
                item.largeImageURL = url;
                [self.items addObject:item];
                [self.imgArrays addObject:comtentImg];

            }];
        }
    }
    
    //点赞列表
    NSMutableArray *likeArray = [[NSMutableArray alloc] init];
    if (![NSArrayUtils isEmptyArray:listUser]) {
        if (listUser.count < 2) {
            self.contentLikeHeight.mas_equalTo(@40);
            self.likeLabel.text = ZFLocalizedString(@"CommunityDetailHeaderCell_Likes",nil);
            self.likeNum.text = [NSString stringWithFormat:@"%ld",(unsigned long)listUser.count];
            YYAnimatedImageView *likeIconImg = [YYAnimatedImageView new];
            likeIconImg.clipsToBounds = YES;
            likeIconImg.layer.cornerRadius = 20;
            likeIconImg.contentMode = UIViewContentModeScaleToFill;
            [likeIconImg yy_setImageWithURL:[NSURL URLWithString:[listUser.firstObject valueForKey:@"avatar"]]
                               processorKey:NSStringFromClass([self class])
                                placeholder:[UIImage imageNamed:@"index_cat_loading"]
                                    options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                  transform:^UIImage *(UIImage *image, NSURL *url) {
                                      image = [image yy_imageByResizeToSize:CGSizeMake(40,40) contentMode:UIViewContentModeScaleToFill];
                                      return [image yy_imageByRoundCornerRadius:20];
                                  }
                                 completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                 }];
            [self.likeIconView addSubview:likeIconImg];
            [likeIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(40);
                make.leading.mas_equalTo(self.likeIconView.mas_leading).mas_offset(16);
                make.centerY.mas_equalTo(self.likeIconView.mas_centerY);
            }];
        }else {
            self.contentLikeHeight.mas_equalTo(@40);
            self.likeLabel.text = ZFLocalizedString(@"CommunityDetailHeaderCell_Likes",nil);
            self.likeNum.text = [NSString stringWithFormat:@"%ld",(unsigned long)listUser.count];
            [listUser enumerateObjectsUsingBlock:^(CommunityDetailLikeUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (IPHONE_4X_3_5 || IPHONE_5X_4_0) {
                    if (idx == 5) {
                        *stop = YES;
                        return;
                    }
                } else if (IPHONE_6X_4_7) {
                    if (idx == 6) {
                        *stop = YES;
                        return;
                    }
                } else if (IPHONE_6P_5_5) {
                    if (idx == 7) {
                        *stop = YES;
                        return;
                    }
                }
                YYAnimatedImageView *likeIconImg = [YYAnimatedImageView new];
                likeIconImg.clipsToBounds = YES;
                likeIconImg.layer.cornerRadius = 20;
                likeIconImg.contentMode = UIViewContentModeScaleToFill;
                [likeIconImg yy_setImageWithURL:[NSURL URLWithString:obj.avatar]
                                   processorKey:NSStringFromClass([self class])
                                    placeholder:[UIImage imageNamed:@"index_cat_loading"]
                                        options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                      transform:^UIImage *(UIImage *image, NSURL *url) {
                                          image = [image yy_imageByResizeToSize:CGSizeMake(40,40) contentMode:UIViewContentModeScaleToFill];
                                          return [image yy_imageByRoundCornerRadius:20];
                                      }
                                     completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                     }];
                [self.likeIconView addSubview:likeIconImg];
                [likeArray addObject:likeIconImg];
            }];
            [likeArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:4 leadSpacing:16 tailSpacing:10];
            
            [likeArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(40);
                make.centerY.mas_equalTo(self.likeIconView.mas_centerY);
            }];
        }
    }else {
        self.contentLikeHeight.mas_equalTo(@0);
    }
    
    //商品列表
    NSMutableArray *goodsArray = [[NSMutableArray alloc] init];
    if (![NSArrayUtils isEmptyArray:detailModel.goodsInfos]) {
        if (detailModel.goodsInfos.count < 2) {
            CommunityDetailGoodsView *goodsView = [CommunityDetailGoodsView new];
            goodsView.controller = self.controller;
            goodsView.infoModel = detailModel.goodsInfos.firstObject;
            [self.contentGoodsView addSubview:goodsView];
            
            [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.contentGoodsView.mas_centerX);
                make.height.mas_equalTo(114);
                make.edges.mas_equalTo(self.contentGoodsView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }else {
            [detailModel.goodsInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CommunityDetailGoodsView *goodsView = [CommunityDetailGoodsView new];
                goodsView.controller = self.controller;
                goodsView.infoModel = detailModel.goodsInfos[idx];
                [self.contentGoodsView addSubview:goodsView];
                [goodsArray addObject:goodsView];
            }];
            
            [goodsArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            
            [goodsArray mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(114);
                make.width.mas_equalTo(SCREEN_WIDTH);
                make.centerX.mas_equalTo(self.contentGoodsView.mas_centerX);
            }];
        }
    }
    //用户是否点赞
    self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[detailModel.likeCount integerValue]];
    if (detailModel.isLiked) {
        self.likeBtn.selected = YES;
        self.likeNumLabel.textColor = ZFCOLOR(255, 111, 0, 1.0);
    }else {
        self.likeBtn.selected = NO;
        if ([detailModel.likeCount isEqualToString:@"0"]) {
            self.likeNumLabel.text = nil;
            self.likeLabel.text = nil;
            self.likeNum.text = nil;
        }else {
            self.likeNumLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
    //回复数
    if ([detailModel.replyCount isEqualToString:@"0"]) {
        self.reviewNumLabel.text = nil;
    }else {
        self.reviewNumLabel.text = detailModel.replyCount;
    }
}

- (void)taplikeView:(UITapGestureRecognizer*)sender {
    if (self.clickLikeListBlock) {
        self.clickLikeListBlock();
    }
}

- (void)imageViewClick:(UIGestureRecognizer *)gesture {
    NSLog(@"gesture:%d",(int)gesture.view.tag);
    if (self.imgTouchBlock) {
        self.imgTouchBlock(self.items ,self.imgArrays,gesture.view.tag);
    }
}

#pragma mark - lazy
-(NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

-(NSMutableArray *)imgArrays {
    if (!_imgArrays) {
        _imgArrays = [NSMutableArray array];
    }
    return _imgArrays;
}

@end
