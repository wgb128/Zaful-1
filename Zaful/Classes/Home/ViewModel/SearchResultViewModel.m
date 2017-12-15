//
//  SearchResultViewModel.m
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SearchResultViewModel.h"

#import "HomeAndCategoryCell.h"
//#import "GoodsDetailViewController.h"

#import "SearchResultApi.h"

#import "SearchResultModel.h"

#import "SearchResultHeadView.h"

#import "GoodsSortViewController.h"

#import "SearchResultViewController.h"

#import "ZFGoodsDetailViewController.h"

@interface SearchResultViewModel ()

@property (nonatomic, strong) SearchResultModel * searchResultModel;
@property (nonatomic, strong) NSMutableArray    * dataArray;
@property (nonatomic, assign) NSInteger           selectSortIndex;//记录当前页面选择的排序方式的行数
@property (nonatomic, copy)   NSString          * orderby;//排序方式
@end

@implementation SearchResultViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure
{
    @weakify(self)
    [NetworkStateManager networkState:^{
        @strongify(self)
        @weakify(self)
        NSArray * array = (NSArray *)parmaters;
        NSInteger page = 1;
        if (self.orderby == nil) {
            self.orderby = @"";
        }
        
        if ([array[0] integerValue] == 0) {
            // 假如最后一页的时候
            if (self.searchResultModel.cur_page  == self.searchResultModel.total_page ) {
                if (completion) {
                    completion(NoMoreToLoad);
                }
                return; // 直接返回
            }
            page = self.searchResultModel.cur_page  + 1;
        }
        
        SearchResultApi *api = [[SearchResultApi alloc] initSearchResultApiWithSearchString:array[1] withPage:page withSize:10 withOrderby:self.orderby];
        
        [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
            @strongify(self)
            id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
            self.searchResultModel = [ self dataAnalysisFromJson:requestJSON request:request];
            if (page == 1) {
                if (!self.dataArray) {
                    self.dataArray = [NSMutableArray array];
                }else
                    [self.dataArray removeAllObjects];
            }
            // 谷歌统计
            [self analyticsSearchWithModel:self.searchResultModel];
            [self.dataArray addObjectsFromArray:self.searchResultModel.goodsArray];
            
            if (!self.dataArray.count) {
                self.loadingViewShowType = LoadingViewNoDataType;
            }
            if (completion) {
                completion(self.dataArray);
            }
        } failure:^(__kindof SYBaseRequest *request, NSError *error) {
            @strongify(self)
            self.loadingViewShowType = LoadingViewNoNetType;
            if (failure) {
                failure(nil);
            }
        }];
    } exception:^{
        @strongify(self)
        self.loadingViewShowType = LoadingViewNoNetType;
        if (failure) {
            failure(nil);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {

    if ([request isKindOfClass:[SearchResultApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return  [SearchResultModel yy_modelWithJSON:json[@"result"]];
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self)
    HomeAndCategoryCell*cell = [HomeAndCategoryCell homeAndCategoryCollectionViewWith:collectionView forIndexPath:indexPath forRow:indexPath.row];
    cell.goodsModel = self.dataArray[indexPath.row];
    cell.goodsClick = ^(GoodsModel * goodModel) {
        @strongify(self)
        ZFGoodsDetailViewController * goods = [[ZFGoodsDetailViewController alloc]init];
        goods.goodsId = [NSString stringWithFormat:@"%ld",(long)goodModel.goods_id];
        goods.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:goods animated:YES];
        // 谷歌统计
        [ZFAnalytics clickProductWithProduct:goodModel position:(int)self.searchResultModel.cur_page actionList:[NSString stringWithFormat:@"Search - %@", self.searchTitle]];
        
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_SearchResult_Goods_%ld", goodModel.goods_id] itemName:goodModel.goods_title ContentType:@"Goods" itemCategory:@"Goods"];
    };
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((SCREEN_WIDTH-34)/2,276 * DSCREEN_WIDTH_SCALE);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SearchResultHeadView * headView = [SearchResultHeadView SearchResultHeadWithCollectionView:collectionView Kind:kind IndexPath:indexPath];
    @weakify(self)
    headView.sortClick  = ^{
        @strongify(self)
        GoodsSortViewController * goods = [[GoodsSortViewController alloc]init];
        goods.selectIndex = _selectSortIndex;
        //选好的回来赋值
        @weakify(self)
        goods.sortBlock = ^(NSInteger selectType,NSString * orderby)
        {
            @strongify(self)
            self.selectSortIndex =  selectType;
            self.orderby = orderby;
            //这里重新请求数据
            if (self.searchResultReloadDataCompletionHandler) {
                self.searchResultReloadDataCompletionHandler();
            }
        };
        goods.hidesBottomBarWhenPushed = YES;
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:goods];
        nav.navigationBar.translucent = NO;
        [self.viewController presentViewController:nav animated:YES completion:^{
        }];
    };
    return headView;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return  UIEdgeInsetsMake(0, 12, 0, 12);
 
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
        text = [NSString stringWithFormat:ZFLocalizedString(@"Search_ResultViewModel_Tip",nil),self.searchTitle];
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
        return  [UIImage imageNamed:@" "];//[UIImage imageNamed:@"search_loading"];
    }
    return [UIImage imageNamed:@" "];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loadingViewShowType == LoadingViewIsShow) {
        UIView * view = [[UIView alloc]init];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"loading"]];
        imageView.center = view.center;
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
        }];
        return view;
    }
    return nil;
}

#pragma mark - 谷歌统计
- (void)analyticsSearchWithModel:(SearchResultModel *)model {
    NSArray *goodsList = model.goodsArray;
    if (goodsList.count == 0) {
        return;
    }
    NSString *event = nil;
    if (model.cur_page != 1) {
        event = @"LoadMoreProducts";
    }
    NSString *GAName = [NSString stringWithFormat:@"Search - %@", self.searchTitle];
//    [ZFAnalytics showCategoryProductsWithProducts:goodsList position:(int)model.cur_page impressionList:GAName screenName:@"Search" event:event];
    
    [ZFAnalytics showSearchProductsWithProducts:goodsList position:(int)model.cur_page impressionList:GAName screenName:@"Search"  event:event];
}
@end
