//
//  SearchResultHeadView.m
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SearchResultHeadView.h"

@interface  SearchResultHeadView ()
@property (nonatomic, strong)  UIButton    * sortBtn;         //筛选条件的按钮
@end

@implementation SearchResultHeadView

+ (SearchResultHeadView *)SearchResultHeadWithCollectionView:(UICollectionView *)collectionView Kind:(NSString *)kind IndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerClass:[SearchResultHeadView class] forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([self class])];
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
        //筛选的图标
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn setTitle:ZFLocalizedString(@"Search_ResultHeadView_Sort", nil) forState:UIControlStateNormal];
        [_sortBtn.layer setBorderColor:[ZFCOLOR(221, 221, 221, 1.0) CGColor]];
        [_sortBtn.layer setBorderWidth:0.5];
        [_sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sortBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_sortBtn addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sortBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_sortBtn];
        
        [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.height.equalTo(@44);
            make.width.equalTo(@182);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}


/**
 *  sort按钮的点击事件
 *
 *  @param button <#button description#>
 */
- (void)sortClick:(UIButton *)button
{
    if (self.sortClick) {
        _sortClick();
    }
}
@end
