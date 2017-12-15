//
//  PostPhotoCell.m
//  Zaful
//
//  Created by TsangFa on 16/11/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostPhotoCell.h"

@interface PostPhotoCell ()
@property (nonatomic,strong) YYAnimatedImageView *photoView;
@property (nonatomic,strong) UIButton *deleteButton;
@end

@implementation PostPhotoCell

+ (PostPhotoCell *)postPhotoCellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[PostPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([PostPhotoCell class])];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PostPhotoCell class]) forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _photoView = [[YYAnimatedImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        _photoView.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoView];
        [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.edges.equalTo(self.contentView);
        }];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_photoView addSubview:_deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(_photoView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];

    }
    return self;
}

-(void)setPhoto:(UIImage *)photo {
    self.contentView.backgroundColor = [UIColor whiteColor];
    _photo = photo;
    self.photoView.image = photo;
    BOOL isHidden = [photo isEqual:[UIImage imageNamed:@"add_photo"]];
    self.deleteButton.hidden = isHidden ? YES :NO;
    self.photoView.hidden = self.isNeedHiddenAddView ? YES : NO;
}

- (void)deletePhoto:(UIButton *)sender {
    if (self.deletePhotoBlock) {
        self.deletePhotoBlock(self.photo);
    }
}

- (void)prepareForReuse {
    self.photoView.image = nil;
    self.photoView.hidden = NO;
    self.deleteButton.hidden = NO;
}

@end
