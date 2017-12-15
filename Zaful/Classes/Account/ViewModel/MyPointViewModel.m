//
//  MyPointViewModel.m
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MyPointViewModel.h"
#import "MyPointsApi.h"
#import "PointsModel.h"
#import "MyPointsCell.h"

@interface MyPointViewModel ()
@property (nonatomic, assign) NSUInteger            currentPage;

@property (nonatomic, assign) NSUInteger            totalPage;

@property (nonatomic, strong) NSMutableArray        *dataSource;
@end

@implementation MyPointViewModel

//请求方法
- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    NSArray * array = (NSArray *)parmaters;
    if ([array[0] integerValue] == 0) {
        // 假如最后一页的时候
        if (_currentPage  == _totalPage) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            
        }
        _currentPage++;
    } else {
        _currentPage = 1;
    }
    MyPointsApi *api = [[MyPointsApi alloc]initDRewardsApiWithPage:_currentPage withSize:10];
    @weakify(self)
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            _currentPage = [requestJSON[@"result"][@"page"] integerValue];
            NSArray *array = [NSArray yy_modelArrayWithClass:[PointsModel class] json:requestJSON[@"result"][@"data"]];
            _headerLabel.text = [NSString stringWithFormat:@"%d",(int)[requestJSON[@"result"][@"avaid_point"] integerValue]];
            if (_currentPage == 1) {
                self.dataSource = [NSMutableArray arrayWithArray:array];
            } else {
                [self.dataSource addObjectsFromArray:array];
            }
            
            if (!self.dataSource.count) {
                self.loadingViewShowType = LoadingViewNoDataType;
            }
            if (completion) {
                completion(self.dataSource);
            }
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        @strongify(self)
        self.loadingViewShowType = LoadingViewNoNetType;
        
        if (failure) {
            failure(nil);
        }
    }];
    
}


#pragma mark - tableviewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyPointsCell *cell = [MyPointsCell pointCellWithTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark ---- Data Source Implementation ----

/* The attributed string for the description of the empty state */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    if (self.loadingViewShowType == LoadingViewNoNetType) {
        text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    }else if(self.loadingViewShowType == LoadingViewNoDataType)
    {
        text = ZFLocalizedString(@"MyPoints_EmptyData_Tip",nil);
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/* The background color for the empty state */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return ZFCOLOR(245, 245, 245, 1.0); // redColor whiteColor
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loadingViewShowType == LoadingViewNoNetType){
        return [UIImage imageNamed:@"wifi"];
    }else if(self.loadingViewShowType == LoadingViewNoDataType)
    {
        return  [UIImage imageNamed:@"ic_point"];
    }
    return nil;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}


@end
