//
//  FriendsResultViewModel.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FriendsResultViewModel.h"
#import "FriendsResultCell.h"
#import "FriendsResultApi.h"
#import "FollowApi.h"
#import "FriendsResultModel.h"
#import "FriendsResultModel.h"
#import "FriendsResultListModel.h"
#import "MyStylePageViewController.h"
#import "ZFLoginViewController.h"

@interface FriendsResultViewModel ()
@property (nonatomic, strong) FriendsResultListModel    *friendsResultListModel;

@end

@implementation FriendsResultViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSArray *array = (NSArray *)parmaters;
    NSInteger page = 1;
    if ([array[0] integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.friendsResultListModel.curPage integerValue] == self.friendsResultListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.friendsResultListModel.curPage integerValue]  + 1;
    }
    
    [NetworkStateManager networkState:^{
        NSString *searchKey = array[1];
        FriendsResultApi *api = [[FriendsResultApi alloc] initWithkeyWord:searchKey andCurPage:page pageSize:[PageSize integerValue]];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            @strongify(self)
            self.friendsResultListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.friendsResultListModel.list];
            }else{
                [self.dataArray addObjectsFromArray:self.friendsResultListModel.list];
            }
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            self.friendResultTableView.hidden = NO;
            if (self.dataArray.count <= 0) {
                self.friendResultTableView.tableFooterView = [UIView new];
            }
            
            if (completion) {
                completion(nil);
            }
            
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
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

//关注
- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    [NetworkStateManager networkState:^{
        
        NSString *followedUserId = [parmaters valueForKey:@"user_id"];
        FollowApi *api = [[FollowApi alloc] initWithFollowStatue:YES followedUserId:followedUserId];
        [api.accessoryArray addObject:[RequestAccessory showLoadingView:self.controller.view]];
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            NSDictionary *dict = request.responseJSONObject;
            if ([dict[@"code"] integerValue] == 0) {
                NSDictionary *dic = @{@"userId"   : followedUserId,
                                      @"isFollow" : @(YES)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowStatusChangeNotification object:dic];
            }
            [MBProgressHUD showMessage:dict[@"msg"]];
            
            if (completion) {
                completion(nil);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if ([request isKindOfClass:[FriendsResultApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [FriendsResultListModel yy_modelWithJSON:json[@"data"]];
        }
        else {
            [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsResultCell *cell = [FriendsResultCell friendsResultCellWithTableView:tableView andIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FriendsResultModel *friendsResultModel = self.dataArray[indexPath.row];
    cell.friendsResultModel = friendsResultModel;
    cell.clickEventBlock = ^{
        if ([AccountManager sharedManager].isSignIn) {
            [self requestFollowedNetwork:friendsResultModel completion:^(id obj) {
                
            } failure:^(id obj) {
                
            }];
        }else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self requestFollowedNetwork:friendsResultModel completion:^(id obj) {
                    
                } failure:^(id obj) {
                    
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
            }];
        }
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendsResultCell class]) cacheByIndexPath:indexPath configuration:^(FriendsResultCell *cell) {
        cell.friendsResultModel = self.dataArray[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FriendsResultModel *friendsResultModel = self.dataArray[indexPath.row];
    MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
    myStyleVC.userid = friendsResultModel.user_id;
    [self.controller.navigationController pushViewController:myStyleVC animated:YES];
    
}


#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([NSArrayUtils isEmptyArray:self.dataArray]) {
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"search_result"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(120 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = ZFLocalizedString(@"FriendsResultViewModel_NoData_Message",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(40);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
    }
    return customView;
}

@end
