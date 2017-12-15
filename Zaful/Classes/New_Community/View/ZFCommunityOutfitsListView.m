
//
//  ZFCommunityOutfitsListView.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityOutfitsListView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityOutfitsListCell.h"
#import "ZFCommunityOutfitsViewModel.h"
#import "ZFCommunityOutfitsModel.h"
#import "ZFLoginViewController.h"
#import "CommunityDetailViewController.h"
#import "ZFCommunityFavesItemModel.h"

static NSString *const kZFCommunityOutfitsListCellIdentifier = @"kZFCommunityOutfitsListCellIdentifier";

@interface ZFCommunityOutfitsListView () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource> {
    __block NSInteger       _currentPage;
}

@property (nonatomic, strong) UICollectionView                      *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout            *flowLayout;
@property (nonatomic, strong) ZFCommunityOutfitsViewModel           *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunityOutfitsModel *> *dataArray;
@end


@implementation ZFCommunityOutfitsListView
#pragma mark - init methods 
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self.collectionView.mj_header beginRefreshing];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteChangeValue:) name:kDeleteStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
        //接收登出状态通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification methods
- (void)loginChangeValue:(NSNotification *)nofi {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)logoutChangeValue:(NSNotification *)nofi {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)likeStatusChangeValue:(NSNotification *)nofi {
    //接收通知传过来的model StyleLikesModel
    ZFCommunityFavesItemModel *likesModel = nofi.object;
    //遍历当前列表数组找到相同reviewId改变点赞按钮状态并且增加或减少点赞数
    [self.dataArray enumerateObjectsUsingBlock:^(ZFCommunityOutfitsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.reviewId isEqualToString:likesModel.reviewId]) {
            if (likesModel.isLiked) {
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]+1];
            }else{
                obj.likeCount = [NSString stringWithFormat:@"%d", [obj.likeCount intValue]-1];
            }
            obj.liked = [NSString stringWithFormat:@"%d", likesModel.isLiked];
            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadItemsAtIndexPaths:@[reloadIndexPath]];
            });
            *stop = YES;
        }
    }];
    
}

- (void)deleteChangeValue:(NSNotification *)nofi {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)communityOutfitsLikeOptionWithModel:(ZFCommunityOutfitsModel *)model andIndexPath:(NSIndexPath *)indexPath {
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *signVC = [ZFLoginViewController new];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        [self.controller.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    @weakify(self);
    [self.viewModel requestLikeNetwork:model completion:^(id obj) {
        @strongify(self);
        self.dataArray[indexPath.row].liked = [NSString stringWithFormat:@"%d", ![self.dataArray[indexPath.row].liked boolValue]];
        self.dataArray[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.dataArray[indexPath.row].likeCount integerValue] + (self.dataArray[indexPath.row].liked ? 1 : -1)];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } failure:^(id obj) {
    }];
}

- (void)reloadOutfitsData {
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityOutfitsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityOutfitsListCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityOutfitsLikeCompletionHandler = ^(ZFCommunityOutfitsModel *model) {
        @strongify(self);
        [self communityOutfitsLikeOptionWithModel:model andIndexPath:indexPath];
    };
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 7;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - 39) / 2, 230 * SCREEN_WIDTH_SCALE);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    ZFCommunityOutfitsModel *model = self.dataArray[indexPath.row];
    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:model.reviewId userId:model.userId];
    detailVC.isOutfits = YES;
    detailVC.title = model.reviewTitle;
    [self.controller.navigationController pushViewController:detailVC animated:YES];
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.collectionView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UICollectionView * _Nonnull sender) {
        @strongify(self);
        self.collectionView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"Community_outfits_Nodata"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(105 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Posts from your Popular \n will appear here";
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFCOLOR(51, 51, 51, 1);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"Refresh" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadOutfitsData) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        return customView;
        
    } normalBlock:^(UICollectionView * _Nonnull sender) {
        @strongify(self);
        self.collectionView.scrollEnabled = YES;
    }];
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self->_currentPage = 1;
    self.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
    [self.contentView addSubview:self.collectionView];
    
}

- (void)zfAutoLayoutView {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(73, 16, 0, 16));
    }];
}

#pragma mark - getter
- (ZFCommunityOutfitsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityOutfitsViewModel alloc] init];
    }
    return _viewModel;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = ZFCOLOR(245, 245, 245, 1.f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [_collectionView registerClass:[ZFCommunityOutfitsListCell class] forCellWithReuseIdentifier:kZFCommunityOutfitsListCellIdentifier];
        
        @weakify(self);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[Refresh, @(1)] completion:^(id obj) {
                self->_currentPage = 1;
                self.dataArray = obj;
                self.collectionView.mj_footer.hidden = NO;
                
                [self emptyNoDataOption];
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                
            } failure:^(id obj) {
                @strongify(self);
                if (self.dataArray.count == 0) {
                    [self emptyNoDataOption];
                }
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[LoadMore, @(self->_currentPage + 1)] completion:^(id obj) {
                @strongify(self);
                if ([obj isEqual:NoMoreToLoad]) {
                    [self.collectionView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.collectionView.mj_footer.hidden = YES;
                    }];
                } else {
                    self->_currentPage += 1;
                    self.dataArray = obj;
                    [self.collectionView reloadData];
                    [self.collectionView.mj_footer endRefreshing];
                }
                
            } failure:^(id obj) {
                [self.collectionView.mj_footer endRefreshing];
            }];
        }];
    }
    return _collectionView;
}

@end
