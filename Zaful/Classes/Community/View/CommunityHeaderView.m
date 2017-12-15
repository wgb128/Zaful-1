//
//  CommunityHeaderView.m
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

typedef NS_ENUM(NSUInteger,CollectionView)
{
    videoCollectionViewTag  = 9999,
    topicCollectionViewTag
};

#import "CommunityHeaderView.h"
#import "SDCycleScrollView.h"

//H5跳转
#import "BannerModel.h"
#import "SDCycleScrollView.h"
#import "PopularModel.h"

#import "HotVideoCell.h"
#import "HotTopicCell.h"
#import "SeeAllCell.h"

#import "VideoListViewController.h"
#import "VideoViewController.h"
#import "TopicListViewController.h"
#import "TopicViewController.h"

@interface CommunityHeaderView () <SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) SDCycleScrollView *bannerView;//banner
@property (nonatomic, strong) MASConstraint *contentImgHeight;//banner容器的高度

//视频
@property (nonatomic, weak) UIView *videoView;
@property (nonatomic, weak) UILabel *videoLabel;
@property (nonatomic, weak) UIButton *videoButton;
@property (nonatomic, weak) UICollectionView *videoCollectionView;
@property (nonatomic, strong) MASConstraint *videoTopHeight;//视频距离上的高度
@property (nonatomic, strong) MASConstraint *videoHeight;//视频高度

//话题
@property (nonatomic, weak) UIView *topicView;
@property (nonatomic, weak) UILabel *topicLabel;
@property (nonatomic, weak) UIButton *topicButton;
@property (nonatomic, weak) UICollectionView *topicCollectionView;
@property (nonatomic, strong) MASConstraint *topicTopHeight;//话题距离上的高度
@property (nonatomic, strong) MASConstraint *topicHeight;//话题高度

@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *recentLabel;
@property (nonatomic, weak) UIView *line1;
@property (nonatomic, weak) UIView *line2;
@property (nonatomic, weak) UIView *line3;

@end

#define BANNER_HEIGHT 150

@implementation CommunityHeaderView

