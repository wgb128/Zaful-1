//
//  VideoListViewModel.m
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "VideoListViewModel.h"
#import "VideoListApi.h"
#import "VideoListModel.h"
#import "VideoListCell.h"
#import "VideoInfoModel.h"
#import "VideoViewController.h"

@interface VideoListViewModel ()

@property (nonatomic, strong) VideoListModel *videoListModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation VideoListViewModel

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
    
    @weakify(self)
    [NetworkStateManager networkState:^{
        @strongify(self)
        VideoListApi *api = [[VideoListApi alloc] initWithPage:page];
        @weakify(self)
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            self.videoListModel = [self dataAnalysisFromJson: request.responseJSONObject request:api];
            
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithArray:self.videoListModel.videoList];
            }else{
                [self.dataArray addObjectsFromArray:self.videoListModel.videoList];
            }
            
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.videoListModel.bannerList);
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

//解析
- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request{
    ZFLog(@"\n-------------------------- Request result --------------------------\n %@ : %@", [request class], request.responseJSONObject);
    if ([request isKindOfClass:[VideoListApi class]]) {
        if ([json[@"msg"] isEqualToString:@"Success"]) {
            return [VideoListModel yy_modelWithJSON:json[@"data"]];
        }
        else {
             [MBProgressHUD showMessage:json[@"errors"]];
        }
    }
    return nil;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoListCell *cell = [VideoListCell videoListCellWithTableView:tableView IndexPath:indexPath];
    VideoInfoModel *videoInfoModel = self.dataArray[indexPath.row];
    cell.videoInfoModel = videoInfoModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoInfoModel *videoInfoModel = self.dataArray[indexPath.row];
    VideoViewController *videoController = [VideoViewController new];
    if ([NSStringUtils isEmptyString:videoInfoModel.videoId]) return;
    videoController.videoId = videoInfoModel.videoId;
    videoController.title = videoInfoModel.videoTitle;
    [self.controller.navigationController pushViewController:videoController animated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    if (![NSArrayUtils isEmptyArray:self.videoListModel.videoList]) {
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = ZFLocalizedString(@"VideoViewViewModel_NoData_Title",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(customView.mas_bottom).mas_offset(-120 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFMAIN_COLOR;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [button setTitle:ZFLocalizedString(@"VideoViewViewModel_Refresh",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emptyOperationTouch) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
        
    }else {
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"following_air_blank"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(customView.mas_centerY);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = ZFLocalizedString(@"VideoViewViewModel_NoData_Title",nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).offset(25);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = ZFMAIN_COLOR;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [button setTitle:ZFLocalizedString(@"VideoViewViewModel_Refresh",nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emptyOperationTouch) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        [customView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(33);
            make.centerX.mas_equalTo(customView.mas_centerX);
            make.width.mas_equalTo(@180);
            make.height.mas_equalTo(@40);
        }];
    }
    return customView;
}
@end
