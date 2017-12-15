//
//  CouponItemViewModel.m
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CouponItemViewModel.h"
#import "CouponItemApi.h"
#import "CouponItemModel.h"
#import "CouponItemCell.h"
#import "BannerModel.h"
#import "BannerManager.h"

@interface CouponItemViewModel ()
@property (nonatomic, strong) NSNumber *currentTime;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation CouponItemViewModel
//请求方法
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    if ([parmaters isEqualToString:LoadMore]) {
        self.currentPage++;
    }else{
        self.currentPage = 1;
    }
    
    CouponItemApi *api = [[CouponItemApi alloc] initWithKind:self.kind page:self.currentPage pageSize:15];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        @strongify(self)
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            self.currentPage = [requestJSON[@"result"][@"page"] integerValue];
            self.currentTime = requestJSON[@"result"][@"now_time"];
            
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[CouponItemModel class] json:requestJSON[@"result"][@"data"]];
            
            if (self.currentPage == 1) {
                self.dataSource = [NSMutableArray arrayWithArray:tempArray];
            } else {
                [self.dataSource addObjectsFromArray:tempArray];
            }
            
            
            if (self.dataSource.count == 0) {
                [self showNoDataInView:[self.controller valueForKey:@"tableView"] imageView:@"emptycoupon" titleLabel:ZFLocalizedString(@"MyCouponViewModel_NoData_TitleLabel",nil) button:nil buttonBlock:nil];
            }
            self.currentPage = [requestJSON[@"result"][@"page"] integerValue];
            
            self.totalPage = [requestJSON[@"result"][@"total_page"] integerValue];
        }
        if (self.currentPage == self.totalPage) {
            if (completion) {
                completion(NoMoreToLoad);
            }
        }else {
            if (completion) {
                completion(self.dataSource);
            }
        }
        
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        [self showNoDataInView:[self.controller valueForKey:@"tableView"] imageView:@"emptycoupon" titleLabel:ZFLocalizedString(@"MyCouponViewModel_NoData_TitleLabel",nil) button:nil buttonBlock:nil];
        
        if (failure) {
            failure(nil);
        }
        
    }];
}


#pragma mark - tablegateDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 15.0f;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15.0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponItemCell *cell = [CouponItemCell couponItemCellWithTableView:tableView indexPath:indexPath];
    cell.currentTime = self.currentTime;
    cell.couponType  = [self.kind integerValue];
    cell.couponModel = self.dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CouponItemModel *couponModel = self.dataSource[indexPath.section];
    cell.tagBtnActionHandle = ^{
        couponModel.isShowAll = !couponModel.isShowAll;
        [self.dataSource replaceObjectAtIndex:indexPath.section withObject:couponModel];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    cell.userItActionHandle = ^{
        BannerModel *model = [[BannerModel alloc] init];
        model.deeplink_uri = couponModel.deeplink_uri;
        [BannerManager doBannerActionTarget:self.controller withBannerModel:model];
        
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_UseIt_%@", couponModel.code] itemName:@"User It" ContentType:@"My - Coupon" itemCategory:@"Button"];
    };
    
    return cell;
}
@end
