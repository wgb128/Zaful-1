
//
//  ZFCommunityMoreHotVideoListCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMoreHotVideoListCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityMoreHotVideoModel.h"


@interface ZFCommunityMoreHotVideoListCell () <ZFInitViewProtocol>

@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) UIImageView           *videoImageView;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UILabel               *timeLabel;
@property (nonatomic, strong) UIImageView           *playImageView;
@property (nonatomic, strong) UIImageView           *videoIconView;
@property (nonatomic, strong) UILabel               *viewsLabel;

@end

@implementation ZFCommunityMoreHotVideoListCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.videoImageView];
    [self.contentView addSubview:self.playImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.videoIconView];
    [self.contentView addSubview:self.viewsLabel];
}

- (void)zfAutoLayoutView {
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView.mas_bottom).mas_offset(10);
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(159);
        make.height.mas_equalTo(120);
    }];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.videoImageView.mas_centerX);
        make.centerY.mas_equalTo(self.videoImageView.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.videoImageView.mas_leading).mas_offset(5);
        make.bottom.mas_equalTo(self.videoImageView.mas_bottom).mas_offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 14));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.videoImageView.mas_top).mas_offset(2);
        make.leading.mas_equalTo(self.videoImageView.mas_trailing).mas_offset(5);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-5);
    }];
    
    [self.videoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.videoImageView.mas_bottom).mas_offset(-2);
        make.leading.mas_equalTo(self.titleLabel.mas_leading);
    }];
    
    [self.viewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.videoIconView.mas_centerY);
        make.leading.mas_equalTo(self.videoIconView.mas_trailing).mas_offset(5);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunityMoreHotVideoModel *)model {
    _model = model;
    [self.videoImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg",_model.videoUrl]]
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
    
    if (![NSStringUtils isEmptyString:_model.videoDesc]) {
        self.timeLabel.text = _model.videoDesc;
        self.timeLabel.hidden = NO;
    }
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.viewsLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"Community_Little_Views",nil),_model.viewNum];
    } else {
        self.viewsLabel.text = [NSString stringWithFormat:@"%@ %@",_model.viewNum,ZFLocalizedString(@"Community_Little_Views",nil)];
    }
    
    self.titleLabel.text = _model.videoTitle;
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    }
    return _lineView;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds = YES;
    }
    return _videoImageView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playImageView.image = [UIImage imageNamed:@"play"];
        
    }
    return _playImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = ZFCOLOR_WHITE;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden = YES;
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)videoIconView {
    if (!_videoIconView) {
        _videoIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoIconView.image = [UIImage imageNamed:@"views"];
    }
    return _videoIconView;
}

- (UILabel *)viewsLabel {
    if (!_viewsLabel) {
        _viewsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _viewsLabel.textColor = ZFCOLOR(146, 146, 146, 1.0);
        _viewsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _viewsLabel;
}

@end
