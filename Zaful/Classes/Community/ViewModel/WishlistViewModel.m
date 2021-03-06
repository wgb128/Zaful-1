//
//  WishlistViewModel.m
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "WishlistViewModel.h"
#import "PostGoodsCell.h"
#import "ZFCollectionLikeApi.h"
#import "ZFCollectionListModel.h"
#import "WishlistViewController.h"
#import "GoodListModel.h"
#import "PostOrderListModel.h"
#import "CommendModel.h"

@interface WishlistViewModel ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ZFCollectionListModel *collectionModel;
@property (nonatomic,strong) NSMutableArray *allGoodsIDArray;
@end

@implementation WishlistViewModel

- (void)requestCollectionNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    NSInteger page = 1;
    if ([parmaters intValue] == 0) {
        // 假如最后一页的时候
        if ([self.collectionModel.page integerValue] == [self.collectionModel.total_page integerValue]) {
            if (completion) {
                completion(NoMoreToLoad);
            }
            return; // 直接返回
        }
        page = [self.collectionModel.page integerValue] + 1;
    }
    
    @weakify(self)
    ZFCollectionLikeApi *api = [[ZFCollectionLikeApi alloc] initWithCollectionWith:[AccountManager sharedManager].userId page:page pageSize:10];
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        @strongify(self)
        
        if (page == 1) {
            [self.dataArray removeAllObjects];
        }
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            
            self.collectionModel = [self dataAnalysisFromJson:requestJSON request:api];
            
            [self.dataArray addObjectsFromArray:self.collectionModel.data];
            
            //判断数据设置空页面
            self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoDataType;
            
            if (completion) {
                completion(self.collectionModel);
            }
        }
        
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        self.emptyViewShowType = self.dataArray.count > 0 ? EmptyViewHideType : EmptyShowNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request
{
    if ([request isKindOfClass:[ZFCollectionLikeApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [ZFCollectionListModel yy_modelWithJSON:json[@"result"]];
        }
        else
        {
             [MBProgressHUD showMessage:json[@"msg"]];
        }
    }
    return nil;
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostGoodsCell *cell = [PostGoodsCell postGoodsCellWithTableView:tableView andIndexPath:indexPath];
    ZFCollectionModel *model = self.dataArray[indexPath.row];
    WishlistViewController *wishVC = (WishlistViewController *)self.controller;
    [wishVC.wishDict[@"selectArray"] enumerateObjectsUsingBlock:^(ZFCollectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goods_id isEqualToString:model.goods_id]) {
            model.isSelected = YES;
        }
    }];
    cell.goodsListModel = model;
    
    @weakify(cell)
    cell.wishlistSelectBlock = ^(UIButton *selectBtn){
        @strongify(cell)
        [self.allGoodsIDArray removeAllObjects];
        @autoreleasepool {
            [wishVC.wishDict[@"selectArray"] enumerateObjectsUsingBlock:^(ZFCollectionModel *wishModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:wishModel.goods_id];
            }];
            
            [wishVC.wishDict[@"bagArray"] enumerateObjectsUsingBlock:^(GoodListModel *bagModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:bagModel.goods_id];
            }];
            
            [wishVC.wishDict[@"orderArray"] enumerateObjectsUsingBlock:^(PostOrderListModel *orderModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:orderModel.goods_id];
            }];
            
            [wishVC.wishDict[@"recentArray"] enumerateObjectsUsingBlock:^(CommendModel *recentModel, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.allGoodsIDArray addObject:recentModel.goodsId];
            }];
        }
        
        if ([self.allGoodsIDArray containsObject:cell.goodsListModel.goods_id]) {
            if (!selectBtn.selected) {
                ZFLog(@"点击相同的商品");
                [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_NoItem_Tip",nil)];
            }else{
                selectBtn.selected = !selectBtn.selected;
                [wishVC.wishDict[@"selectArray"] removeObject:model];
                [self.allGoodsIDArray removeObject:cell.goodsListModel.goods_id];
            }
        }else{
            if (self.allGoodsIDArray.count >= 6) {
                ZFLog(@"超过6个了");
                [self showAlertMessage:ZFLocalizedString(@"Post_ViewModel_Alert_MaxItem_Tip",nil)];
            }else{
                selectBtn.selected = !selectBtn.selected;
                cell.goodsListModel.isSelected = selectBtn.selected;
                [wishVC.wishDict[@"selectArray"] addObject:model];
                [PostGoodsManager sharedManager].isFirstTimeEnter = NO;
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
    imageView.image = [UIImage imageNamed:@"favorites"];
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
    titleLabel.text = ZFLocalizedString(@"WishlistViewModel_NoData_CannotFind",nil);
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
