//
//  CommunityDetailGoodsView.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CommunityDetailGoodsView.h"
#import "GoodsInfosModel.h"
#import "ZFGoodsDetailViewController.h"

@interface CommunityDetailGoodsView ()

@property (nonatomic, weak) UIView *border;//边框
@property (nonatomic, weak) YYAnimatedImageView *iconImg;//商品图片
@property (nonatomic, weak) UILabel *goodsTitle;//商品名称
@property (nonatomic, weak) UILabel *goodsPricel;//商品价格
@property (nonatomic, weak) YYAnimatedImageView *nextImg;//跳转商品详情

@end

@implementation CommunityDetailGoodsView

- (void)setInfoModel:(GoodsInfosModel *)infoModel {
    _infoModel = infoModel;
    
    [self.iconImg yy_setImageWithURL:[NSURL URLWithString:infoModel.goodsImg]
                          processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"loading_product"]
                          options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                          transform:^UIImage *(UIImage *image, NSURL *url) {
                              image = [image yy_imageByResizeToSize:CGSizeMake(84,84) contentMode:UIViewContentModeScaleAspectFit];
                              return image;
                          }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                          }];
    
    self.goodsTitle.text = infoModel.goodsTitle;
    
    self.goodsPricel.text = [ExchangeManager transforPrice:infoModel.shopPrice];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        __weak typeof(self) ws = self;
        
        ws.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        
        UIView *border = [UIView new];
        border.userInteractionEnabled = YES;
        border.backgroundColor = ZFCOLOR_WHITE;
        [ws addSubview:border];
        
        [border mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(ws).insets(UIEdgeInsetsMake(10, 10, 0, 10));
        }];
        self.border = border;
        
        YYAnimatedImageView *iconImg = [YYAnimatedImageView new];
        iconImg.contentMode = UIViewContentModeScaleAspectFit;
        iconImg.clipsToBounds = YES;
        [border addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(border.mas_top).mas_offset(10);
            make.bottom.mas_equalTo(border.mas_bottom).mas_offset(-10);
            make.leading.mas_equalTo(border.mas_leading).mas_offset(10);
            make.width.height.mas_equalTo(84);
        }];
        self.iconImg = iconImg;
        
        UILabel *goodsTitle = [UILabel new];
        goodsTitle.numberOfLines = 2;
        goodsTitle.font = [UIFont systemFontOfSize:14];
        goodsTitle.textColor = [UIColor blackColor];
        [border addSubview:goodsTitle];
        
        [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconImg.mas_trailing).mas_offset(10);
            make.trailing.mas_equalTo(border.mas_trailing).mas_offset(-25);
            make.top.mas_equalTo(border.mas_top).mas_offset(17);
        }];
        self.goodsTitle = goodsTitle;
        
        UILabel *goodsPricel = [UILabel new];
        goodsPricel.font = [UIFont systemFontOfSize:18];
        goodsPricel.textColor = ZFCOLOR(255, 111, 0, 1.0);
        [border addSubview:goodsPricel];
        
        [goodsPricel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(goodsTitle.mas_leading);
            make.bottom.mas_equalTo(border.mas_bottom).mas_offset(-15);
        }];
        self.goodsPricel = goodsPricel;
        
        YYAnimatedImageView *nextImg = [YYAnimatedImageView new];
        nextImg.image = [UIImage imageNamed:@"next"];
        [border addSubview:nextImg];
        
        [nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(border.mas_centerY);
            make.trailing.mas_equalTo(border.mas_trailing).mas_offset(-10);
        }];
        self.nextImg = nextImg;
        
        UITapGestureRecognizer *tapGoods = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGoods:)];
        [border addGestureRecognizer:tapGoods];
    }
    return self;
}

- (void)tapGoods:(UITapGestureRecognizer*)sender {
    ZFGoodsDetailViewController *detailVC = [ZFGoodsDetailViewController new];
    detailVC.goodsId = self.infoModel.goodsId;
    [self.controller.navigationController pushViewController:detailVC animated:YES];
}

@end
