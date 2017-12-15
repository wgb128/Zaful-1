//
//  TopicDetailHeadView.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailHeadView.h"
#import "YYText.h"
#import "UIButton+UIButtonImageWithLable.h"
#import "UIButton+GraphicBtn.h"

@interface TopicDetailHeadView ()
@property (nonatomic, strong) YYAnimatedImageView *topicImg;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *joinNumLabel;
@property (nonatomic, strong) UIButton *joinBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) UIButton *viewAllBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic,strong) MASConstraint *contentHeight;//点赞容器的高度
@property (nonatomic,strong) MASConstraint *headContentHeight;//点赞容器的高度
@property (nonatomic,strong) MASConstraint *viewAllHeight;//viewAll

@property (nonatomic, assign)  CGFloat baseFontSize;       //基准字体大小
@property (nonatomic, assign)  CGFloat topicHeadHeight;       //基准字体大小

@property (nonatomic, assign)CGFloat contentRealH;
@end
@implementation TopicDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.baseFontSize = 14;
        self.topicHeadHeight = 0;
        
        YYAnimatedImageView *topicImg = [YYAnimatedImageView new];
        topicImg.contentMode = UIViewContentModeScaleAspectFill;
        topicImg.clipsToBounds = YES;
        [self addSubview:topicImg];
        
        [topicImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(160 *DSCREEN_WIDTH_SCALE);
        }];
        self.topicImg = topicImg;
        
        UILabel *topicTitleLabel = [UILabel new];
        topicTitleLabel.font = [UIFont systemFontOfSize:18];
        topicTitleLabel.textColor = ZFCOLOR_BLACK;
        [self addSubview:topicTitleLabel];
        
        [topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicImg.mas_bottom).offset(10);
            make.leading.mas_equalTo(self).offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(SCREEN_WIDTH - 84);
        }];
        self.topicTitleLabel = topicTitleLabel;
        
        UILabel *joinNumLabel = [UILabel new];
        joinNumLabel.font = [UIFont systemFontOfSize:12];
        joinNumLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        [self addSubview:joinNumLabel];
        
        [joinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicTitleLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self).offset(10);
            make.height.mas_equalTo(20);
            
        }];
        self.joinNumLabel = joinNumLabel;
        
        UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinBtn.backgroundColor = ZFCOLOR(255, 168, 0, 1.0);
        [joinBtn initWithTitle:ZFLocalizedString(@"TopicDetailView_joinIn", nil) andImageName:@"joinin" andTopHeight:20 andTextColor:[UIColor whiteColor]];
        joinBtn.clipsToBounds = YES;
        joinBtn.layer.cornerRadius = 37;
        joinBtn.layer.masksToBounds = YES;
        [joinBtn addTarget:self action:@selector(joinBtnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:joinBtn];
        
        [joinBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.top.mas_equalTo(topicImg.mas_bottom).offset(10);
            make.trailing.mas_equalTo(self).offset(- 10);
            make.centerY.mas_equalTo(topicTitleLabel.mas_centerY).mas_offset(-15);
            make.width.height.mas_equalTo(74);
        }];
        self.joinBtn = joinBtn;
        
        YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
        modifier.fixedLineHeight = 18;//行高
        YYLabel *contentLabel = [YYLabel new];
        contentLabel.numberOfLines = 4;
        contentLabel.linePositionModifier = modifier;
        contentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(joinNumLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self).offset(10);
            make.width.mas_equalTo(SCREEN_WIDTH - 20);
        }];
        self.contentLabel = contentLabel;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(@1);
        }];
        self.lineView = lineView;
        
        UIButton *viewAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        viewAllBtn.tag = 10;
        viewAllBtn.backgroundColor = [UIColor clearColor];
        viewAllBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //        [viewAllBtn setTitle:@"VIEW ALL" forState:UIControlStateNormal];
        [viewAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [viewAllBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewAllBtn];
        
        [viewAllBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineView.mas_bottom);
            make.leading.trailing.mas_equalTo(self);
            self.viewAllHeight = make.height.mas_equalTo(40);
        }];
        self.viewAllBtn = viewAllBtn;
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(viewAllBtn.mas_bottom).offset(5);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(@10);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.bottomView = bottomView;
    }
    return self;
}

