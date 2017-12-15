//
//  FavesCommendHeadView.m
//  Zaful
//
//  Created by zhaowei on 2017/1/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FavesCommendHeadView.h"

@interface FavesCommendHeadView ()
@property (nonatomic,weak) UIView *commendView;

@property (nonatomic,weak) UIView *blackView;
@property (nonatomic,weak) UILabel *titleLabel;
@end

@implementation FavesCommendHeadView

+ (FavesCommendHeadView *)favesCommendHeadViewWithTableView:(UITableView *)tableView {
    [tableView registerClass:[FavesCommendHeadView class]  forHeaderFooterViewReuseIdentifier:NSStringFromClass([FavesCommendHeadView class])];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([FavesCommendHeadView class])];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *commendView = [UIView new];
        commendView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:commendView];
        [commendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        self.commendView = commendView;
        
        UIView *blackView = [UIView new];
        blackView.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [commendView addSubview:blackView];
        [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.mas_equalTo(commendView);
            make.width.mas_equalTo(@3);
        }];
        self.blackView = blackView;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        titleLabel.text = ZFLocalizedString(@"FavesCommendHeadView_RecommendUp",nil);
        [commendView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(blackView.mas_trailing).offset(16);
            make.centerY.mas_equalTo(blackView.mas_centerY);
            make.top.mas_equalTo(blackView.mas_top).offset(10);
            make.bottom.mas_equalTo(blackView.mas_bottom).offset(-10);
        }];
        self.titleLabel = titleLabel;
    }
    return self;
}

@end
