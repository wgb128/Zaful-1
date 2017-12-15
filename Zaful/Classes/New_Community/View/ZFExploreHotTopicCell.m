//
//  ZFExploreHotTopicCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFExploreHotTopicCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFExploreHotTopicCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView       *topicImageView;
@end

@implementation ZFExploreHotTopicCell
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.topicImageView];
}

- (void)zfAutoLayoutView {
    [self.topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - setter
- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [self.topicImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"ios_indexpic"]]]
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


#pragma mark - getter
- (UIImageView *)topicImageView {
    if (!_topicImageView) {
        _topicImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topicImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topicImageView.clipsToBounds = YES;
    }
    return _topicImageView;
}

@end
