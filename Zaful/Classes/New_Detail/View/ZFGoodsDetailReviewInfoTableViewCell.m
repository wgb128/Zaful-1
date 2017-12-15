
//
//  ZFGoodsDetailReviewInfoTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/11/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailReviewInfoTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFGoodsReviewStarsView.h"
#import "ZFReviewImageCollectionViewCell.h"
#import "GoodsDetailFirstReviewImgListModel.h"
#import "UICollectionViewLeftAlignedLayout.h"

static NSString *const kZFReviewImageCollectionViewCellIdentifier = @"kZFReviewImageCollectionViewCellIdentifier";

@interface ZFGoodsDetailReviewInfoTableViewCell() <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout>
@property (nonatomic, strong) UIImageView                           *userImageView;
@property (nonatomic, strong) UILabel                               *nameLabel;
@property (nonatomic, strong) UILabel                               *infoLabel;
@property (nonatomic, strong) UILabel                               *timeLabel;
@property (nonatomic, strong) ZFGoodsReviewStarsView                *starView;

@property (nonatomic, strong) UICollectionViewLeftAlignedLayout     *flowLayout;
@property (nonatomic, strong) UICollectionView                      *collectionView;
@property (nonatomic, strong) UIView                                *lineView;
@end

@implementation ZFGoodsDetailReviewInfoTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.imgList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFReviewImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFReviewImageCollectionViewCellIdentifier forIndexPath:indexPath];
    GoodsDetailFirstReviewImgListModel *model = self.model.imgList[indexPath.item];
    cell.url = model.originPic;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.goodsDetailReviewImageCheckCompletionHandler) {
        self.goodsDetailReviewImageCheckCompletionHandler(indexPath.item);
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.starView];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
    }];
    self.userImageView.layer.cornerRadius = 20;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userImageView);
        make.leading.mas_equalTo(self.userImageView.mas_trailing).offset(12);
    }];
    
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userImageView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.width.mas_equalTo(95);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userImageView);
        make.top.mas_equalTo(self.userImageView.mas_bottom).offset(8);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(8);
        make.height.mas_equalTo(100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userImageView);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(8);
        make.height.mas_equalTo(16);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.userImageView);
        make.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16);
        make.bottom.mas_equalTo(self.contentView);
    }];

}

#pragma mark - setter
- (void)setModel:(GoodsDetailFirstReviewModel *)model {
    _model = model;
    [self.userImageView yy_setImageWithURL:[NSURL URLWithString:model.avatar]
                        processorKey:NSStringFromClass([self class])
                         placeholder:[UIImage imageNamed:@"index_cat_loading"]
                             options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                            progress:nil
                           transform:^UIImage *(UIImage *image, NSURL *url) {
                               image = [image yy_imageByResizeToSize:CGSizeMake(40, 40) contentMode:UIViewContentModeScaleToFill];
                               return image;
                           }
                          completion:nil];
    self.nameLabel.text = _model.userName;
    self.infoLabel.text = _model.content;
    
    if (self.isTimeStamp) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        [dateFormatter setDateFormat:@"MMM.dd,yyyy  HH:mm:ss aa"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_model.time integerValue]]];
        NSMutableString* date= [[NSMutableString alloc]initWithString:currentDateStr];
        [date insertString:@"at" atIndex:12];
        self.timeLabel.text = date;
    } else {
        self.timeLabel.text = _model.time;
    }
    
    self.starView.rateAVG = _model.star;
    if (_model.imgList.count <= 0) {
        self.collectionView.hidden = YES;
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.userImageView);
            make.top.mas_equalTo(self.infoLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(16);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.userImageView);
            make.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16);
            make.bottom.mas_equalTo(self.contentView);
        }];
    } else {
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.userImageView);
            make.top.mas_equalTo(self.collectionView.mas_bottom).offset(8);
            make.height.mas_equalTo(16);
            make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        }];
        
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.userImageView);
            make.trailing.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16);
            make.bottom.mas_equalTo(self.contentView);
        }];
    }
}

#pragma mark - getter
- (UIImageView *)userImageView {
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _userImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
    }
    return _nameLabel;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (ZFGoodsReviewStarsView *)starView {
    if (!_starView) {
        _starView = [[ZFGoodsReviewStarsView alloc] initWithFrame:CGRectZero];
    }
    return _starView;
}

- (UICollectionViewLeftAlignedLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
        _flowLayout.minimumLineSpacing = 16;
        _flowLayout.minimumInteritemSpacing = 16;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
        _flowLayout.itemSize = CGSizeMake(100, 100);
        _flowLayout.alignedLayoutType = ![SystemConfigUtils isRightToLeftShow] ? UICollectionViewLeftAlignedLayoutTypeLeft : UICollectionViewLeftAlignedLayoutTypeRight;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = ZFCOLOR_WHITE;
        [_collectionView registerClass:[ZFReviewImageCollectionViewCell class] forCellWithReuseIdentifier:kZFReviewImageCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

@end
