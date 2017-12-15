

//
//  ZFCommunityMessageViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMessageViewModel.h"
#import "ZFCommunityMessageListModel.h"
#import "ZFCommunityMessagesApi.h"
#import "ZFCommunityFollowApi.h"

@interface ZFCommunityMessageViewModel ()

@property (nonatomic, strong) NSMutableArray                *messageListArray;
@property (nonatomic, strong) ZFCommunityMessageListModel   *messageListModel;

@end

@implementation ZFCommunityMessageViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure{
    
    NSArray *array = (NSArray *)parmaters;
    NSInteger page = 1;
    if ([array[0] integerValue] == 0) {
        // 假如最后一页的时候
        if ([self.messageListModel.curPage integerValue] == self.messageListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = [self.messageListModel.curPage integerValue]  + 1;
    }
    
    ZFCommunityMessagesApi *api = [[ZFCommunityMessagesApi alloc] initWithcurPage:page pageSize:PageSize];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.messageListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        if (page == 1) {
            self.messageListArray = [NSMutableArray arrayWithArray:self.messageListModel.messageList];
        }else{
            [self.messageListArray addObjectsFromArray:self.messageListModel.messageList];
        }
        self.emptyViewShowType = self.messageListArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.messageListArray);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];
    
}

//关注
- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSString *followedUserId = parmaters;
    ZFCommunityFollowApi *api = [[ZFCommunityFollowApi alloc] initWithFollowStatue:YES followedUserId:followedUserId];
    [api.accessoryArray addObject:[RequestAccessory showLoadingView:nil]];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        NSDictionary *dict = request.responseJSONObject;
        if ([dict[@"code"] integerValue] == 0) {
            
            if (completion) {
                completion(nil);
            }
            [MBProgressHUD showMessage:dict[@"msg"]];
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        if (failure) {
            failure(nil);
        }
    }];

}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    
    if ([request isKindOfClass:[ZFCommunityMessagesApi class]]) {
        if ([json[@"code"] integerValue] == 0) {
            return [ZFCommunityMessageListModel yy_modelWithJSON:json[@"data"]];
        }
    }
    return nil;
}

@end
