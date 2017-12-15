//
//  BagViewModel.m
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BagViewModel.h"
#import "CartListApi.h"
#import "GoodListModel.h"
#import "PostBagCell.h"
#import "BagViewController.h"
#import "ZFCollectionModel.h"
#import "PostOrderListModel.h"
#import "CommendModel.h"


@interface BagViewModel ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *allGoodsIDArray;
@end

@implementation BagViewModel

- (void)requestBagNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure {
    __block NSArray *goodsArray = nil;
    @weakify(self)
    CartListApi *carListApi = [[CartListApi alloc] init];
    [carListApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(carListApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200){
            goodsArray = [NSArray yy_modelArrayWithClass:[GoodListModel class] json:requestJSON[@"result"]];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:goodsArray];
        }
        //判断数据设置空页面
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
        if (completion) {
            completion(goodsArray);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostBagCell *cell = [PostBagCell postBagCellWithTableView:tableView andIndexPath:indexPath];
    GoodListModel *model = self.dataArray[indexPath.row];
    BagViewController *bagVC = (BagViewController *)self.controller;
    [bagVC.bagDict[@"selectArray"] enumerateObjectsUsingBlock:^(GoodListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goods_id isEqualToString:model.goods_id]) {
            model.isSelected = YES;
        }
    }];
    cell.goodListModel = model;
    
    @weakify(cell)
    cell.bagSelectBlock = ^(UIButton *selectBtn){
        @strongify(cell)
        [self.allGoodsIDArray removeAllObjects];
        @autoreleasepool {
            [bagVC.bagDict[@"selectArray"] enumerateObjectsUsingBlock:^(GoodListModel *bagModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:bagModel.goods_id];
            }];
            
            [bagVC.bagDict[@"wishArray"] enumerateObjectsUsingBlock:^(ZFCollectionModel *wishModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:wishModel.goods_id];
            }];
            
            [bagVC.bagDict[@"orderArray"] enumerateObjectsUsingBlock:^(PostOrderListModel *orderModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:orderModel.goods_id];
            }];
            
            [bagVC.bagDict[@"recentArray"] enumerateObjectsUsingBlock:^(CommendModel *recentModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:recentModel.goodsId];
            }];
        }
        
            if ([self.allGoodsIDArray containsObject:cell.goodListModel.goods_id]) {
                if (!selectBtn.selected) {
                    ZFLog(@"点击相同的商品");
                    [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_NoItem_Tip",nil)];
                }else{
                    selectBtn.selected = !selectBtn.selected;
                    [bagVC.bagDict[@"selectArray"] removeObject:model];
                    [self.allGoodsIDArray removeObject:cell.goodListModel.goods_id];
                    
                }

            }else{
                if (self.allGoodsIDArray.count >= 6) {
                    ZFLog(@"超过6个了");
                    [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_MaxItem_Tip",nil)];
                }else{
                    selectBtn.selected = !selectBtn.selected;
                    cell.goodListModel.isSelected = selectBtn.selected;
                    [bagVC.bagDict[@"selectArray"]  addObject:model];
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
    imageView.image = [UIImage imageNamed:@"blank_bag"];
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
    titleLabel.text = ZFLocalizedString(@"CartViewModel_NoData_TitleLabel",nil);
    [customView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    
    return customView;
}

#pragma mark - Setter/Getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray= [NSMutableArray new];
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
