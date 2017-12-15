//
//  HomeViewModel.m
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HomeViewModel.h"
#import "SearchResultViewController.h"
#import "HomeAndCategoryCell.h"
#import "HomeApi.h"
#import "HomeModel.h"
#import "HomeBannerCell.h"
#import "HomeCategoryCell.h"
#import "HomeSpecialCell.h"
#import "HomeGoodsHeadView.h"
#import "ZFHomeFloatingView.h"
#import "ZFGoodsDetailViewController.h"

@interface  HomeViewModel()

@property (nonatomic, strong) HomeModel * homeModel;
/** Home banner数据*/
@property (nonatomic, strong) NSArray * bannerArray;
/** 分类 banner数据*/
@property (nonatomic, strong) NSMutableArray * categoryArray;
/** 专题 banner数据*/
@property (nonatomic, strong) NSMutableArray * specialArray;

@property (nonatomic, strong) NSMutableArray * goodsArray;

@property (nonatomic, strong) NSMutableArray *floatArray;

@property (nonatomic, strong) ZFHomeFloatingView *homeFloatingView;

@end

@implementation HomeViewModel

- (void)requestNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure {
    HomeApi * api = [[HomeApi alloc] init];
    {
        if (api.cacheJSONObject) {
            self.homeModel =   [self dataAnalysisFromJson:api.cacheJSONObject request:api];
            self.bannerArray   = _homeModel.advArray;
            self.categoryArray = _homeModel.categoryArray;
            self.specialArray  = _homeModel.bannerArray;
            self.goodsArray    = _homeModel.goodsArray;
            
            [self googleAnalytic];
            [self showHomeFloatViewWithCompletion:completion];
            
            if (completion) {
                completion(nil);
            }
        }
    }
    
    [api startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(api.class)];
        self.homeModel =   [self dataAnalysisFromJson: requestJSON request:api];
        self.bannerArray   = _homeModel.advArray;
        self.categoryArray = _homeModel.categoryArray;
        self.specialArray  = _homeModel.bannerArray;
        self.goodsArray    = _homeModel.goodsArray;
        self.floatArray    = _homeModel.floatArray;
        
        [self googleAnalytic];
        [self showHomeFloatViewWithCompletion:completion];
        
        if (completion) {
            completion(nil);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        if (failure) {
            failure(_homeModel.advArray);
        }
    }];
}

