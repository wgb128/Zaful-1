
//
//  ZFExploreHotVideoCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFExploreHotVideoCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFExploreHotVideoCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView           *hotVideoImageView;
@property (nonatomic, strong) UILabel               *timeLabel;
@end

@implementation ZFExploreHotVideoCell
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
    [self.contentView addSubview:self.hotVideoImageView];
    [self.contentView addSubview:self.timeLabel];
}

- (void)zfAutoLayoutView {
    [self.hotVideoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-4);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-4);
    }];
}

#pragma mark - setter 
- (void)setData:(NSDictionary *)data {
    _data = data;
    [self.hotVideoImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg",data[@"video_url"]]]
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
        _timeLabel.hidden = NO;
        
    }

}

#pragma mark - getter
- (UIImageView *)hotVideoImageView {
    if (!_hotVideoImageView) {
        _hotVideoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _hotVideoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _hotVideoImageView.clipsToBounds = YES;
    }
    return _hotVideoImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden = YES;
        _timeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _timeLabel;
}

@end
