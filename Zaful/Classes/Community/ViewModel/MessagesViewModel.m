//
//  MessagesViewModel.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MessagesViewModel.h"
#import "MessagesApi.h"
#import "MessagesModel.h"
#import "MessagesListModel.h"
#import "MessagesTableViewCell.h"
#import "MyStylePageViewController.h"
#import "CommunityDetailViewController.h"
#import "FollowApi.h"
#import "ZFLoginViewController.h"

@interface MessagesViewModel ()
@property (nonatomic, strong) MessagesModel *messagesModel;
@end

@implementation MessagesViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    [NetworkStateManager networkState:^{
        NSArray *array = (NSArray *)parmaters;
        NSInteger page = 1;
        if ([array[0] integerValue] == 0) {
            // 假如最后一页的时候
            if ([self.messagesModel.curPage integerValue] == self.messagesModel.pageCount) {
                if (completion) {
                    completion(NoMoreToLoad);
                }
                return;
            }
            page = [self.messagesModel.curPage integerValue]  + 1;
        }
        
        MessagesApi *api = [[MessagesApi alloc] initWithcurPage:page pageSize:PageSize];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.messagesModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.messagesModel.list];
            }else{
                [self.dataArray addObjectsFromArray:self.messagesModel.list];
            }
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.messagesModel);
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
    
    NSString *followedUserId = [parmaters valueForKey:@"user_id"];
    FollowApi *api = [[FollowApi alloc] initWithFollowStatue:YES followedUserId:followedUserId];
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
    
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    
    if ([request isKindOfClass:[MessagesApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [MessagesModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessagesTableViewCell *cell = [MessagesTableViewCell messagesTableViewCellWithTableView:tableView andIndexPath:indexPath];
    cell.backgroundColor = ZFCOLOR_WHITE;
    MessagesListModel *listModel = self.dataArray[indexPath.row];
    cell.listModel = listModel;
    
    @weakify(self)
    cell.clickEventBlock = ^{
        @strongify(self)
        if ([AccountManager sharedManager].isSignIn) {
            [self requestFollowedNetwork:listModel completion:^(id obj) {
                
            } failure:^(id obj) {
                
            }];
        }else {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self requestFollowedNetwork:listModel completion:^(id obj) {
                    
                } failure:^(id obj) {
                    
                }];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.controller.navigationController  presentViewController:nav animated:YES completion:^{
            }];
        }
        
    };
    
    
    cell.messagetapListAvatarBlock = ^{
        @strongify(self)
        MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
        myStyleVC.userid = listModel.user_id;
        [self.controller.navigationController pushViewController:myStyleVC animated:YES];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置Cell选中效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    1.关注   2.评论   3.点赞   4.置顶
    MessagesListModel *listModel = self.dataArray[indexPath.row];
    if (listModel.is_delete) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ZFLocalizedString(@"MessagesViewModel_Data_Detete", nil) delegate:nil cancelButtonTitle:ZFLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }else{
        switch (listModel.message_type) {
            case MessageListFollowTag:
                
            {
                MyStylePageViewController *myStyleVC = [MyStylePageViewController new];
                myStyleVC.userid = listModel.user_id;
                [self.controller.navigationController pushViewController:myStyleVC animated:YES];
            }
                break;
            case MessageListLikeTag:
            case MessageListCommendTag:
            case MessageListGainedPoints:
                
            {
                CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:listModel.review_id userId:listModel.user_id];
                [self.controller.navigationController pushViewController:detailVC animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    return view;
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
        imageView.image = [UIImage imageNamed:@"message_empty"];
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
        titleLabel.text = ZFLocalizedString(@"MessagesViewModel_NoData_Message",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(40);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
    }
    return customView;
}

@end
