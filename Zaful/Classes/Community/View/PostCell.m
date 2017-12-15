//
//  PostCell.m
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "PostCell.h"
#import "PostModel.h"

@interface PostCell ()
@property (nonatomic,strong) YYAnimatedImageView *goodsImageView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UILabel *priceLable;
//@property (nonatomic,strong) UIButton *selectButton;
@end

@implementation PostCell

- (void)prepareForReuse {
    [self.goodsImageView yy_cancelCurrentImageRequest];
    self.goodsImageView.image = nil;
    self.titleLable.text = nil;
    self.priceLable.text = nil;
    self.selectButton.selected = NO;
}

- (void)setPostModel:(PostModel *)postModel {
    _postModel = postModel;
    [self.goodsImageView yy_setImageWithURL:[NSURL URLWithString:postModel.goodsThumb]
                               processorKey:NSStringFromClass([self class])
                       placeholder:[UIImage imageNamed:@"loading_cat_list"]
                           options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                          }
                         transform:^UIImage *(UIImage *image, NSURL *url) {
                             image = [image yy_imageByResizeToSize:CGSizeMake(50,50) contentMode:UIViewContentModeScaleAspectFit];
                             return image;
                         }
                        completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                            if (from == YYWebImageFromDiskCache) {
                            }
                        }];
    self.titleLable.text = postModel.goodsTitle;
    self.priceLable.text = [ExchangeManager transforPrice:postModel.goodsPrice];
    self.selectButton.selected = postModel.isSelected;
    if (self.selectButton.selected) {
        [self.selectButton setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateNormal];
    }else{
        [self.selectButton setImage:[UIImage imageNamed:@"unselect"]  forState:UIControlStateNormal];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.goodsImageView = [YYAnimatedImageView new];
        self.goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.goodsImageView];
        [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        self.titleLable = [UILabel new];
        self.titleLable.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        self.titleLable.font = [UIFont systemFontOfSize:12];
        self.titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleLable];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(17);
            make.leading.equalTo(self.goodsImageView.mas_trailing).offset(10);
            make.trailing.equalTo(self.contentView).offset(-60);
            make.height.mas_equalTo(12);
            
        }];
        
        self.priceLable = [UILabel new];
        self.priceLable.textColor = ZFCOLOR(51, 51, 51, 1.0);
        self.priceLable.textAlignment = NSTextAlignmentLeft;
        self.priceLable.font = [UIFont systemFontOfSize:12];
        self.priceLable.lineBreakMode = NSLineBreakByTruncatingTail;
        self.priceLable.text = @"$102.13";
        [self.contentView addSubview:self.priceLable];
        [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.goodsImageView.mas_trailing).offset(12);
            make.bottom.equalTo(self.contentView).offset(-16);
            make.trailing.equalTo(self.contentView).offset(-60);
            make.height.mas_equalTo(12);
        }];
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectButton setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        [self.selectButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self.contentView).offset(15);
            make.trailing.equalTo(self.contentView).offset(-5);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)click:(UIButton *)sender
{
    if (self.changeCountBlock) {
        if (self.changeCountBlock(sender.selected)) {
            sender.selected = !sender.selected;
            if (sender.isSelected) {
                [sender setImage:[UIImage imageNamed:@"select_icon"] forState:UIControlStateNormal];
                [UIButton showOscillatoryAnimationWithLayer:sender.layer type:YSOscillatoryAnimationToBigger];
            }else{
                [sender setImage:[UIImage imageNamed:@"unselect"]  forState:UIControlStateNormal];
            }
            self.postModel.isSelected = sender.selected;
        }
    }
}

@end
