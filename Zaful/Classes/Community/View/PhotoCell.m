//
//  PhotoCell.m
//  post
//
//  Created by TsangFa on 16/7/12.
//  Copyright © 2016年 TsangFa. All rights reserved.
//

#import "PhotoCell.h"

@interface PhotoCell()

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        _photoView = [[YYAnimatedImageView alloc] init];
        _photoView.userInteractionEnabled = YES;
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_photoView];
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
       [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_photoView.mas_top).offset(-3);
            make.trailing.mas_equalTo(_photoView.mas_trailing);
        }];
    }
    return self;
}

@end
