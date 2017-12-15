//
//  MyCouponViewModel.m
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MyCouponViewModel.h"
#import "MyCouponApi.h"
#import "MyCouponsListModel.h"
#import "CouponCell.h"

@interface MyCouponViewModel ()
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyCouponViewModel

//请求方法
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    if ([parmaters isEqualToString:LoadMore]) {
        self.currentPage++;
    }else{
        self.currentPage = 1;
    }
    
    MyCouponApi *api = [[MyCouponApi alloc] initWithPage:self.currentPage pageSize:10];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        @strongify(self)
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            self.currentTime = requestJSON[@"now_time"];
            
            NSArray *tempArray = [NSArray yy_modelArrayWithClass:[MyCouponsListModel class] json:requestJSON[@"result"][@"data"]];
            
            if (self.currentPage == 1) {
                if (!_dataSource) {
                    _dataSource = [NSMutableArray array];
                }else
                    [_dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:tempArray];
            
            if (self.dataSource.count == 0) {
                [self showNoDataInView:self.tableView imageView:@"emptycoupon" titleLabel:ZFLocalizedString(@"MyCouponViewModel_NoData_TitleLabel",nil) button:nil buttonBlock:nil];
            }
            self.currentPage = [requestJSON[@"page"] integerValue];
            
            self.totalPage = [requestJSON[@"total_page"] integerValue];
            
        }
        if (completion) {
            completion(self.dataSource);
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        if (failure) {
            failure(nil);
        }

    }];
}


#pragma mark - tablegateDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 10;
    }
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CouponCell class])];
    cell.currentTime = self.currentTime;
    cell.couponModel = self.dataSource[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
