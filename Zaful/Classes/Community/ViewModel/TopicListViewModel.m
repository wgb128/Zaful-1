//
//  TopicListViewModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicListViewModel.h"
#import "TopicListApi.h"
#import "TopicModel.h"
#import "TopicListModel.h"
#import "TopicListTableViewCell.h"
#import "TopicViewController.h"
#import "LabelDetailViewController.h"

@interface TopicListViewModel ()
@property (nonatomic, strong) TopicModel *topicModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TopicListViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    
    [NetworkStateManager networkState:^{
        NSArray *array = (NSArray *)parmaters;
        NSInteger page = 1;
        if ([array[0] integerValue] == 0) {
            // 假如最后一页的时候
            if ([self.topicModel.curPage integerValue] == self.topicModel.pageCount) {
                if (completion) {
                    completion(NoMoreToLoad);
                }
                return;
            }
            page = [self.topicModel.curPage integerValue]  + 1;
        }
        
        TopicListApi *api = [[TopicListApi alloc] initWithcurPage:page pageSize:PageSize];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.topicModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.topicModel.topic];
            }else{
                [self.dataArray addObjectsFromArray:self.topicModel.topic];
            }
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;

            if (completion) {
                completion(self.topicModel);
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
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[TopicListApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [TopicModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

#pragma mark - tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListTableViewCell *cell = [TopicListTableViewCell topicListTableViewCellWithTableView:tableView andIndexPath:indexPath];
    cell.backgroundColor = ZFCOLOR_WHITE;
    cell.listModel = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置Cell选中效果
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:TOPIC_LIST_CELL_IDENTIFIER cacheByIndexPath:indexPath configuration:^(TopicListTableViewCell *cell) {
        cell.listModel = self.dataArray[indexPath.section];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListModel *listModel = self.dataArray[indexPath.section];
    TopicViewController *topic = [TopicViewController new];
    if ([NSStringUtils isEmptyString:listModel.topicId]) return;
    topic.topicId = listModel.topicId;
    topic.sort = @"1";
    [self.controller.navigationController pushViewController:topic animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 0;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


@end
