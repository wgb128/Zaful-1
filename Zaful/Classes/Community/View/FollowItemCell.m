//
//  FollowItemCell.m
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "FollowItemCell.h"

@interface FollowItemCell ()

@property (nonatomic, strong) YYAnimatedImageView *icon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *followBtn;

@end

@implementation FollowItemCell

+ (FollowItemCell *)followItemCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerClass:[FollowItemCell class] forCellReuseIdentifier:@"followItemCellId"];
    return [tableView dequeueReusableCellWithIdentifier:@"followItemCellId"];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        
        YYAnimatedImageView *icon = [[YYAnimatedImageView alloc] init];
        icon.contentMode = UIViewContentModeScaleToFill;
        icon.userInteractionEnabled = YES;
        icon.clipsToBounds = YES;
        [self.contentView addSubview:icon];
        _icon = icon;
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
            make.width.height.equalTo(@39);
        }];
        
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.font = [UIFont systemFontOfSize:16];
        nameLab.textColor = ZFCOLOR(51, 51, 51, 1);
        [self.contentView addSubview:nameLab];
        _nameLab = nameLab;
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_icon.mas_trailing).offset(8);
            make.centerY.mas_equalTo(_icon.mas_centerY);
        }];
        
        UIButton *followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        followBtn.layer.cornerRadius = 2;
        followBtn.layer.masksToBounds = YES;
        followBtn.layer.borderWidth = MIN_PIXEL;
        [followBtn addTarget:self action:@selector(followBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        followBtn.layer.borderColor = ZFCOLOR(102, 102, 102, 1).CGColor;
        [followBtn setTitleColor:ZFCOLOR(102, 102, 102, 1) forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"follow"] forState:UIControlStateNormal];
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
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
            make.width.equalTo(@94);
            make.height.equalTo(@26);
            make.centerY.mas_equalTo(_icon.mas_centerY);
        }];
        self.followBtn = followBtn;
        
        UIView *line = [UIView new];
        line.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.leading.mas_equalTo(self.contentView.mas_leading).offset(10);
            make.trailing.mas_equalTo(self.contentView.mas_trailing);
            make.height.mas_equalTo(@(MIN_PIXEL));
        }];
    }
    return self;
}

- (void)followBtnAction:(UIButton *)btn
{
    // 关注或取消关注
    if (_block) {
        _block();
    }
}

- (void)configCellWithFollowItemModel:(FollowItemModel *)model indexPath:(NSIndexPath *)indexPath
{
    [_icon yy_setImageWithURL:[NSURL URLWithString:model.avatar]
               processorKey:NSStringFromClass([self class])
               placeholder:[UIImage imageNamed:@"account"]
               options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
               progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
               transform:^UIImage *(UIImage *image, NSURL *url) {
                   image = [image yy_imageByResizeToSize:CGSizeMake(39, 39) contentMode:UIViewContentModeScaleToFill];
                   return [image yy_imageByRoundCornerRadius:18.5 borderWidth:MIN_PIXEL borderColor:ZFCOLOR(153, 153, 153, 1)];
               }
               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
               }];
    
    _nameLab.text = model.nikename;
    
    if ([USERID isEqualToString: model.userId]) {
        _followBtn.hidden = YES;
    }else{
        if (model.isFollow) {
            _followBtn.hidden = YES;
        }else{
            _followBtn.hidden = NO;
        }
    }
}

@end