- (id)dataAnalysisFromJson:(id)json request:(SYBaseRequest *)request {
    if (!json) {
        return nil;
    }
    if ([request isKindOfClass:[HomeApi class]]) {
        if ([json[@"statusCode"] integerValue] == 200) {
            return [HomeModel  yy_modelWithJSON:json[@"result"]];
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.bannerArray.count == 0 ? 0 : 1;
            break;
        case 1:
            return self.categoryArray.count;
            break;
        case 2:
            return self.specialArray.count;
            break;
        case 3:
            return  self.goodsArray.count;
            break;
        default:
            break;
    }
    return 0;
}

//构建单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            HomeBannerCell *cell = [HomeBannerCell homeBannerCollectionViewWith:collectionView forIndexPath:indexPath];
            cell.bannerModelArray = self.bannerArray;
            //点击事件的回调
            cell.homeBannerClick = ^(BannerModel *headModel) {
                [BannerManager doBannerActionTarget:self.viewController withBannerModel:headModel];
                // 谷歌统计
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"Home - HomeBannerScroll" label:@"Cate - HomeBannerScroll Tab"];

                NSString *GABannerId = headModel.key;
                NSString *GABannerName = [NSString stringWithFormat:@"HomeBannerScroll - %@",headModel.title];
                NSString *position = [NSString stringWithFormat:@"HomeBannerScroll - P%ld",(long)(indexPath.row + 1)];
                [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
                // 统计
                [ZFAnalytics appsFlyerTrackEvent:@"af_view_list" withValues:@{
                                                                              @"af_content_type" : [NSString stringWithFormat:@"HomeBanner/%@", headModel.title]
                                                                              }];
                
                // firebase 统计
                NSIndexPath *virtualIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                for (NSInteger i = 0; i < self.bannerArray.count; i++) {
                    BannerModel *model = [self.bannerArray objectAtIndex:i];
                    if ([model.title isEqualToString:headModel.title]) {
                        virtualIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                        break;
                    }
                }
                NSString *itemId = [NSString stringWithFormat:@"impression_Home_banner%ld.%ld_%@", indexPath.section + 1, indexPath.row + 1, headModel.title];
                [ZFFireBaseAnalytics selectContentWithItemId:itemId itemName:headModel.title ContentType:@"Home - Banner" itemCategory:@"scroll_banner"];
                
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:itemId label:itemId];
            };
            return cell;
        }
            break;
        case 1: {
            HomeCategoryCell * cell = [HomeCategoryCell homeCategoryCollectionViewWith:collectionView forIndexPath:indexPath];
            cell.homeCategoryBanner = _categoryArray[indexPath.row];

            // 点击事件
            cell.homeCategoryBannerClick= ^(BannerModel *categoryModel) {
                [BannerManager doBannerActionTarget:self.viewController withBannerModel:categoryModel];
                
                // 谷歌统计
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"Home - HomeBannerNew" label:@"Cate - HomeBannerNew Tab"];
                NSString *GABannerId = categoryModel.key;
                NSString *GABannerName = [NSString stringWithFormat:@"HomeBannerNew - %@",categoryModel.title];
                NSString *position = [NSString stringWithFormat:@"HomeBannerNew - P%ld",(long)(indexPath.row + 1)];
                [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
                // 统计
                [ZFAnalytics appsFlyerTrackEvent:@"af_view_list" withValues:@{
                                                                              @"af_content_type" : [NSString stringWithFormat:@"HomeBanner/%@", categoryModel.title]
                                                                              }];
                NSString *itemId = [NSString stringWithFormat:@"impression_Home_banner%ld.%ld_%@", indexPath.section + 1, indexPath.row + 1, categoryModel.title];
                [ZFFireBaseAnalytics selectContentWithItemId:itemId itemName:categoryModel.title ContentType:@"Home - Banner" itemCategory:@"category_banner"];
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:itemId label:itemId];
            };
            return cell;
        }
            break;
            
        case 2: {
            HomeSpecialCell * cell = [HomeSpecialCell homeSpecialCollectionViewWith:collectionView forIndexPath:indexPath];
            cell.homeBannerModel = _specialArray[indexPath.row];
            
            cell.specialClick = ^(BannerModel * homeBannerModel) {

                [BannerManager doBannerActionTarget:self.viewController withBannerModel:homeBannerModel];

                // 谷歌统计
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:@"Home - HomeBannerSession" label:@"Cate - HomeBannerSession Tab"];
                NSString *GABannerId = homeBannerModel.key;
                NSString *GABannerName = [NSString stringWithFormat:@"HomeBannerSession - %@",homeBannerModel.title];
                NSString *position = [NSString stringWithFormat:@"HomeBannerSession - P%ld",(long)(indexPath.row + 1)];
                [ZFAnalytics clickAdvertisementWithId:GABannerId name:GABannerName position:position];
                // 统计
                [ZFAnalytics appsFlyerTrackEvent:@"af_view_list" withValues:@{
                                                                              @"af_content_type" : [NSString stringWithFormat:@"HomeBanner/%@", homeBannerModel.title]
                                                                              }];
                NSString *itemId = [NSString stringWithFormat:@"impression_Home_banner%ld.%ld_%@", indexPath.section + 1, indexPath.row + 1, homeBannerModel.title];
                [ZFFireBaseAnalytics selectContentWithItemId:itemId itemName:homeBannerModel.title ContentType:@"Home - Banner" itemCategory:@"topic_banner"];
                [ZFAnalytics clickButtonWithCategory:@"Home" actionName:itemId label:itemId];
            };
            return cell;
        }
            break;
        case 3: {
            HomeAndCategoryCell *cell = [HomeAndCategoryCell homeAndCategoryCollectionViewWith:collectionView forIndexPath:indexPath forRow:indexPath.row];
            cell.goodsModel = _goodsArray[indexPath.row];
            cell.goodsClick = ^(GoodsModel * goodsModel) {
                ZFGoodsDetailViewController *vc = [ZFGoodsDetailViewController new];
                vc.goodsId = [NSString stringWithFormat:@"%ld",(long)goodsModel.goods_id];
                vc.hidesBottomBarWhenPushed = YES;
                [_viewController.navigationController pushViewController:vc animated:YES];
                //谷歌统计
                [ZFAnalytics clickProductWithProduct:goodsModel position:1 actionList:@"Home - List"];
                
                [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Channel_%@_Goods_%ld", self.viewController.title, goodsModel.goods_id] itemName:goodsModel.goods_title ContentType:@"Goods" itemCategory:@"Goods"];
            };
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(SCREEN_WIDTH, 300 * DSCREEN_WIDTH_SCALE);
            
            break;
            
        case 1:
            return CGSizeMake((SCREEN_WIDTH - 5) * 0.5,190*DSCREEN_WIDTH_SCALE);
            
            break;
            
        case 2:
        {
            BannerModel *model = _specialArray[indexPath.row];
            CGFloat bannerHeight = [model.banner_height floatValue] * 0.5;
            return CGSizeMake(SCREEN_WIDTH, bannerHeight * DSCREEN_WIDTH_SCALE);
        }
            break;
            
        case 3:
            return CGSizeMake((SCREEN_WIDTH-48)/2,218 * DSCREEN_WIDTH_SCALE + 58);
            
            break;
            
        default:
            break;
    }
    return CGSizeMake(0, 0);
}