- (void)setModel:(PopularModel *)model {
    _model = model;

    if (![NSArrayUtils isEmptyArray:model.bannerlist]) {
        self.bannerView.hidden = NO;
        self.contentImgHeight.mas_equalTo(190);
        self.videoTopHeight.mas_equalTo(10);
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:model.bannerlist.count];

        [model.bannerlist enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [imageArray addObject:obj.image];
        }];

        self.bannerView.imageURLStringsGroup = imageArray;
        self.bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;

        if (imageArray.count == 1) {
            self.bannerView.autoScroll = NO;
        }
    }else {
        self.bannerView.hidden = YES;
        self.contentImgHeight.mas_equalTo(0);
        self.videoTopHeight.mas_equalTo(0);
    }
    
    if (![NSArrayUtils isEmptyArray:model.video]) {
        self.videoHeight.mas_equalTo(165);
        self.videoLabel.text = ZFLocalizedString(@"Community_HeaderView_HotVideo",nil);
        [self.videoButton setTitle:ZFLocalizedString(@"Community_HeaderView_More",nil) forState:UIControlStateNormal];
        self.line1.hidden = NO;
        self.topicTopHeight.mas_equalTo(10);
    }else {
        self.videoHeight.mas_equalTo(0);
        self.topicTopHeight.mas_equalTo(0);
    }
    [self.videoCollectionView reloadData];
    
    if (![NSArrayUtils isEmptyArray:model.topicList]) {
        self.topicHeight.mas_equalTo(165);
        self.topicLabel.text = ZFLocalizedString(@"Community_HeaderView_HotTopic",nil);
        [self.topicButton setTitle:ZFLocalizedString(@"Community_HeaderView_More",nil) forState:UIControlStateNormal];
        self.line2.hidden = NO;
        self.topicTopHeight.mas_equalTo(10);
    }else {
        self.topicHeight.mas_equalTo(0);
        self.topicTopHeight.mas_equalTo(0);
    }
    [self.topicCollectionView reloadData];
    
    if (![NSArrayUtils isEmptyArray:model.list]) {
        self.recentLabel.text = ZFLocalizedString(@"Community_HeaderView_RecentPosts",nil);
        self.line3.hidden = NO;
        self.bottomView.hidden = NO;
    }
    [self.videoLabel sizeToFit];
    [self.topicLabel sizeToFit];
    [self.recentLabel sizeToFit];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
        
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"community_index_banner_loading"]];
        bannerView.autoScrollTimeInterval = 3.0; // 间隔时间
        bannerView.currentPageDotColor = ZFCOLOR(51, 51, 51, 1.0);
        bannerView.pageDotColor = ZFCOLOR(241, 241, 241, 1.0);
        [self addSubview:bannerView];
        
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.leading.trailing.mas_equalTo(self);
            self.contentImgHeight = make.height.mas_equalTo(0);
        }];
        self.bannerView = bannerView;
        
        UIView *videoView = [UIView new];
        videoView.backgroundColor = ZFCOLOR_WHITE;
        [self addSubview:videoView];
        
        [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.videoTopHeight = make.top.mas_equalTo(bannerView.mas_bottom).mas_offset(0);
            make.leading.trailing.mas_equalTo(self);
            self.videoHeight = make.height.mas_equalTo(0);
        }];
        self.videoView = videoView;
        
        UIView *line1 = [UIView new];
        line1.hidden = YES;
        line1.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [videoView addSubview:line1];
        
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(videoView.mas_top).mas_offset(23);
            make.leading.mas_equalTo(videoView.mas_leading);
        }];
        self.line1 = line1;
        
        UILabel *videoLabel = [UILabel new];
        videoLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        videoLabel.font = [UIFont systemFontOfSize:18];
        [videoView addSubview:videoLabel];
        
        [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(videoView.mas_top).mas_offset(20);
            make.leading.mas_equalTo(videoView.mas_leading).mas_offset(10);
        }];
        self.videoLabel = videoLabel;
        
        UIButton *videoButton = [UIButton new];
        videoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [videoButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateNormal];
        [videoButton addTarget:self action:@selector(videoListTouch:) forControlEvents:UIControlEventTouchUpInside];
        [videoView addSubview:videoButton];
        
        [videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(videoLabel.mas_centerY);
            make.trailing.mas_equalTo(videoView.mas_trailing).mas_offset(-10);
            make.height.mas_equalTo(17);
        }];
        self.videoButton = videoButton;
        
        UICollectionViewFlowLayout *videoLayout = [UICollectionViewFlowLayout new];
        videoLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        videoLayout.minimumInteritemSpacing = 10;
        videoLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        UICollectionView *videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:videoLayout];
        videoCollectionView.tag = videoCollectionViewTag;
        videoCollectionView.backgroundColor = ZFCOLOR_WHITE;
        videoCollectionView.showsVerticalScrollIndicator = NO;
        videoCollectionView.showsHorizontalScrollIndicator = NO;
        videoCollectionView.dataSource = self;
        videoCollectionView.delegate = self;
        [videoView addSubview:videoCollectionView];
        
        [videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(videoLabel.mas_bottom).mas_offset(10);
            make.leading.trailing.mas_equalTo(videoView);
            make.bottom.mas_equalTo(videoView.mas_bottom).mas_offset(-20);
        }];
        self.videoCollectionView = videoCollectionView;
        
        UIView *topicView = [UIView new];
        topicView.backgroundColor = ZFCOLOR_WHITE;
        [self addSubview:topicView];
        
        [topicView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.topicTopHeight = make.top.mas_equalTo(videoView.mas_bottom).mas_offset(0);
            make.leading.mas_equalTo(self.mas_leading);
            make.trailing.mas_equalTo(self.mas_trailing);
            self.topicHeight = make.height.mas_equalTo(0);
        }];
        self.topicView = topicView;
        
        UIView *line2 = [UIView new];
        line2.hidden = YES;
        line2.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [topicView addSubview:line2];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(16);
            make.top.mas_equalTo(topicView.mas_top).mas_offset(23);
            make.leading.mas_equalTo(topicView.mas_leading);
        }];
        self.line2 = line2;
        
        UILabel *topicLabel = [UILabel new];
        topicLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        topicLabel.font = [UIFont systemFontOfSize:18];
        [topicView addSubview:topicLabel];
        
        [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicView.mas_top).mas_offset(20);
            make.leading.mas_equalTo(topicView.mas_leading).mas_offset(10);
        }];
        self.topicLabel = topicLabel;
        
        UIButton *topicButton = [UIButton new];
        topicButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [topicButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateNormal];
        [topicButton addTarget:self action:@selector(topicListTouch:) forControlEvents:UIControlEventTouchUpInside];
        [topicView addSubview:topicButton];
        
        [topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topicLabel.mas_centerY);
            make.trailing.mas_equalTo(topicView.mas_trailing).mas_offset(-10);
            make.height.mas_equalTo(17);
        }];
        self.topicButton = topicButton;
        
        UICollectionViewFlowLayout *topicLayout = [UICollectionViewFlowLayout new];
        topicLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        topicLayout.minimumInteritemSpacing = 10;
        topicLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        UICollectionView *topicCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:topicLayout];
        topicCollectionView.tag = topicCollectionViewTag;
        topicCollectionView.backgroundColor = ZFCOLOR_WHITE;
        topicCollectionView.showsVerticalScrollIndicator = NO;
        topicCollectionView.showsHorizontalScrollIndicator = NO;
        topicCollectionView.dataSource = self;
        topicCollectionView.delegate = self;
        [topicView addSubview:topicCollectionView];
        
        [topicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicLabel.mas_bottom).mas_offset(10);
            make.leading.trailing.mas_equalTo(topicView);
            make.bottom.mas_equalTo(topicView.mas_bottom).mas_offset(-20);
        }];
        self.topicCollectionView = topicCollectionView;
        
        UIView *bottomView = [UIView new];
        bottomView.hidden = YES;
        bottomView.backgroundColor = ZFCOLOR_WHITE;
        [self addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topicView.mas_bottom).mas_offset(10);
            make.leading.trailing.mas_equalTo(self);
