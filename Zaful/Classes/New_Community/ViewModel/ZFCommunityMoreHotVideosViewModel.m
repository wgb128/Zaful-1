
//
//  ZFCommunityMoreHotVideosViewModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityMoreHotVideosViewModel.h"
#import "ZFCommunityVideoListApi.h"
#import "ZFCommunityMoreHotVideoListModel.h"
#import "ZFCommunityMoreHotVideoModel.h"

@interface ZFCommunityMoreHotVideosViewModel ()
@property (nonatomic, strong) ZFCommunityMoreHotVideoListModel      *videoListModel;
@property (nonatomic, strong) NSMutableArray                        *dataArray;
@end

@implementation ZFCommunityMoreHotVideosViewModel
- (void)requestNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    NSInteger page = 1;
    if ([parmaters integerValue] == 0) {
        // 假如最后一页的时候
        if (self.videoListModel.curPage == self.videoListModel.pageCount) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return;
        }
        page = self.videoListModel.curPage  + 1;
    }
    
    
    ZFCommunityVideoListApi *api = [[ZFCommunityVideoListApi alloc] initWithPage:page];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        self.videoListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
        
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithArray:self.videoListModel.videoList];
        }else{
            [self.dataArray addObjectsFromArray:self.videoListModel.videoList];
        }
        self.videoListModel.videoList = self.dataArray;
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        
        if (completion) {
            completion(self.videoListModel);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        @strongify(self)
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
    
}

//解析
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[ZFCommunityVideoListApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [ZFCommunityMoreHotVideoListModel yy_modelWithJSON:json[@"data"]];
        }
        else {
             [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}
@end
