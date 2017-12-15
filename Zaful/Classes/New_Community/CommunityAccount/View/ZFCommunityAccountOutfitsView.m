//
//  ZFCommunityAccountOutfitsView.m
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountOutfitsView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityAccountOutfitsCell.h"
#import "ZFCommunityOutfitsModel.h"
#import "ZFCommunityAccountOutfitsViewModel.h"
#import "ZFCommunityFavesItemModel.h"
#import "ZFLoginViewController.h"

static NSString *const kZFCommunityAccountOutfitsCellIdentifier = @"kZFCommunityAccountOutfitsCellIdentifier";

@interface ZFCommunityAccountOutfitsView () <ZFInitViewProtocol, UICollectionViewDelegate, UICollectionViewDataSource> {
    __block NSInteger       _currentPage;
}

@property (nonatomic, strong) UICollectionView                      *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout            *flowLayout;
@property (nonatomic, strong) ZFCommunityAccountOutfitsViewModel    *viewModel;
@property (nonatomic, strong) NSMutableArray<ZFCommunityOutfitsModel *> *dataArray;
@end

@implementation ZFCommunityAccountOutfitsView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self.collectionView.mj_header beginRefreshing];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeStatusChangeValue:) name:kLikeStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kChangeUserInfoNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutChangeValue:) name:kLogoutNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notificatoin methods 
- (void)loginChangeValue:(NSNotification *)nofi {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)logoutChangeValue:(NSNotification *)nofi {
    [self.collectionView.mj_header beginRefreshing];
}

- (void)deleteChangeValue:(NSNotification *)nofi {
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

#pragma mark - private methods
- (void)communityAccountOutfitsLikeOptionWithModel:(ZFCommunityOutfitsModel *)model andIndexPath:(NSIndexPath *)indexPath {
    
    if (![AccountManager sharedManager].isSignIn) {
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        @weakify(self);
        loginVC.successBlock = ^{
            @strongify(self);
            [self.viewModel requestLikeNetwork:model completion:^(id obj) {
                @strongify(self);
                self.dataArray[indexPath.row].liked = [NSString stringWithFormat:@"%d", ![self.dataArray[indexPath.row].liked boolValue]];
                self.dataArray[indexPath.row].likeCount = [NSString stringWithFormat:@"%lu", [self.dataArray[indexPath.row].likeCount integerValue] + (self.dataArray[indexPath.row].liked ? 1 : -1)];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            } failure:^(id obj) {
                @strongify(self);
                [self.collectionView reloadData];
            }];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
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
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityAccountOutfitsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZFCommunityAccountOutfitsCellIdentifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.communityAccountOutfitsLikeCompletionHandler = ^(ZFCommunityOutfitsModel *model) {
        @strongify(self);
        [self communityAccountOutfitsLikeOptionWithModel:model andIndexPath:indexPath];
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
    if (self.communityAccountOutfitsDetailCompletionHandler) {
        self.communityAccountOutfitsDetailCompletionHandler(model.userId, model.reviewId, model.reviewTitle);
    }
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.collectionView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UICollectionView * _Nonnull sender) {
        @strongify(self);
        self.collectionView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        [customView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:16];
        if ([self.userId isEqualToString:USERID]) {
            titleLabel.text = ZFLocalizedString(@"AccountOutfits_NoData_NotOutfits", nil);
        } else {
            titleLabel.text = ZFLocalizedString(@"AccountOtherOutfits_NoData_NotOutfits", nil);
        }
        
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bottomView.mas_top).offset(158*DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(bottomView.mas_centerX);
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
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
}

#pragma mark - setter 
- (void)setUserId:(NSString *)userId {
    _userId = userId;
}

#pragma mark - getter
- (ZFCommunityAccountOutfitsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityAccountOutfitsViewModel alloc] init];
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
        if ([SystemConfigUtils isRightToLeftShow]) {
            _collectionView.contentInset = UIEdgeInsetsMake(35, 0, 44, 0);
        } else {
            _collectionView.contentInset = UIEdgeInsetsMake(44, 0, 44, 0);
        }
        [_collectionView registerClass:[ZFCommunityAccountOutfitsCell class] forCellWithReuseIdentifier:kZFCommunityAccountOutfitsCellIdentifier];
        @weakify(self);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[Refresh, @(1), self.userId?:@"0"] completion:^(id obj) {
                self->_currentPage = 1;
                self.dataArray = obj;
                self.collectionView.mj_footer.hidden = NO;
                
                [self emptyNoDataOption];
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
                
            } failure:^(id obj) {
                @strongify(self);
                
                [self emptyNoDataOption];
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }];
        }];
        
        _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[LoadMore, @(self->_currentPage + 1), self.userId?:@"0"] completion:^(id obj) {
                @strongify(self);
                if([obj isEqual: NoMoreToLoad]) {
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
