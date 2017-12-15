//
//  RecommendGoods.m
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "RecommendGoods.h"
#import "GoodsDetailViewController.h"

@interface RecommendGoods ()

@property (nonatomic, strong) YYAnimatedImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pricelLabel;

@end

@implementation RecommendGoods

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZFCOLOR_WHITE;
        
        _iconImg = [YYAnimatedImageView new];
        _iconImg.backgroundColor = ZFCOLOR_RANDOM;
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.clipsToBounds = YES;
        [self addSubview:_iconImg];
        
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-5);
            make.leading.mas_equalTo(self.mas_leading).mas_offset(5);
            make.width.height.mas_equalTo(80);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_iconImg.mas_trailing).mas_offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-20);
            make.top.mas_equalTo(self.mas_top).mas_offset(10);
        }];
        
        _pricelLabel = [UILabel new];
        _pricelLabel.text = @"$79.0";
        _pricelLabel.font = [UIFont systemFontOfSize:12];
        _pricelLabel.textColor = ZFCOLOR(255, 111, 0, 1.0);
        [self addSubview:_pricelLabel];
        
        [_pricelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_titleLabel.mas_leading);
            make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(20);
        }];
        
        UITapGestureRecognizer *tapCurrentVIew = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCurrentVIew:)];
        [self addGestureRecognizer:tapCurrentVIew];
    }
    return self;
}

- (void)tapCurrentVIew:(UITapGestureRecognizer*)sender {
    GoodsDetailViewController *detail = [GoodsDetailViewController new];
//    detail.goodsId = @"1234";
    [self.controller.navigationController pushViewController:detail animated:YES];
}

@end
