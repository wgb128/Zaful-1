//
//  FollowViewModel.m
//  Buyyer
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 Globalegrow. All rights reserved.
//

#import "FollowViewModel.h"
#import "FollowModel.h"
#import "FollowListApi.h"
#import "LikesListApi.h"
#import "EmptyCustomViewManager.h"
#import "FollowItemCell.h"
#import "FollowApi.h"
#import "MyStylePageViewController.h"
#import "ZFLoginViewController.h"

@interface FollowViewModel ()

@property (nonatomic, strong) FollowModel *followModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isLoadfollow;

@end

@implementation FollowViewModel
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    }
    return self;
}

#pragma mark - Requset
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    @weakify(self)
    [NetworkStateManager networkState:^{
        
        NSString *refreshOrLoadMore = (NSString *)parmaters;
        NSInteger page = 1;
        if ([refreshOrLoadMore integerValue] == 0) {
            // 假如最后一页的时候
            if (self.followModel.page == self.followModel.pageCount) {
                if (completion) {
                    completion(NoMoreToLoad);
                }
                return;
            }
            page = self.followModel.page  + 1;
        }
        
        SYBaseRequest *api = nil;
        if (_userListType == ZFUserListTypeLike) {
            api = [[LikesListApi alloc] initWithRid:_rid curPage:[@(page) stringValue] userId:_userId];
        }else{
            api = [[FollowListApi alloc] initWithCurPage:[@(page) stringValue] userListType:_userListType userId:_userId];
        }
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.followModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            // 列表数据
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.followModel.listArray];
            }else{
                [self.dataArray addObjectsFromArray:self.followModel.listArray];
            }
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            if (completion) {
                if (self.followModel.page == self.followModel.pageCount) {
                    completion(NoMoreToLoad);
                }
                else {
                    completion(nil);
                }
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            @strongify(self)
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        @strongify(self)
        self.emptyViewShowType = EmptyShowNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[LikesListApi class]] || [request isKindOfClass:[FollowListApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [FollowModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

- (void)requestFollowNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure
{
    [NetworkStateManager networkState:^{
        if (_isLoadfollow) {
            return;
        }
        _isLoadfollow = YES;
        FollowItemModel *model = (FollowItemModel *)parmaters;
        FollowApi *api = [[FollowApi alloc] initWithFollowStatue:!model.isFollow followedUserId:model.userId];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
            _isLoadfollow = NO;
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                BOOL isFollow = !model.isFollow;
                NSDictionary *dic = @{@"userId"   : model.userId,
                                      @"isFollow" : @(isFollow)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
            }
            
             [MBProgressHUD showMessage:dict[@"msg"]];
            
            if (completion) {
                completion(nil);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            _isLoadfollow = NO;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        if (failure) {
            failure(nil);
        }
    }];
}

#pragma mark - tableViewDelegate / DataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.followModel.page >= self.followModel.pageCount) {
        tableView.mj_footer.hidden = YES;
    }
    else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowItemCell *cell = [FollowItemCell followItemCellWithTableView:tableView andIndexPath:indexPath];
    FollowItemModel *model = self.dataArray[indexPath.row];
    [cell configCellWithFollowItemModel:model indexPath:indexPath];
    @weakify(self)
    cell.block = ^(){
        @strongify(self)
        // 关注按钮点击事件
        
        if ([AccountManager sharedManager].isSignIn) {
            [self requestFollowNetwork:model completion:^(id obj) {
                
            } failure:^(id obj) {
                
            }];
        }else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self requestFollowNetwork:model completion:^(id obj) {
                    
                } failure:^(id obj) {
                    
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
            }];

        }
        ZFLog(@"关注");
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FollowItemModel *model = self.dataArray[indexPath.row];
    MyStylePageViewController *mystyleVC = [MyStylePageViewController new];
    mystyleVC.userid = model.userId;
    [self.controller.navigationController pushViewController:mystyleVC animated:YES];
}

#pragma mark - Notifications
- (void)followStatusChangeValue:(NSNotification *)noti
{
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    
    [self.dataArray enumerateObjectsUsingBlock:^(FollowItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.userId isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
    @weakify(self)
    [self requestNetwork:Refresh completion:^(id obj) {
        @strongify(self)
        [self.tableView reloadData];
    } failure:^(id obj) {
        
    }];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectZero];
    customView.backgroundColor = ZFCOLOR(245, 245, 245, 1);
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    [customView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).offset(105 * DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = ZFCOLOR(170, 170, 170, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;
    switch (self.userListType) {
        case ZFUserListTypeLike:
            imageView.image = [UIImage imageNamed:@"camera"];
            break;
        case ZFUserListTypeFollowing:
        {
            imageView.image = [UIImage imageNamed:@"camera"];
            if ([self.userId isEqualToString:[AccountManager sharedManager].account.user_id]) {
                titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_GetStatus",nil);
                imageView.image = [UIImage imageNamed:@"photo"];
            }
            else {
                titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_NotAny",nil);
                imageView.image = [UIImage imageNamed:@"followed-1"];
            }
        }
            break;
        case ZFUserListTypeFollowed:
        {
            if ([self.userId isEqualToString:[AccountManager sharedManager].account.user_id]) {
                 titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_AddPhotos",nil);
                imageView.image = [UIImage imageNamed:@"camera"];
            }
            else {
                 titleLabel.text = ZFLocalizedString(@"FollowViewModel_NoData_NoFollowers",nil);
                imageView.image = [UIImage imageNamed:@"follower"];
            }
        }
            break;
        default:
            break;
    }
    
    [customView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(15*DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    return customView;
}


@end
