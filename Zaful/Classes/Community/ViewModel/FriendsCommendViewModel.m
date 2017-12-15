
//
//  FriendsCommendViewModel.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FriendsCommendViewModel.h"
#import "FriendsCommendHeadView.h"
#import "CommendUserCell.h"
#import "CommendUserApi.h"
#import "FriendsCommendHeadView.h"
#import "CommendUserModel.h"
#import "CommendListModel.h"
#import "FollowApi.h"
#import "ContactsViewController.h"
#import "MyStylePageViewController.h"
#import "PPGetAddressBook.h"
#import "ZFLoginViewController.h"

@interface FriendsCommendViewModel ()
@property (nonatomic, strong) CommendListModel *commendListModel;
//@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation FriendsCommendViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.commendListModel.curPage integerValue] == self.commendListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.commendListModel.curPage integerValue]  + 1;
    }
    
    [NetworkStateManager networkState:^{
        
        CommendUserApi *api = [[CommendUserApi alloc] initWithcurPage:page pageSize:[PageSize integerValue]];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            
            @strongify(self)
            self.commendListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];

            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.commendListModel.list];
            }else{
                [self.dataArray addObjectsFromArray:self.commendListModel.list];
            }
            
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
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

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    if ([request isKindOfClass:[CommendUserApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [CommendListModel yy_modelWithJSON:json[@"data"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    FriendsCommendHeadView *headView = [FriendsCommendHeadView friendsCommendHeadViewWithTableView:tableView];
    return [headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FriendsCommendHeadView *headView = [FriendsCommendHeadView friendsCommendHeadViewWithTableView:tableView];
    headView.contactsTouchBlock = ^{
        //请求用户获取通讯录权限
        ContactsViewController *vc = [[ContactsViewController alloc] init];
        [self.controller.navigationController pushViewController:vc animated:YES];
    };
    headView.inviteTouchBlock = ^{
    };
    return headView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommendUserCell *cell = [CommendUserCell commendUserCellWithTableView:tableView andIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CommendUserModel *commendUserModel = self.dataArray[indexPath.row];
    cell.commendUserModel = commendUserModel;
    cell.clickEventBlock = ^{
        if ([AccountManager sharedManager].isSignIn) {
            [MBProgressHUD showLoadingView:nil];
            [self requestFollowedNetwork:commendUserModel completion:^(id obj) {
                
            } failure:^(id obj) {
                
            }];
        }else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self requestFollowedNetwork:commendUserModel completion:^(id obj) {
                    
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
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([CommendUserCell class]) cacheByIndexPath:indexPath configuration:^(CommendUserCell *cell) {
        cell.commendUserModel = self.dataArray[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommendUserModel *commendUserModel = self.dataArray[indexPath.row];
    MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
    myStyleVC.userid = commendUserModel.user_id;
    [self.controller.navigationController pushViewController:myStyleVC animated:YES];
}
@end