//            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        self.bottomView = bottomView;
        
        UILabel *recentLabel = [UILabel new];
        recentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        recentLabel.font = [UIFont systemFontOfSize:18];
        [bottomView addSubview:recentLabel];
        
        [recentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomView.mas_top).mas_offset(20);
            make.bottom.mas_equalTo(bottomView.mas_bottom);
            make.leading.mas_equalTo(bottomView.mas_leading).mas_offset(10);
        }];
        self.recentLabel = recentLabel;

        UIView *line3 = [UIView new];
        line3.hidden = YES;
        line3.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [bottomView addSubview:line3];
        
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(16);
            make.bottom.mas_equalTo(bottomView.mas_bottom).mas_offset(-3);
            make.leading.mas_equalTo(bottomView.mas_leading);
        }];
        self.line3 = line3;
    }
    return self;
}

//l轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *bannerModel = self.model.bannerlist[index];
    [BannerManager doBannerActionTarget:self.controller withBannerModel:bannerModel];
    
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Community" actionName:@"Community - Banner" label:@"Community - Banner Tab"];
    NSString *GABannerId = bannerModel.key;
    NSString *GABannerName = [NSString stringWithFormat:@"CommunityBanner - %@",bannerModel.title];
    NSString *position = [NSString stringWithFormat:@"CommunityBanner - P%ld", (long)(index +1)];
    [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
    
}

#pragma mark - 商品推荐 -> UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == videoCollectionViewTag) {
        return self.model.video.count;
    }else {
        return self.model.topicList.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell;
    
    switch (collectionView.tag) {
        case videoCollectionViewTag:
        {
            if (self.model.video.count > 6) {
                if (indexPath.row == 6) {
                    SeeAllCell *seeAllCell = [SeeAllCell seeAllCellWithCollectionView:collectionView IndexPath:indexPath];
                    
                    @weakify(self)
                    seeAllCell.seeAllBlock = ^{
                        @strongify(self)
                        VideoListViewController *videoList = [VideoListViewController new];
                        [self.controller.navigationController pushViewController:videoList animated:YES];
                    };
                    
                    cell = seeAllCell;
                }else {
                    HotVideoCell *videoCell = [HotVideoCell hotVideoCellWithCollectionView:collectionView IndexPath:indexPath];
                    videoCell.data = self.model.video[indexPath.item];
                    cell = videoCell;
                }
            }else {
                HotVideoCell *videoCell = [HotVideoCell hotVideoCellWithCollectionView:collectionView IndexPath:indexPath];
                videoCell.data = self.model.video[indexPath.item];
                cell = videoCell;
            }
        }
            break;
        case topicCollectionViewTag:
        {
            if (self.model.topicList.count > 6) {
                if (indexPath.row == 6) {
                    SeeAllCell *seeAllCell = [SeeAllCell seeAllCellWithCollectionView:collectionView IndexPath:indexPath];
                    
                    @weakify(self)
                    seeAllCell.seeAllBlock = ^{
                        @strongify(self)
                        TopicListViewController *topicList = [TopicListViewController new];
                        [self.controller.navigationController pushViewController:topicList animated:YES];
                    };
                    
                    cell = seeAllCell;
                }else {
                    HotTopicCell *topicCell = [HotTopicCell hotTopicCellWithCollectionView:collectionView IndexPath:indexPath];
                    topicCell.data = self.model.topicList[indexPath.item];
                    cell = topicCell;
                }
            }else {
                HotTopicCell *topicCell = [HotTopicCell hotTopicCellWithCollectionView:collectionView IndexPath:indexPath];
                topicCell.data = self.model.topicList[indexPath.item];
                cell = topicCell;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - 商品推荐 -> UICollectionView Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    
    switch (collectionView.tag) {
        case videoCollectionViewTag:
        {
            CGSize videoSize = CGSizeMake(159, 90);
            size = videoSize;
        }
            break;
        case topicCollectionViewTag:
        {
            CGSize topicSize = CGSizeMake(159, 90);
            size = topicSize;
        }
            break;
        default:
            size = CGSizeZero;
            break;
    }
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (collectionView.tag == videoCollectionViewTag) {
        NSDictionary *dict = self.model.video[indexPath.item];
        VideoViewController *video = [VideoViewController new];
        
        if (dict[@"id"] == nil) {
            return;
        }
        
        video.videoId = dict[@"id"];
        video.title = dict[@"video_title"];
        [self.controller.navigationController pushViewController:video animated:YES];
    }else {
        NSDictionary *dict = self.model.topicList[indexPath.item];
        TopicViewController *topic = [TopicViewController new];
        
        if (dict[@"id"] == nil) {
            return;
        }
        
        topic.topicId = dict[@"id"];
        topic.sort = @"1";
        
        [self.controller.navigationController pushViewController:topic animated:YES];
    }
}

- (void)videoListTouch:(id)sender {
    VideoListViewController *videoList = [VideoListViewController new];
    
    [self.controller.navigationController pushViewController:videoList animated:YES];
}

- (void)topicListTouch:(id)sender {
    TopicListViewController *topicList = [TopicListViewController new];
    
    [self.controller.navigationController pushViewController:topicList animated:YES];
}

@end
