//
//  CommendUserCell.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CommendUserCell.h"
#import "CommendUserModel.h"
#import "YYPhotoBrowseView.h"

@interface CommendUserCell ()
@property (nonatomic,weak) UIView *topView;
@property (nonatomic,weak) YYAnimatedImageView *iconView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *postsLabel;
@property (nonatomic,weak) UILabel *likesLabel;
@property (nonatomic,weak) UIButton *followBtn;
@property (nonatomic,weak) UIView *bottomView;
@property (nonatomic,strong) NSMutableArray *pictureArray;
@end

@implementation CommendUserCell

+ (CommendUserCell *)commendUserCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[CommendUserCell class] forCellReuseIdentifier:NSStringFromClass([CommendUserCell class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommendUserCell class]) forIndexPath:indexPath];
}

- (void)prepareForReuse {
    self.pictureArray = nil;
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [obj removeFromSuperview];
    }];
    [self.iconView yy_cancelCurrentImageRequest];
    self.iconView.image = nil;
    self.nickLabel.text = nil;
    self.postsLabel.text = nil;
    self.likesLabel.text = nil;
}

- (NSMutableArray*)pictureArray {
    if (!_pictureArray) {
        _pictureArray = [[NSMutableArray alloc] init];
    }
    return _pictureArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *topView = [UIView new];
        [self.contentView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(self.contentView);
        }];
        self.topView = topView;
        
        YYAnimatedImageView *iconView = [YYAnimatedImageView new];
        iconView.contentMode = UIViewContentModeScaleToFill;
        iconView.clipsToBounds = YES;
        [topView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topView.mas_top).offset(28);
            make.bottom.mas_equalTo(topView.mas_bottom).offset(-16);
            make.leading.mas_equalTo(topView.mas_leading).offset(16);
            make.width.height.mas_offset(39);

        }];
        self.iconView = iconView;
        
        UILabel *nickLabel = [UILabel new];
        nickLabel.font = [UIFont systemFontOfSize:16];
        nickLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [topView addSubview:nickLabel];
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconView.mas_trailing).offset(10);
            make.bottom.mas_equalTo(iconView.mas_centerY).offset(-2);
        }];
        self.nickLabel = nickLabel;
        
        UILabel *postsLabel = [UILabel new];
        postsLabel.font = [UIFont systemFontOfSize:12];
        postsLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        [topView addSubview:postsLabel];
        [postsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(nickLabel.mas_leading);
            make.top.mas_equalTo(iconView.mas_centerY).offset(2);
        }];
        self.postsLabel = postsLabel;
        
        UILabel *likesLabel = [UILabel new];
        likesLabel.font = [UIFont systemFontOfSize:12];
        likesLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        [topView addSubview:likesLabel];
        [likesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(postsLabel.mas_trailing).offset(10);
            make.centerY.mas_equalTo(postsLabel.mas_centerY);
        }];
        self.likesLabel = likesLabel;
        
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        followBtn.layer.borderWidth = 1;
        followBtn.layer.cornerRadius = 2;
        followBtn.layer.masksToBounds = YES;
        [followBtn addTarget:self action:@selector(clickEvent:) forControlEvents:UIControlEventTouchUpInside];
        followBtn.layer.borderColor = ZFCOLOR(255, 168, 0, 1).CGColor;
        [followBtn setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"style_follow"] forState:UIControlStateNormal];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [followBtn setTitle:[NSString stringWithFormat:@"%@  ",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
            followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        } else {
            [followBtn setTitle:[NSString stringWithFormat:@"  %@",ZFLocalizedString(@"Community_Follow",nil)] forState:UIControlStateNormal];
            followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        }
        [topView addSubview:followBtn];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(topView.mas_trailing).offset(-16);
            make.centerY.mas_equalTo(iconView.mas_centerY).offset(-10);
            make.height.mas_equalTo(@26);
            make.width.mas_equalTo(@94);
        }];
        self.followBtn = followBtn;
        
        UIView *bottomView = [UIView new];
        [self.contentView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.contentView);
            make.top.mas_equalTo(iconView.mas_bottom);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-28);
        }];
        self.bottomView = bottomView;
        
    }
    return self;
}

- (void)clickEvent:(UIButton*)sender {
    if (self.clickEventBlock) {
        self.clickEventBlock();
    }
}

- (void)setCommendUserModel:(CommendUserModel *)commendUserModel {
    _commendUserModel = commendUserModel;
    
    
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:commendUserModel.avatar]
                                processorKey:NSStringFromClass([self class])
                                 placeholder:[UIImage imageNamed:@"index_cat_loading"]
                                     options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                   transform:^UIImage *(UIImage *image, NSURL *url) {
                                       image = [image yy_imageByResizeToSize:CGSizeMake(39,39) contentMode:UIViewContentModeScaleToFill];
                                       return [image yy_imageByRoundCornerRadius:18.5];

                                   }
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                  }];
    self.nickLabel.text = commendUserModel.nickname;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",commendUserModel.review_total,ZFLocalizedString(@"CommendUserCell_Posts",nil)];
        self.likesLabel.text = [NSString stringWithFormat:@"%@ %@",commendUserModel.likes_total,ZFLocalizedString(@"CommendUserCell_BeLiked",nil)];
    } else {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"CommendUserCell_Posts",nil),commendUserModel.review_total];
        self.likesLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"CommendUserCell_BeLiked",nil),commendUserModel.likes_total];
    }
    
    
    if (commendUserModel.isFollow) {
        _followBtn.hidden = YES;
    }else{
        _followBtn.hidden = NO;
    }
    
    if (commendUserModel.postlist.count > 1) {
    
        [commendUserModel.postlist enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = ZFCOLOR(241, 241, 241, 1.0).CGColor;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            NSString *img = [[commendUserModel.postlist objectAtIndex:idx] valueForKey:@"pic"];
            [imageView yy_setImageWithURL:[NSURL URLWithString:img]
                             processorKey:NSStringFromClass([self class])
                              placeholder:nil
                                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 }
                                transform:^UIImage *(UIImage *image, NSURL *url) {
                                    return image;
                                }
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                   if (from == YYWebImageFromDiskCache) {
                                   }
                               }];
            [self.bottomView addSubview:imageView];
            [self.pictureArray addObject:imageView];
        }];
        
        [self.pictureArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:16 tailSpacing:16];
        [self.pictureArray mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bottomView.mas_centerY);
            make.top.mas_equalTo(self.bottomView.mas_top).offset(16);
            make.bottom.mas_equalTo(self.bottomView.mas_bottom);
            make.width.height.mas_equalTo((SCREEN_WIDTH - 47)/4);
        }];
        [self.bottomView layoutIfNeeded];
    } else if (commendUserModel.postlist.count == 1) {
        
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
        [imageView yy_setImageWithURL:[NSURL URLWithString:[[commendUserModel.postlist firstObject] valueForKey:@"pic"]]
                         processorKey:NSStringFromClass([self class])
                          placeholder:nil
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                               }
                           }];
        
        [self.bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(self.bottomView).offset(16);
            make.bottom.mas_equalTo(self.bottomView.mas_bottom);
            make.trailing.mas_equalTo(self.bottomView.mas_trailing).offset(-16);
            make.width.height.mas_equalTo((SCREEN_WIDTH - 47)/4);
        }];
    }
}

@end