//定义每个UICollectionView 横向向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  
    if(section == 2) {
        return 5.0f;
    } else if (section == 3) {
        return 5.0f;
    } else if (section == 1) {
        return 5.0f;
    }
    else
        return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 3) {
        return 5.0f;
    } else if (section == 1) {
        return 5.0f;
    }
    else
        return 0.0f;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    HomeGoodsHeadView * headView;
    headView = [HomeGoodsHeadView homeGoodsHeadViewWithCollectionView:collectionView Kind:kind IndexPath:indexPath];
    if ([kind isEqualToString: UICollectionElementKindSectionHeader] ) {
        if (indexPath.section == 3) {
            headView.titleLabel.hidden = NO;
            headView.titleLabel.text = ZFLocalizedString(@"Home_SectionHeader_Title",nil);
            headView.titleLabel.adjustsFontSizeToFitWidth = YES;
            return headView;
        } else {
            headView.titleLabel.hidden = YES;
            return headView;
        }
    } else if ([kind isEqualToString: UICollectionElementKindSectionFooter]) {
        headView.titleLabel.hidden = YES;
        return headView;
    }
    return headView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 64);
    } else if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 5);
    } else if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 5);
    } else {
        return CGSizeMake(0, 0);
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    //分类跳转
    if (indexPath.section ==1) {
        BannerModel *model = _categoryArray[indexPath.row];
        [BannerManager doBannerActionTarget:self.viewController withBannerModel:model];
    } else if (indexPath.section ==3) {
        GoodsModel *goodsModel = _goodsArray[indexPath.row];
        ZFGoodsDetailViewController * goods = [[ZFGoodsDetailViewController alloc]init];
        goods.goodsId = [NSString stringWithFormat:@"%ld",(long)goodsModel.goods_id];
        [_viewController.navigationController pushViewController:goods animated:YES];
        //谷歌统计
        [ZFAnalytics clickProductWithProduct:goodsModel position:1 actionList:@"Home - List"];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section ==3) {
       return  UIEdgeInsetsMake(0, 16, 0, 16);
    } else {
        return  UIEdgeInsetsMake(0, 0, 0, 0);
    }
}


#pragma mark ---- Data Source Implementation ----

/* The attributed string for the description of the empty state */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"";
    if (self.loadingViewShowType == LoadingViewNoNetType) {
        text = ZFLocalizedString(@"Global_NO_NET_404",nil);
    }else if(self.loadingViewShowType == LoadingViewNoDataType) {
        text = ZFLocalizedString(@"Global_VC_NO_DATA",nil);
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
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return ZFCOLOR(245, 245, 245, 1.0); // redColor whiteColor
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.loadingViewShowType == LoadingViewNoNetType){
        return [UIImage imageNamed:@"wifi"];
    }else if(self.loadingViewShowType == LoadingViewNoDataType) {
        return  [UIImage imageNamed:@" "];// [UIImage imageNamed:@"search_loading"];
    }
    return [UIImage imageNamed:@" "];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
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

#pragma mark - private method
- (void)showHomeFloatViewWithCompletion:(void (^)(id))completion {
    if (self.floatArray.count > 0) {
        static BOOL isFirstLoading = YES;
        if (isFirstLoading) {
            
            isFirstLoading = NO;
            BannerModel *floatModel = self.floatArray[0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kHomeFloatingViewShowNotice object:floatModel];
        }
    }
}

#pragma mark - 懒加载
/**
 *
 *Homebanner数据
 */

- (NSMutableArray *)categoryArray {
    if (_categoryArray == nil) {
        _categoryArray = [NSMutableArray array];
    }
    return _categoryArray;
}

- (NSMutableArray *)specialArray {
    if (_specialArray == nil) {
        _specialArray = [NSMutableArray array];
    }
    return _specialArray;
}

- (NSMutableArray *)goodsArray {
    if (_goodsArray == nil) {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

#pragma mark - 谷歌统计
- (void)googleAnalytic {
    // 谷歌统计
    if (self.bannerArray.count > 0) {
        [self analyticsHomeBannerWithBannerArray:self.bannerArray name:@"HomeBannerScroll"];
    }
    // 谷歌统计
    if (self.categoryArray.count > 0) {
        [self analyticsHomeBannerWithBannerArray:self.categoryArray name:@"HomeBannerNew"];
    }
    // 谷歌统计
    if (self.specialArray.count > 0) {
        [self analyticsHomeBannerWithBannerArray:self.specialArray name:@"HomeBannerSession"];
    }
    
    if (self.goodsArray.count > 0) {
        // 谷歌统计
        [ZFAnalytics showProductsWithProducts:self.goodsArray position:1 impressionList:@"Home - List" screenName:@"Home" event:nil];
    }
    
    if (self.floatArray.count > 0) {
        [self analyticsHomeBannerWithBannerArray:self.floatArray name:@"HomeFloatingWindow"];
    }
}

- (void)analyticsHomeBannerWithBannerArray:(NSArray<BannerModel *> *)banners name:(NSString *)name{
    NSMutableArray *screenNames = [NSMutableArray array];
    for (int i = 0; i < banners.count; i++) {
        BannerModel * banner = banners[i];
        NSString *screenName = [NSString stringWithFormat:@"%@ - %@",name,banner.title];
        NSString *position = [NSString stringWithFormat:@"%@ - P%d",name, i+1];
        [screenNames addObject:@{@"name":screenName,@"position":position}];
    }
    [ZFAnalytics showAdvertisementWithBanners:screenNames position:nil screenName:@"Home"];
}



@end
