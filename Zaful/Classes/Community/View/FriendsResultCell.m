//
//  FriendsResultCell.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//  搜索用户结果CELL

#import "FriendsResultCell.h"
#import "FriendsResultModel.h"

@interface FriendsResultCell ()
@property (nonatomic,weak) YYAnimatedImageView *iconView;
@property (nonatomic,weak) UILabel *nickLabel;
@property (nonatomic,weak) UILabel *postsLabel;
@property (nonatomic,weak) UILabel *likesLabel;
@property (nonatomic,weak) UIButton *followBtn;
@property (nonatomic,weak) UIView *lineView;
@end

@implementation FriendsResultCell

+ (FriendsResultCell *)friendsResultCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[FriendsResultCell class] forCellReuseIdentifier:NSStringFromClass([FriendsResultCell class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendsResultCell class]) forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        YYAnimatedImageView *iconView = [YYAnimatedImageView new];
        iconView.contentMode = UIViewContentModeScaleToFill;
        iconView.userInteractionEnabled = YES;
        iconView.clipsToBounds = YES;
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(15);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
            make.width.height.mas_offset(39);
        }];
        self.iconView = iconView;
        
        UILabel *nickLabel = [UILabel new];
        nickLabel.font = [UIFont systemFontOfSize:16];
        nickLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        [self.contentView addSubview:nickLabel];
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(iconView.mas_trailing).offset(8);
            make.bottom.mas_equalTo(iconView.mas_centerY).offset(-2);
            make.trailing.mas_offset(-115);
        }];
        self.nickLabel = nickLabel;
        
        UILabel *postsLabel = [UILabel new];
        postsLabel.font = [UIFont systemFontOfSize:12];
        postsLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        [self.contentView addSubview:postsLabel];
        [postsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(nickLabel.mas_leading);
            make.top.mas_equalTo(iconView.mas_centerY).offset(2);
        }];
        self.postsLabel = postsLabel;
        
        UILabel *likesLabel = [UILabel new];
        likesLabel.font = [UIFont systemFontOfSize:12];
        likesLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        [self.contentView addSubview:likesLabel];
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
        [self.contentView addSubview:followBtn];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(@26);
            make.width.mas_equalTo(@94);
        }];
        self.followBtn = followBtn;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = ZFCOLOR(212, 212, 212, 1.0);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(lineView.mas_bottom);
            make.leading.mas_equalTo(nickLabel.mas_leading);
            make.trailing.mas_equalTo(lineView.mas_trailing);
            make.height.mas_equalTo(MIN_PIXEL);
        }];
        self.lineView = lineView;
    }
    return self;
}

- (void)clickEvent:(UIButton*)sender {
    if (self.clickEventBlock) {
        self.clickEventBlock();
    }
}

- (void)setFriendsResultModel:(FriendsResultModel *)friendsResultModel {
    _friendsResultModel = friendsResultModel;
    [self.iconView yy_setImageWithURL:[NSURL URLWithString:friendsResultModel.avatar]
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
    self.nickLabel.text = friendsResultModel.nick_name;
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",friendsResultModel.review_total,ZFLocalizedString(@"FriendsResultCell_Posts",nil)];
        self.likesLabel.text = [NSString stringWithFormat:@"%@ %@",friendsResultModel.likes_total,ZFLocalizedString(@"FriendsResultCell_BeLiked",nil)];
    } else {
        self.postsLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"FriendsResultCell_Posts",nil),friendsResultModel.review_total];
        self.likesLabel.text = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"FriendsResultCell_BeLiked",nil),friendsResultModel.likes_total];
    }
    
    if (friendsResultModel.isFollow || [USERID isEqualToString:friendsResultModel.user_id]) {
        _followBtn.hidden = YES;
    }else{
        _followBtn.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
