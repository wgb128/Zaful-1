//
//  StyleShowsCell.m
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "StyleShowsCell.h"
#import "StyleShowsModel.h"
#import "YYText.h"

@interface StyleShowsCell ()
@property (nonatomic,weak) YYAnimatedImageView *iconImg;//头像
@property (nonatomic,weak) UILabel *nameLabel;//昵称
@property (nonatomic,weak) UIButton *timeLabel;//评论发布时间
@property (nonatomic,weak) YYLabel *contentLabel;//评论内容
@property (nonatomic,weak) CommunityImageLayoutView *contentImgView;//评论图片容器
@property (nonatomic,weak) YYAnimatedImageView *comtentImg;//评论图片
@property (nonatomic,weak) UIButton *likeBtn;//点赞按钮
@property (nonatomic,weak) UILabel *likeNumLabel;//点赞数
@property (nonatomic,weak) UIButton *reviewBtn;//评论按钮
@property (nonatomic,weak) UILabel *reviewNumLabel;//评论数
@property (nonatomic,weak) UIButton *shareBtn;//分享按钮

@property (nonatomic,strong) MASConstraint *contentImgHeight;//图片容器的高度

@property (nonatomic,weak) BigClickAreaButton *deleteBtn;//删除按钮

@end

@implementation StyleShowsCell

+ (StyleShowsCell *)styleShowsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[StyleShowsCell class] forCellReuseIdentifier:STYLE_SHOWS_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:STYLE_SHOWS_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setReviewsModel:(StyleShowsModel *)reviewsModel {
    _reviewsModel = reviewsModel;
    //头像
    [self.iconImg yy_setImageWithURL:[NSURL URLWithString:reviewsModel.avatar]
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
    self.nameLabel.text = reviewsModel.nickName;
    NSInteger intervalTime = [reviewsModel.addTime integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MMM dd, yyyy";
    NSString *time = [df stringFromDate:date];
    [self.timeLabel setTitle:time forState:UIControlStateNormal];

    //评论内容
    NSMutableString *contentStr = [NSMutableString string];
    if (reviewsModel.topicList.count>0) {
        for (NSString *str in reviewsModel.topicList) {
            [contentStr appendString:[NSString stringWithFormat:@"%@ ", str]];
        }
    }
    [contentStr appendString:reviewsModel.content];
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
    
    if ([USERID isEqualToString: reviewsModel.userId])
    {
        self.deleteBtn.hidden = NO;
    }else
    {
        self.deleteBtn.hidden = YES;
    }

    if ([SystemConfigUtils isRightToLeftShow]) {
        // NSParagraphStyle
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentRight;
        [content addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    }
    //评论内容
    self.contentLabel.attributedText = content;
    
    self.contentImgView.imagePaths = [reviewsModel.reviewPic valueForKeyPath:@"bigPic"];
    
    //用户是否点赞
    self.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[reviewsModel.likeCount integerValue]];
    if (reviewsModel.isLiked) {
        self.likeBtn.selected = YES;
        self.likeNumLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
    }else {
        self.likeBtn.selected = NO;
        if ([reviewsModel.likeCount isEqualToString:@"0"]) {
            self.likeNumLabel.text = nil;
        }else {
            self.likeNumLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        }
    }
    //回复数
    if ([reviewsModel.replyCount isEqualToString:@"0"]) {
        self.reviewNumLabel.text = nil;
    }else {
        self.reviewNumLabel.text = reviewsModel.replyCount;
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
        
        UITapGestureRecognizer *tapMyStyle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMyStyleBtn:)];
        [topView addGestureRecognizer:tapMyStyle];
        
        YYAnimatedImageView *iconImg = [YYAnimatedImageView new];
        iconImg.contentMode = UIViewContentModeScaleToFill;
        iconImg.layer.masksToBounds = YES;

        [topView addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_top).offset(12);
            make.bottom.equalTo(topView.mas_bottom);
            make.leading.mas_equalTo(topView.mas_leading).offset(10);
            make.width.height.mas_equalTo(39);
        }];
        self.iconImg = iconImg;
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.numberOfLines = 1;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
        [topView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).offset(10);
            make.top.mas_equalTo(iconImg.mas_top).mas_offset(3);
        }];
        self.nameLabel = nameLabel;
        
        UIButton *timeLabel = [UIButton new];
        timeLabel.userInteractionEnabled = NO;
        timeLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        [timeLabel setTitleColor:ZFCOLOR(170, 170, 170, 1.0) forState:UIControlStateNormal];
        [topView addSubview:timeLabel];
        
        [timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(iconImg.mas_bottom).mas_offset(3);
            make.leading.mas_equalTo(nameLabel.mas_leading);
        }];
        self.timeLabel = timeLabel;
        
        
        BigClickAreaButton *deleteBtn = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = deleteBtnTag;
        deleteBtn.clickAreaRadious = 60;
        [deleteBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:deleteBtn];
        
        [deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_top).offset(36);
            make.trailing.mas_equalTo(topView.mas_trailing).offset(-16);
            make.height.mas_equalTo(@4);
            make.width.mas_equalTo(@24);
            make.leading.mas_equalTo(nameLabel.mas_trailing).offset(5);
        }];
        self.deleteBtn = deleteBtn;
        self.deleteBtn.layer.borderColor = ZFCOLOR(102, 102, 102, 1).CGColor;
        [self.deleteBtn setImage:[UIImage imageNamed:@"community_delete"] forState:UIControlStateNormal];
        
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
            make.trailing.mas_equalTo(likeNumLabel.mas_leading).offset(-5);
            make.centerY.mas_equalTo(shareBtn.mas_centerY);
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
            make.leading.mas_equalTo(ws.mas_leading);
            make.trailing.mas_equalTo(ws.mas_trailing);
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
                self.clickEventBlock(likeBtnTag);
            }
        }
            break;
        case reviewBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(reviewBtnTag);
            }
        }
            break;
        case shareBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(shareBtnTag);
            }
        }
            break;
        case deleteBtnTag:
        {
            if (self.clickEventBlock) {
                self.clickEventBlock(deleteBtnTag);
            }
        }
            break;
        default:
            break;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
