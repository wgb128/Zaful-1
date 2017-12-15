//
//  VideoListCell.m
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoListCell.h"
#import "VideoInfoModel.h"

@interface VideoListCell ()

@property (nonatomic, strong) YYAnimatedImageView *videoImage;

@property (nonatomic, strong) UIView *alphaView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *watchNum;

@end

@implementation VideoListCell

+ (VideoListCell *)videoListCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[VideoListCell class] forCellReuseIdentifier:VIDEO_LIST_CELL_INENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:VIDEO_LIST_CELL_INENTIFIER forIndexPath:indexPath];
}

- (void)setVideoInfoModel:(VideoInfoModel *)videoInfoModel {
    _videoInfoModel = videoInfoModel;
    
    [_videoImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://img.youtube.com/vi/%@/hqdefault.jpg",videoInfoModel.videoUrl]]
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
    
    if (![NSStringUtils isEmptyString:videoInfoModel.videoDesc]) {
        _timeLabel.text = videoInfoModel.videoDesc;
        _alphaView.hidden = NO;
    }
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        _watchNum.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"Community_Little_Views",nil),videoInfoModel.viewNum];
    } else {
        _watchNum.text = [NSString stringWithFormat:@"%@ %@",videoInfoModel.viewNum,ZFLocalizedString(@"Community_Little_Views",nil)];
    }
    
    _titleLabel.text = videoInfoModel.videoTitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.leading.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(10);
        }];
        
        _videoImage = [YYAnimatedImageView new];
        _videoImage.contentMode = UIViewContentModeScaleAspectFill;
        _videoImage.clipsToBounds = YES;
        [self.contentView addSubview:_videoImage];
        
        [_videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).mas_offset(10);
            make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
            make.width.mas_equalTo(159);
        }];
        
        YYAnimatedImageView *playImg = [YYAnimatedImageView new];
        playImg.image = [UIImage imageNamed:@"play"];
        [self.contentView addSubview:playImg];
        
        [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_videoImage.mas_centerX);
            make.centerY.mas_equalTo(_videoImage.mas_centerY);
        }];
        
        _alphaView = [UIView new];
        _alphaView.hidden = YES;
        _alphaView.backgroundColor = ZFCOLOR(0, 0, 0, 0.3);
        [self.contentView addSubview:_alphaView];
        
        [_alphaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_videoImage.mas_leading).mas_offset(5);
            make.bottom.mas_equalTo(_videoImage.mas_bottom).mas_offset(-5);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(14);
        }];
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_alphaView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_alphaView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_videoImage.mas_top).mas_offset(2);
            make.leading.mas_equalTo(_videoImage.mas_trailing).mas_offset(5);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-5);
        }];
        
        YYAnimatedImageView *eyeImg = [YYAnimatedImageView new];
        eyeImg.image = [UIImage imageNamed:@"views"];
        [self.contentView addSubview:eyeImg];
        
        [eyeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_videoImage.mas_bottom).mas_offset(-2);
            make.leading.mas_equalTo(_titleLabel.mas_leading);
        }];
        
        _watchNum = [UILabel new];
        _watchNum.textColor = ZFCOLOR(146, 146, 146, 1.0);
        _watchNum.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_watchNum];
        
        [_watchNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(eyeImg.mas_centerY);
            make.leading.mas_equalTo(eyeImg.mas_trailing).mas_offset(5);
        }];
    }
    return self;
}

@end
