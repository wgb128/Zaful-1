//
//  HomeGoodsHeadView.m
//  Zaful
//
//  Created by Y001 on 16/9/18.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeGoodsHeadView.h"

@interface  HomeGoodsHeadView()

@end

@implementation HomeGoodsHeadView
+ (HomeGoodsHeadView *)homeGoodsHeadViewWithCollectionView:(UICollectionView *)collectionView Kind:(NSString *)kind IndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[HomeGoodsHeadView class] forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([self class])];
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundColor:[UIColor whiteColor]];
        //title
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(18);
            make.leading.trailing.mas_offset(0);
            make.height.mas_offset(30);
        }];
    }
    return self;
}

#pragma mark - 懒加载

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
