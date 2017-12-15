//
//  HomeCategoryCell.m
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeCategoryCell.h"

@interface HomeCategoryCell ()

@property (nonatomic, strong) YYAnimatedImageView * backImg;
@property (nonatomic, strong) UILabel     * nameLabel;

@end

@implementation HomeCategoryCell
+ (HomeCategoryCell *)homeCategoryCollectionViewWith:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[HomeCategoryCell class]  forCellWithReuseIdentifier:NSStringFromClass([self class])];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //图片
        [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.mas_offset(0);
        }];
    }
    return self;
}

- (void)setHomeCategoryBanner:(BannerModel *)homeCategoryBanner
{
    _homeCategoryBanner = homeCategoryBanner;
    [self.backImg yy_setImageWithURL:[NSURL URLWithString:_homeCategoryBanner.image]
                        processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"index_cat_loading"]
                             options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           transform:^UIImage *(UIImage *image, NSURL *url) {
                               return image;
                           }
                          completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {

                          }];
    
        _nameLabel.text = _homeCategoryBanner.title;
}

#pragma mark - 懒加载
- (UIImageView *)backImg
{
    if (_backImg == nil) {
        _backImg = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
         [_backImg setUserInteractionEnabled:YES];
        UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backImgClick:)];
        
        [_backImg addGestureRecognizer:gest];
        
        [self.contentView addSubview:_backImg];
    }
    return _backImg;
}

- (void)backImgClick:(UIGestureRecognizer * )gest{
    
    if (self.homeCategoryBannerClick) {
        _homeCategoryBannerClick(_homeCategoryBanner);
    }
}


@end
