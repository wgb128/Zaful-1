//
//  RecentViewModel.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "RecentViewModel.h"
#import "CartOperationManager.h"
#import "PostRecentCell.h"
#import "RecentViewController.h"
#import "ZFCollectionModel.h"
#import "GoodListModel.h"
#import "PostOrderListModel.h"

@interface RecentViewModel ()
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *allGoodsIDArray;
@end

@implementation RecentViewModel

- (void)requestRecentNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    //判断数据设置空页面
    self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostRecentCell *cell = [PostRecentCell postRecentCellWithTableView:tableView andIndexPath:indexPath];
    CommendModel *model = self.dataArray[indexPath.row];
    RecentViewController *recentVC = (RecentViewController *)self.controller;
    [recentVC.recentDict[@"selectArray"] enumerateObjectsUsingBlock:^(CommendModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goodsId isEqualToString:model.goodsId]) {
            model.isSelected = YES;
        }
    }];
    cell.goodsListModel = model;
    
    @weakify(cell)
    cell.recentSelectBlock = ^(UIButton *selectBtn){
        @strongify(cell)
        [self.allGoodsIDArray removeAllObjects];
        @autoreleasepool {
            [recentVC.recentDict[@"wishArray"] enumerateObjectsUsingBlock:^(ZFCollectionModel *wishModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:wishModel.goods_id];
            }];
            
            [recentVC.recentDict[@"bagArray"] enumerateObjectsUsingBlock:^(GoodListModel *bagModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:bagModel.goods_id];
            }];
            
            [recentVC.recentDict[@"orderArray"] enumerateObjectsUsingBlock:^(PostOrderListModel *orderModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:orderModel.goods_id];
            }];
            
            [recentVC.recentDict[@"selectArray"] enumerateObjectsUsingBlock:^(CommendModel *recentModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:recentModel.goodsId];
            }];
        }
        
            if ([self.allGoodsIDArray containsObject:cell.goodsListModel.goodsId]) {
                if (!selectBtn.selected) {
                    ZFLog(@"点击相同的商品");
                    [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_NoItem_Tip",nil)];
                }else{
                    selectBtn.selected = !selectBtn.selected;
                    [recentVC.recentDict[@"selectArray"] removeObject:model];
                    [self.allGoodsIDArray removeObject:cell.goodsListModel.goodsId];
                }

            } else{
                if (self.allGoodsIDArray.count >= 6) {
                    ZFLog(@"超过6个了");
                    [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_MaxItem_Tip",nil)];
                }else{
                    selectBtn.selected = !selectBtn.selected;
                    cell.goodsListModel.isSelected = selectBtn.selected;
                    [recentVC.recentDict[@"selectArray"] addObject:model];
                }
            }
    };
    
    return cell;
}

#pragma mark - UIAlertController
- (void)showAlertMessage:(NSString *)message {
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:message
                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    self.emptyViewManager.customNoDataView = [self makeCustomNoDataView];
    return [self.emptyViewManager accordingToTypeReBackView:self.emptyViewShowType];
}

#pragma mark make - privateCustomView(NoDataView)
- (UIView *)makeCustomNoDataView {
    UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
    customView.backgroundColor = ZFCOLOR(245, 245, 245, 1);
    
    YYAnimatedImageView *imageView = [YYAnimatedImageView new];
    imageView.image = [UIImage imageNamed:@"search_result"];
    [customView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(customView.mas_top).mas_offset(105 * DSCREEN_HEIGHT_SCALE);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = ZFCOLOR(170, 170, 170, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = ZFLocalizedString(@"RecentViewModel_NoData_Title",nil);
    [customView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(customView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    
    return customView;
}

#pragma mark - Setter/Getter
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray= [NSArray new];
        _dataArray = [CartOperationManager sharedManager].commendList;
        
    }
    return _dataArray;
}

- (NSMutableArray *)allGoodsIDArray {
    if (!_allGoodsIDArray) {
        _allGoodsIDArray= [NSMutableArray new];
    }
    return _allGoodsIDArray;
}

@end
