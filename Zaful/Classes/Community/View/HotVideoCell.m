//
//  HotVideoCell.m
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HotVideoCell.h"

@interface HotVideoCell ()

@property (nonatomic, strong) YYAnimatedImageView *imageView;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation HotVideoCell

+ (HotVideoCell *)hotVideoCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[HotVideoCell class] forCellWithReuseIdentifier:HOTVIDEO_CELL];
    return [collectionView dequeueReusableCellWithReuseIdentifier:HOTVIDEO_CELL forIndexPath:indexPath];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg",data[@"video_url"]]]
                         processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"index_loading"]
                         options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                         transform:^UIImage *(UIImage *image, NSURL *url) {
                             return image;
                         }
                         completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                            if (from == YYWebImageFromDiskCache) { }
                        }];
    
    if (![NSStringUtils isEmptyString:data[@"duration"]]) {
        _timeLabel.text = data[@"duration"];
        _alphaView.hidden = NO;

    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = ZFCOLOR_WHITE;
        [self initView];
    }
    return self;
}

- (void) initView {
    _imageView = [YYAnimatedImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    YYAnimatedImageView *playImg = [YYAnimatedImageView new];
    playImg.image = [UIImage imageNamed:@"play"];
    [self.contentView addSubview:playImg];
    
    [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    _alphaView = [UIView new];
    _alphaView.hidden = YES;
    _alphaView.backgroundColor = ZFCOLOR(0, 0, 0, 0.3);
    [self.contentView addSubview:_alphaView];

    
    [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
    }];
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_alphaView addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_alphaView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

@end

