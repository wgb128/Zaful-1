//
//  HotTopicCell.m
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HotTopicCell.h"

@interface HotTopicCell ()

@property (nonatomic, strong) YYAnimatedImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HotTopicCell

+ (HotTopicCell *)hotTopicCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[HotTopicCell class] forCellWithReuseIdentifier:HOTTOPIC_CELL];
    return [collectionView dequeueReusableCellWithReuseIdentifier:HOTTOPIC_CELL forIndexPath:indexPath];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [_imageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"ios_indexpic"]]]
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
}

@end
