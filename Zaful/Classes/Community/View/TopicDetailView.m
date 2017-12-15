//
//  TopicDetailView.m
//  Zaful
//
//  Created by DBP on 16/12/2.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailView.h"

@interface TopicDetailView ()

@property (nonatomic, strong) UIButton *rankingBtn;
@property (nonatomic, strong) UIButton *latestBtn;
@property (nonatomic, strong) UIView *lineView2;

@end

@implementation TopicDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rankingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rankingBtn.tag = 10;
        self.rankingBtn.backgroundColor = [UIColor clearColor];
        self.rankingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.rankingBtn setTitle:ZFLocalizedString(@"TopicDetailView_Ranking",nil) forState:UIControlStateNormal];
        [self.rankingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rankingBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rankingBtn];
        
        self.latestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.latestBtn.tag = 11;
        self.latestBtn.backgroundColor = [UIColor clearColor];
        self.latestBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.latestBtn setTitle:ZFLocalizedString(@"TopicDetailView_Latest",nil) forState:UIControlStateNormal];
        [self.latestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.latestBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.latestBtn];
        
        //    int padding = 10;
        
        [self.rankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            // 设置其位于父视图的Y的中心位置
            make.centerY.mas_equalTo(self.mas_centerY);
            // 设置其左侧和父视图偏移10个像素
            make.leading.equalTo(self);
            // 设置其右侧和view2偏移10个像素
            make.trailing.equalTo(self.latestBtn.mas_leading);
            // 设置高度
            make.height.mas_equalTo(@40);
            // 设置其宽度
            make.width.equalTo(self.latestBtn);
        }];
        
        [self.latestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.leading.equalTo(self.rankingBtn.mas_trailing);
            make.trailing.equalTo(self);
            make.width.height.mas_equalTo(self.rankingBtn);
        }];
        
        UIView *lineView1 = [UIView new];
        lineView1.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        [self addSubview:lineView1];
        
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_bottom);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            make.height.mas_equalTo(@1);
        }];
        
        self.lineView2 = [UIView new];
        self.lineView2.backgroundColor = ZFCOLOR_BLACK;
        self.lineView2.frame = CGRectMake(0, self.rankingBtn.origin.y + 39, SCREEN_WIDTH / 2, 2);
        [self addSubview:self.lineView2];
        
        NSString *topicSelect = [[NSUserDefaults standardUserDefaults] valueForKey:KTopicKey];
        
        if ([topicSelect isEqualToString:@"0"]) {
            self.lineView2.frame = CGRectMake(![SystemConfigUtils isRightToLeftShow] ? 0 : SCREEN_WIDTH / 2, self.rankingBtn.origin.y + 39, SCREEN_WIDTH / 2, 2);
        }else{
            self.lineView2.frame = CGRectMake(![SystemConfigUtils isRightToLeftShow] ? SCREEN_WIDTH / 2 : 0, self.rankingBtn.origin.y + 39, SCREEN_WIDTH / 2, 2);
        }

    }
    return self;
}

- (void)clickEvent:(UIButton *)sender {
    NSInteger sort;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",(int)sender.tag] forKey:KTopicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (sender.tag == 10) {
        sort = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView2.frame = CGRectMake(![SystemConfigUtils isRightToLeftShow] ? 0 : SCREEN_WIDTH / 2, self.rankingBtn.origin.y + 39, SCREEN_WIDTH / 2, 2);
        }];
    }else{
        sort = 1;
        [UIView animateWithDuration:0.25 animations:^{
            self.lineView2.frame = CGRectMake(![SystemConfigUtils isRightToLeftShow] ? SCREEN_WIDTH / 2 : 0, self.rankingBtn.origin.y + 39, SCREEN_WIDTH / 2, 2);
        }];
    }
    if (self.topicDetailSelectBlock) {
        self.topicDetailSelectBlock(sort);
    }
}

@end
