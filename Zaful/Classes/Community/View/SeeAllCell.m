//
//  SeeAllCell.m
//  Zaful
//
//  Created by huangxieyue on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SeeAllCell.h"

@interface SeeAllCell ()

@property (nonatomic, strong) UIButton *seeAllBtn;

@end

@implementation SeeAllCell

+ (SeeAllCell *)seeAllCellWithCollectionView:(UICollectionView *)collectionView IndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[SeeAllCell class] forCellWithReuseIdentifier:SEEALL_CELL];
    return [collectionView dequeueReusableCellWithReuseIdentifier:SEEALL_CELL forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = ZFCOLOR_WHITE;
        [self initView];
    }
    return self;
}

- (void) initView {
    _seeAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeAllBtn addTarget:self action:@selector(seeAllTouch:) forControlEvents:UIControlEventTouchUpInside];
    _seeAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_seeAllBtn setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
    [_seeAllBtn setTitle:ZFLocalizedString(@"SeeAllCell_SeeAll",nil) forState:UIControlStateNormal];
    _seeAllBtn.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    [self.contentView addSubview:_seeAllBtn];
    
    [_seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(90);
    }];
}

- (void)seeAllTouch:(UIButton*)sender {
    if (self.seeAllBlock) {
        self.seeAllBlock();
    }
}

@end
