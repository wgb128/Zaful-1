
//
//  HomeSpecialCell.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeSpecialCell.h"
#import "BannerModel.h"

@interface HomeSpecialCell()

@property (nonatomic, strong) YYAnimatedImageView * bannerImageView;

@end

@implementation HomeSpecialCell
+ (HomeSpecialCell *)homeSpecialCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[HomeSpecialCell class]  forCellWithReuseIdentifier:NSStringFromClass([self class])];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ZFCOLOR_WHITE;
        //添加约束
        [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.mas_offset(0);
        }];
        
    }
    return self;
}

/**
 *  赋值
 *
 *  @param homeBannerModel <#homeBannerModel description#>
 */
- (void) setHomeBannerModel:(BannerModel *)homeBannerModel
{
    _homeBannerModel = homeBannerModel;
    [self.bannerImageView yy_setImageWithURL:[NSURL URLWithString:homeBannerModel.image]
                         processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"index_loading"]
                              options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            transform:^UIImage *(UIImage *image, NSURL *url) {
                                return image;
                            }
                           completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                               if (from == YYWebImageFromDiskCache) {
                                   ZFLog(@"load from disk cache");
                               }
                           }];
    
}

/**
 *  点击图片的事件
 *
 *  @param gest <#gest description#>
 */
- (void)bannerImageViewClick:(UIGestureRecognizer *)gest
{
    if (self.specialClick) {
        _specialClick(_homeBannerModel);
    }
}

#pragma mark - 懒加载
- (YYAnimatedImageView *)bannerImageView
{
    if (_bannerImageView == nil) {
        _bannerImageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
        UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bannerImageViewClick:)];
        [_bannerImageView addGestureRecognizer:gest];
        
        [_bannerImageView setUserInteractionEnabled:YES];
        
        [self.contentView addSubview:_bannerImageView];
    }
    return _bannerImageView;
}

@end
