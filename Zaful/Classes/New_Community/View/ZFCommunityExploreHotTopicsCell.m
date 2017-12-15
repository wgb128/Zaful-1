//
//  ZFCommunityExploreHotTopicsCell.m
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityExploreHotTopicsCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityExploreModel.h"
#import "ZFExploreHotTopicCell.h"
#import "ZFExploreSeeAllCell.h"

static NSString *const kZFExploreHotTopicCellIdentifier = @"kZFExploreHotTopicCellIdentifier";
static NSString *const kZFExploreSeeAllCellIdentifier = @"kZFExploreSeeAllCellIdentifier";

@interface ZFCommunityExploreHotTopicsCell () <ZFInitViewProtocol, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UIImageView                   *topicIconView;
@property (nonatomic, strong) UILabel                       *hotTopicLabel;
@property (nonatomic, strong) UIButton                      *moreButton;
@property (nonatomic, strong) UICollectionViewFlowLayout    *flowLayout;
@property (nonatomic, strong) UICollectionView              *collectionView;
@property (nonatomic, strong) UIView                        *lineView;
@end

@implementation ZFCommunityExploreHotTopicsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)moreButtonAction:(UIButton *)sender {
    if (self.communityMoreTopicsCompletionHandler) {
        self.communityMoreTopicsCompletionHandler();
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.topicList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell;
    if (self.model.topicList.count > 6) {
        if (indexPath.row == 6) {
            ZFExploreSeeAllCell *seeAllCell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFExploreSeeAllCellIdentifier forIndexPath:indexPath];
            @weakify(self);
            seeAllCell.exploreSeeAllCompletionHandler = ^{
                @strongify(self);
                if (self.communityMoreTopicsCompletionHandler) {
                    self.communityMoreTopicsCompletionHandler();
                }
            };
            
            cell = seeAllCell;
        } else {
            ZFExploreHotTopicCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFExploreHotTopicCellIdentifier forIndexPath:indexPath];
            videoCell.data = self.model.topicList[indexPath.item];
            cell = videoCell;
        }
    } else {
        ZFExploreHotTopicCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFExploreHotTopicCellIdentifier forIndexPath:indexPath];
        videoCell.data = self.model.topicList[indexPath.item];
        cell = videoCell;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(159, 90);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    NSDictionary *dict = self.model.topicList[indexPath.item];
    NSString *topicId = dict[@"id"] ?: @"";
    if (self.communityExploreHotTopicDetailCompletionHandler) {
        self.communityExploreHotTopicDetailCompletionHandler(topicId);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.topicIconView];
    [self.contentView addSubview:self.hotTopicLabel];
    [self.contentView addSubview:self.moreButton];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.topicIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.hotTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.topicIconView.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.topicIconView);
        make.height.mas_equalTo(20);
        make.trailing.mas_equalTo(self.moreButton.mas_leading).offset(-16);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.topicIconView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-16);
        make.height.mas_equalTo(44);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotTopicLabel.mas_bottom).mas_offset(16);
        make.leading.trailing.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(8);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFCommunityExploreModel *)model {
    _model = model;
    [self.collectionView reloadData];
}

#pragma mark - getter
- (UIImageView *)topicIconView {
    if (!_topicIconView) {
        _topicIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topicIconView.image = [UIImage imageNamed:@"Topic-1"];
    }
    return _topicIconView;
}

- (UILabel *)hotTopicLabel {
    if (!_hotTopicLabel) {
        _hotTopicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotTopicLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _hotTopicLabel.font = [UIFont systemFontOfSize:18];
        _hotTopicLabel.text = ZFLocalizedString(@"Community_HeaderView_HotTopic",nil);
    }
    return _hotTopicLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:ZFLocalizedString(@"Community_HeaderView_More",nil) forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 10;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = ZFCOLOR_WHITE;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ZFExploreHotTopicCell class] forCellWithReuseIdentifier:kZFExploreHotTopicCellIdentifier];
        [_collectionView registerClass:[ZFExploreSeeAllCell class] forCellWithReuseIdentifier:kZFExploreSeeAllCellIdentifier];
    }
    return _collectionView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return _lineView;
}
@end
