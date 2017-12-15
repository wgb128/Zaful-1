//
//  RecommendGoods.m
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "RecommendCell.h"

@interface RecommendCell ()

@property (nonatomic, strong) UIView *border;//边框
@property (nonatomic, strong) YYAnimatedImageView *iconImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pricelLabel;

@end

@implementation RecommendCell

+ (RecommendCell *)recommendCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[RecommendCell class] forCellReuseIdentifier:VIDEO_RECOMMEND_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:VIDEO_RECOMMEND_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [_iconImg yy_setImageWithURL:[NSURL URLWithString:data[@"pic_url"]]
                     processorKey:NSStringFromClass([self class])
                     placeholder:[UIImage imageNamed:@"loading_product"]
                     options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                     progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                     transform:^UIImage *(UIImage *image, NSURL *url) {
                         return image;
                     }
                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                    }];
    
    _titleLabel.text = data[@"description"];
    
    _pricelLabel.text = [ExchangeManager transforPrice:data[@"price"]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        
        _border = [UIView new];
        _border.backgroundColor = ZFCOLOR_WHITE;
        
        /*
         *
         *  加上阴影效果后cell有轻微的卡顿
         *
         */
//        _border.layer.shadowOffset = CGSizeMake(0.0f, 0.5f);
//        _border.layer.shadowOpacity = 0.2f;
//        _border.layer.shadowRadius = 1.5f;
//        _border.layer.shadowColor = [[UIColor blackColor] CGColor];
        
        [self.contentView addSubview:_border];
        
        [_border mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 10, 10));
        }];
        
        _iconImg = [YYAnimatedImageView new];
        _iconImg.contentMode = UIViewContentModeScaleAspectFill;
        _iconImg.clipsToBounds = YES;
        [_border addSubview:_iconImg];
        
        [_iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_border.mas_top).mas_offset(10);
            make.bottom.mas_equalTo(_border.mas_bottom).mas_offset(-10);
            make.leading.mas_equalTo(_border.mas_leading).mas_offset(10);
            make.width.height.mas_equalTo(84);
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        [_border addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_iconImg.mas_trailing).mas_offset(10);
            make.trailing.mas_equalTo(_border.mas_trailing).mas_offset(-40);
            make.top.mas_equalTo(_iconImg.mas_top).mas_offset(2);
        }];
        
        _pricelLabel = [UILabel new];
        _pricelLabel.font = [UIFont systemFontOfSize:18];
        _pricelLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);
        [_border addSubview:_pricelLabel];
        
        [_pricelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_titleLabel.mas_leading);
            make.bottom.mas_equalTo(_iconImg.mas_bottom).mas_offset(-2);
        }];
        
        YYAnimatedImageView *nextImg = [YYAnimatedImageView new];
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            nextImg.image = [UIImage imageNamed:@"detail_left_arrow"];
        } else {
            nextImg.image = [UIImage imageNamed:@"detail_right_arrow"];
        }
        
        [_border addSubview:nextImg];
        
        [nextImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_border.mas_centerY);
            make.trailing.mas_equalTo(_border.mas_trailing).mas_offset(-20);
        }];
        
        UITapGestureRecognizer *tapCurrentVIew = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCurrentVIew:)];
        [self addGestureRecognizer:tapCurrentVIew];
    }
    return self;
}

- (void)tapCurrentVIew:(UITapGestureRecognizer*)sender {
    if (self.jumpBlock) {
        self.jumpBlock();
    }
}

@end