- (void)setTopicDetailHeadModel:(TopicDetailHeadLabelModel *)topicDetailHeadModel {
    
    [self.topicImg yy_setImageWithURL:[NSURL URLWithString:topicDetailHeadModel.iosDetailpic]
                         processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"community_index_banner_loading"]
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                                   ZFLog(@"load from disk cache");
                               }
                           }];
    
    self.topicTitleLabel.text = topicDetailHeadModel.title;
//    self.contentLabel.text = topicDetailHeadModel.content;
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",topicDetailHeadModel.topicLabel,topicDetailHeadModel.content]];
    content.yy_font = [UIFont systemFontOfSize:14];
    content.yy_color = ZFCOLOR(102, 102, 102, 1.0);
    
    if(topicDetailHeadModel.topicLabel.length > 0) {
        [content yy_setColor:ZFCOLOR(255, 168, 0, 1.0) range:NSMakeRange(0,topicDetailHeadModel.topicLabel.length)];
    }
    if ([SystemConfigUtils isRightToLeftShow]) {
        // NSParagraphStyle
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentRight;
        [content addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, content.length)];
    }
    
    self.contentLabel.attributedText = content;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.joinNumLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"Community_Big_Views",nil),topicDetailHeadModel.joinNumber];
    } else {
        self.joinNumLabel.text = [NSString stringWithFormat:@"%@ %@",topicDetailHeadModel.joinNumber,ZFLocalizedString(@"Community_Big_Views",nil)];
    }
    
    self.contentRealH = [self TextHeight:self.contentLabel.text FontSize:self.baseFontSize Width:SCREEN_WIDTH - 20];
    if(self.contentRealH > 4 *self.baseFontSize){
        self.viewAllHeight.mas_equalTo(40);
//        [self.viewAllBtn setTitle:@"VIEW ALL" forState:UIControlStateNormal];
        [self.viewAllBtn setImage:[UIImage imageNamed:@"view_down"] withTitle:ZFLocalizedString(@"TopicDetailView_ViewAll", nil) forState:UIControlStateNormal];
        self.lineView.hidden = NO;
    }else {
        self.viewAllHeight.mas_equalTo(0);
//        [self.viewAllBtn setTitle:@"" forState:UIControlStateNormal];
        [self.viewAllBtn setImage:nil withTitle:@"" forState:UIControlStateNormal];
        self.lineView.hidden = YES;
    }
    
    if (self.refreshHeadViewBlock) {
        self.refreshHeadViewBlock();
    }
}

- (void)joinBtnClickEvent:(UIButton*)sender {
    if (self.joinInMyStyleBlock) {
        self.joinInMyStyleBlock(self.topicTitleLabel.text);
    }
    
}

#pragma mark - Button Click Event
- (void)clickEvent:(UIButton*)sender {
    sender.selected = !sender.selected;
     [[NSNotificationCenter defaultCenter] postNotificationName:@"VIEWALL" object:self userInfo:@{@"isShow":@(sender.selected)}];
    if(sender.selected){
        self.contentLabel.numberOfLines = 0;
        [self.viewAllBtn setImage:[UIImage imageNamed:@"view_up"] withTitle:ZFLocalizedString(@"TopicDetailView_ViewAll", nil) forState:UIControlStateNormal];
        
    }else{
        self.contentLabel.numberOfLines = 4;
        [self.viewAllBtn setImage:[UIImage imageNamed:@"view_down"] withTitle:ZFLocalizedString(@"TopicDetailView_ViewAll", nil) forState:UIControlStateNormal];
    }
    if (self.refreshHeadViewBlock) {
        self.refreshHeadViewBlock();
    }
}

//固定宽度，获取字符串的高度
- (CGFloat)TextHeight:(NSString *)str2 FontSize:(CGFloat)fontsize Width:(CGFloat)width{
    NSString *str=[NSString stringWithFormat:@"%@",str2];
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    UILabel *lbl = [[UILabel alloc]init];
    UIFont *font =[UIFont fontWithName:lbl.font.familyName size:fontsize];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading  attributes:dic context:nil].size;
    
    return size.height;
}

@end
