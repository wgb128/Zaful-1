//
//  ZFGoodsDetailViewController.m
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailViewController.h"
#import "ZFCartViewController.h"
#import "ZFWebViewViewController.h"
#import "ZFGoodsDetailReviewViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFGoodsDetailViewModel.h"
#import "GoodsDetailsReviewsImageListModel.h"
#import "ZFGoodsDetailNavigationView.h"
#import "ZFGoodsDetailAddCartView.h"
#import "ZFGoodsDetailSelectTypeView.h"
#import "ZFBannerScrollView.h"
#import "ZFShareView.h"
#import "ZFShareTopView.h"
#import "ZFGoodsDetailInfoView.h"
#import "ZFGoodsDetailQualifiedView.h"
#import "ZFGoodsDetailSizeSelectView.h"
#import "ZFGoodsDetailLinkInfoView.h"
#import "ZFGoodsDetailReviewsHeaderView.h"
#import "ZFGoodsDetailReviewInfoTableViewCell.h"
#import "ZFReviewViewMoreTableViewCell.h"
#import "ZFGoodsDetailRecommendView.h"
#import "ZFGoodsDetailSepareEmptyView.h"
#import "NativeShareModel.h"
#import "ZFShareManager.h"
#import "GoodsDetailModel.h"
#import "CommendModel.h"
#import "ZFGoodsDetailTypeModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "YYPhotoBrowseView.h"

static NSString *const kZFGoodsDetailInfoViewIdentifier = @"kZFGoodsDetailInfoViewIdentifier";
static NSString *const kZFGoodsDetailQualifiedViewIdentifier = @"kZFGoodsDetailQualifiedViewIdentifier";
static NSString *const kZFGoodsDetailSizeSelectViewIdentifier = @"kZFGoodsDetailSizeSelectViewIdentifier";
static NSString *const kZFGoodsDetailLinkInfoViewIdenfier = @"kZFGoodsDetailLinkInfoViewIdenfier";
static NSString *const kZFGoodsDetailReviewsHeaderViewIdentifier = @"kZFGoodsDetailReviewsHeaderViewIdentifier";
static NSString *const kZFGoodsDetailReviewInfoTableViewCellIdentifier = @"kZFGoodsDetailReviewInfoTableViewCellIdentifier";
static NSString *const kZFReviewViewMoreTableViewCellIdentifier = @"kZFReviewViewMoreTableViewCellIdentifier";
static NSString *const kZFGoodsDetailRecommendViewIdentifier = @"kZFGoodsDetailRecommendViewIdentifier";
static NSString *const kZFGoodsDetailSepareEmptyViewIdentifier = @"kZFGoodsDetailSepareEmptyViewIdentifier";

@interface ZFGoodsDetailViewController () <ZFInitViewProtocol, ZFShareViewDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ZFBannerScrollViewDelegate> {
    __block NSInteger            _goodsNumber;
    __block BOOL                 _loadMoreReviews;
    __block BOOL                 _hasChooseSize;
    __block BOOL                 _hasLayout;
}

@property (nonatomic, strong) UIView                            *containView;
@property (nonatomic, strong) ZFGoodsDetailNavigationView       *navigationView;
@property (nonatomic, strong) UIButton                          *backButton;
@property (nonatomic, strong) UIButton                          *shareButton;
@property (nonatomic, strong) ZFBannerScrollView                *bannerView;//轮播图
@property (nonatomic, strong) ZFGoodsDetailAddCartView          *addCartView;
@property (nonatomic, strong) ZFGoodsDetailSelectTypeView       *selectView;
@property (nonatomic, strong) UITableView                       *tableView;
@property (nonatomic, strong) ZFShareView                       *shareView;
@property (nonatomic, strong) YYPhotoBrowseView                 *browseView;
@property (nonatomic, strong) GoodsDetailModel                  *detailModel;
@property (nonatomic, strong) ZFGoodsDetailViewModel            *viewModel;

@property (nonatomic, strong) CABasicAnimation                  *backAnimation;
@property (nonatomic, strong) CABasicAnimation                  *frontAnimation;

@property (nonatomic, strong) UIImageView                       *animationView;
@property (nonatomic, strong) UIBezierPath                      *bezierPath;
@property (nonatomic, strong) NSMutableArray                    *imageViews;
@property (nonatomic, strong) NSMutableArray<YYPhotoGroupItem *>    *items;
@property (nonatomic, strong) NSMutableArray<ZFGoodsDetailTypeModel *>   *dataArray;

@end

@implementation ZFGoodsDetailViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self->_hasChooseSize = NO;
    self->_hasLayout = NO;
    self->_loadMoreReviews = YES;
    self->_goodsNumber = 1;
    [self requestGoodsDetailInfo];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.addCartView changeCartNumberInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - action methods
- (void)jumpToCartViewController {
    ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
    [self.navigationController pushViewController:cartVC animated:YES];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag" itemName:@"GoodsDetail_Bag" ContentType:@"Bag" itemCategory:@"Bag"];
}

- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAction:(UIButton *)sender {
    ZFShareTopView *topView = [[ZFShareTopView alloc] init];
    GoodsDetailPictureModel *pictureModel = (GoodsDetailPictureModel *)self.detailModel.pictures.firstObject;
    topView.imageName = pictureModel.img_url;
    topView.title = self.detailModel.goods_name;
    self.shareView.topView = topView;
    
    [self.shareView open];
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Product Detail - Share" actionName:@"Product Detail - Share" label:@"Product Detail - Share"];
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_GoodsDetail_Share_%@", self.detailModel.goods_id] itemName:@"GoodsDetail Share" ContentType:@"Share" itemCategory:@"Button"];
}

#pragma mark - private methods
- (void)requestGoodsDetailInfo {
    
    @weakify(self);
    
    [self.viewModel requestNetwork:self.goodsId completion:^(id obj) {
        @strongify(self);
        self.detailModel = obj;
        self.selectView.model = self.detailModel;
        self.navigationView.imageUrl = self.detailModel.pictures.firstObject.wp_image;
        [self configGoodsDetailUserInterface];
        [self refreshGoodsImagesInfo];
        self.addCartView.model = self.detailModel;
        self->_hasLayout = YES;
        [self addLookHistoryInfo];
        [ZFFireBaseAnalytics scanGoodsWithGoodsModel:self.detailModel];
        
    } failure:^(id obj) {
        
    }];
}

//收藏
- (void)addGoodsCollectionOption {
    @weakify(self);
    [self.viewModel requestCollectionGoodsNetwork:self.goodsId completion:^(id obj) {
        @strongify(self);
        self.detailModel.is_collect = @"1";
        self.detailModel.like_count = [NSString stringWithFormat:@"%lu", [self.detailModel.like_count integerValue] + 1];
        [self.tableView reloadData];
        //添加收藏商品通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kCollectionGoodsNotification object:nil];
        [ZFFireBaseAnalytics addCollectionWithGoodsModel:self.detailModel];
    } failure:^(id obj) {
        @strongify(self);
        self.detailModel.is_collect = @"0";
        [self.tableView reloadData];
    }];
    
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"GoodsDetail_Goods_%@", self.detailModel.goods_id] itemName:@"Goods_Collection" ContentType:@"Goods_Collection" itemCategory:@"Button"];
}

//取消收藏
- (void)deleteGoodsCollectionOption {
    @weakify(self);
    [self.viewModel requestDeleteGoodsNetwork:self.goodsId completion:^(id obj) {
        @strongify(self);
        self.detailModel.is_collect = @"0";
        self.detailModel.like_count = [NSString stringWithFormat:@"%lu", [self.detailModel.like_count integerValue] - 1];
        [self.tableView reloadData];
        //添加收藏商品通知
        [[NSNotificationCenter defaultCenter]postNotificationName:kCollectionGoodsNotification object:nil];
    } failure:^(id obj) {
        @strongify(self);
        self.detailModel.is_collect = @"1";
        [self.tableView reloadData];
    }];
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"GoodsDetail_Goods_%@", self.detailModel.goods_id] itemName:@"Goods_Collection" ContentType:@"Goods_DesCollection" itemCategory:@"Button"];
}

//添加购物车
- (void)addGoodsToCartOption {
    //执行动画  然后刷新购物车数量
    [self.viewModel requestAddToBagNetwork:@[self.goodsId, @(self->_goodsNumber)] completion:^(id obj) {
        [ZFFireBaseAnalytics addToCartWithGoodsModel:self.detailModel];
        [self.addCartView changeCartNumberInfo];
    } failure:^(id obj) {
        [self.addCartView changeCartNumberInfo];
    }];
}

- (void)goodsDetailSizeSelectOption {
    self.selectView.hidden = NO;
    [self.containView.layer addAnimation:self.backAnimation forKey:@"backAnimation"];
    [self.view bringSubviewToFront:self.addCartView];
    self->_hasChooseSize = YES;
    [self.selectView openSelectTypeView];
    
}

- (void)configGoodsDetailUserInterface {
    [self.dataArray removeAllObjects];
    ZFGoodsDetailTypeModel *goodsInfoModel = [[ZFGoodsDetailTypeModel alloc] init];
    goodsInfoModel.type = ZFGoodsDetailTypeGoodsInfo;
    [self.dataArray addObject:goodsInfoModel];
    if (![NSStringUtils isEmptyString:self.detailModel.reductionModel.msg]) {
        ZFGoodsDetailTypeModel *reductionModel = [[ZFGoodsDetailTypeModel alloc] init];
        reductionModel.type = ZFGoodsDetailTypeQualified;
        [self.dataArray addObject:reductionModel];
    }
    
    ZFGoodsDetailTypeModel *sizeSelectModel = [[ZFGoodsDetailTypeModel alloc] init];
    sizeSelectModel.type = ZFGoodsDetailTypeSizeInfo;
    [self.dataArray addObject:sizeSelectModel];
    
    if (![NSStringUtils isEmptyString:self.detailModel.shipping_tips]) {
        ZFGoodsDetailTypeModel *shippingTipsModel = [[ZFGoodsDetailTypeModel alloc] init];
        shippingTipsModel.type = ZFGoodsDetailTypeShippingTips;
        [self.dataArray addObject:shippingTipsModel];
    }
    
    if (![NSStringUtils isEmptyString:self.detailModel.desc_url]) {
        ZFGoodsDetailTypeModel *descriptionModel = [[ZFGoodsDetailTypeModel alloc] init];
        descriptionModel.type = ZFGoodsDetailTypeDescription;
        [self.dataArray addObject:descriptionModel];
    }
    
    if (![NSStringUtils isEmptyString:self.detailModel.size_url]) {
        ZFGoodsDetailTypeModel *sizeGuideModel = [[ZFGoodsDetailTypeModel alloc] init];
        sizeGuideModel.type = ZFGoodsDetailTypeSizeGuide;
        [self.dataArray addObject:sizeGuideModel];
    }
    
    if (![NSStringUtils isEmptyString:self.detailModel.model_url]) {
        ZFGoodsDetailTypeModel *modelStatsModel = [[ZFGoodsDetailTypeModel alloc] init];
        modelStatsModel.type = ZFGoodsDetailTypeModelStats;
        [self.dataArray addObject:modelStatsModel];
    }
    
    ZFGoodsDetailTypeModel *reviewModel = [[ZFGoodsDetailTypeModel alloc] init];
    reviewModel.type = ZFGoodsDetailTypeReview;
    [self.dataArray addObject:reviewModel];
    
    ZFGoodsDetailTypeModel *recommendModel = [[ZFGoodsDetailTypeModel alloc] init];
    recommendModel.type = ZFGoodsDetailTypeRecommend;
    [self.dataArray addObject:recommendModel];
    
    [self.tableView reloadData];
}

- (void)addLookHistoryInfo {
    /*添加到推荐商品*/
    CommendModel *commendModel = [CommendModel new];
    commendModel.is_cod = self.detailModel.is_cod;
    commendModel.goodsId = self.detailModel.goods_id;//商品ID
    commendModel.groupId = self.detailModel.group_goods_id;
    commendModel.goodsName = [NSStringUtils isEmptyString:self.detailModel.goods_name] ? @"" : self.detailModel.goods_name;//商品名称
    commendModel.goodsPrice = self.detailModel.shop_price;//商品价格
    commendModel.promotePrice = self.detailModel.market_price;
    commendModel.is_promote = self.detailModel.is_promote;
    commendModel.is_mobile_price = self.detailModel.is_mobile_price;
    commendModel.promote_zhekou = self.detailModel.promote_zhekou;
    commendModel.goodsAttr = [NSStringUtils isEmptyString:self.detailModel.specification] ? @"" : self.detailModel.specification;//商品属性
    commendModel.wp_image = self.detailModel.wp_image;
    
    if (self.detailModel.pictures.count > 0) {
        GoodsDetailPictureModel *pictureModel = [self.detailModel.pictures firstObject];
        commendModel.goodsThumb = pictureModel.thumb_url;//商品缩略图
    } else {
        commendModel.goodsThumb = @"";//商品缩略图
    }
    
    BOOL result = [[CartOperationManager sharedManager] saveCommend:commendModel];
    if (result) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCommendNotification object:nil];
    }
}

- (void)refreshGoodsImagesInfo {
    NSMutableArray *pictur = [NSMutableArray arrayWithCapacity:self.detailModel.pictures.count];
    for (int i = 0; i < self.detailModel.pictures.count; i++) {
        GoodsDetailPictureModel *pict = self.detailModel.pictures[i];
        [pictur addObject:pict.wp_image];
    }
    [self.imageViews removeAllObjects];
    [self.items removeAllObjects];
    [self.detailModel.pictures enumerateObjectsUsingBlock:^(GoodsDetailPictureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            YYAnimatedImageView *imageV = [[YYAnimatedImageView alloc]init];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [imageV yy_setImageWithURL:[NSURL URLWithString:obj.wp_image]
                          processorKey:NSStringFromClass([self class])
                           placeholder:[UIImage imageNamed:@"loading_product"]
                               options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                              progress:nil
                             transform:nil
                            completion:nil];
            [self.imageViews addObject:imageV];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = imageV;
            NSURL *url = [NSURL URLWithString:obj.wp_image];
            item.largeImageURL = url;
            [self.items addObject:item];
        }
    }];
    self.bannerView.imageURLStringsGroup = pictur;
}

- (void)openPhotosBrowseViewWithIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index{
    [self.items removeAllObjects];
    [self.imageViews removeAllObjects];
    [self.detailModel.reviewList[indexPath.row].imgList enumerateObjectsUsingBlock:^(GoodsDetailsReviewsImageListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            YYAnimatedImageView *imageV = [[YYAnimatedImageView alloc]init];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [imageV yy_setImageWithURL:[NSURL URLWithString:obj.originPic]
                          processorKey:NSStringFromClass([self class])
                           placeholder:[UIImage imageNamed:@"loading_product"]
                               options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation
                              progress:nil
                             transform:nil
                            completion:nil];
            [self.imageViews addObject:imageV];
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.thumbView = imageV;
            NSURL *url = [NSURL URLWithString:obj.originPic];
            item.largeImageURL = url;
            [self.items addObject:item];
        }
    }];
    
    self.browseView = [[YYPhotoBrowseView alloc]initWithGroupItems:self.items];
    [self.browseView presentFromImageView:self.imageViews[index] toContainer:self.navigationController.view animated:YES completion:nil];
}

- (void)openWebInfoWithUrl:(NSString *)url title:(NSString *)title {
    ZFWebViewViewController *webVC = [[ZFWebViewViewController alloc] init];
    webVC.link_url = url;
    webVC.title = title;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[section];
    if (typeModel.type == ZFGoodsDetailTypeReview && self->_loadMoreReviews) {
        return self.detailModel.reviewList.count + (self.detailModel.reviewList.count >= 2);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[indexPath.section];
    if (typeModel.type == ZFGoodsDetailTypeReview) {
        
        if (indexPath.row < self.detailModel.reviewList.count) {
            ZFGoodsDetailReviewInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.isTimeStamp = NO;
            cell.model = self.detailModel.reviewList[indexPath.row];
            @weakify(self);
            cell.goodsDetailReviewImageCheckCompletionHandler = ^(NSInteger index) {
                @strongify(self);
                [self openPhotosBrowseViewWithIndexPath:indexPath andIndex:index];
            };
            return cell;
        } else {
            ZFReviewViewMoreTableViewCell *viewAllCell = [tableView dequeueReusableCellWithIdentifier:kZFReviewViewMoreTableViewCellIdentifier];
            viewAllCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return viewAllCell;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[section];
    if (typeModel.type == ZFGoodsDetailTypeGoodsInfo) {
        ZFGoodsDetailInfoView *infoView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailInfoViewIdentifier];
        infoView.model = self.detailModel;
        @weakify(self);
        infoView.goodsDetailCollectionCompletionHandler = ^(BOOL collect) {
            @strongify(self);
            if (collect) {
                [self addGoodsCollectionOption];
            } else {
                [self deleteGoodsCollectionOption];
            }
        };
        return infoView;
    } else if (typeModel.type == ZFGoodsDetailTypeQualified) {
        ZFGoodsDetailQualifiedView *qualifiedView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailQualifiedViewIdentifier];
        qualifiedView.model = self.detailModel;
        @weakify(self);
        qualifiedView.goodsDetailQualifiedCompletionHandler = ^(NSString *url) {
            @strongify(self);
            [self openWebInfoWithUrl:url title:@""];
        };
        return qualifiedView;
    } else if (typeModel.type == ZFGoodsDetailTypeSizeInfo) {
        ZFGoodsDetailSizeSelectView *sizeView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailSizeSelectViewIdentifier];
        sizeView.model = self.detailModel;
        @weakify(self);
        sizeView.goodsDetailSizeSelectCompletionHandler = ^{
            @strongify(self);
            [self goodsDetailSizeSelectOption];
        };
        return sizeView;
    } else if (typeModel.type == ZFGoodsDetailTypeShippingTips) {
        ZFGoodsDetailLinkInfoView *linkView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailLinkInfoViewIdenfier];
        linkView.linkType = 0;
        linkView.linkUrl = self.detailModel.shipping_tips;
        @weakify(self);
        linkView.goodsDetailLinkJumpCompletionHandler = ^(NSString *url, NSString *title) {
            @strongify(self);
            [self openWebInfoWithUrl:url title:title];
        };
        return linkView;
    } else if (typeModel.type == ZFGoodsDetailTypeDescription) {
        ZFGoodsDetailLinkInfoView *linkView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailLinkInfoViewIdenfier];
        linkView.linkType = 1;
        linkView.linkUrl = self.detailModel.desc_url;
        @weakify(self);
        linkView.goodsDetailLinkJumpCompletionHandler = ^(NSString *url, NSString *title) {
            @strongify(self);
            [self openWebInfoWithUrl:url title:title];
        };
        return linkView;
    } else if (typeModel.type == ZFGoodsDetailTypeSizeGuide) {
        ZFGoodsDetailLinkInfoView *linkView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailLinkInfoViewIdenfier];
        linkView.linkType = 2;
        linkView.linkUrl = self.detailModel.size_url;
        @weakify(self);
        linkView.goodsDetailLinkJumpCompletionHandler = ^(NSString *url, NSString *title) {
            @strongify(self);
            [self openWebInfoWithUrl:url title:title];
        };
        return linkView;
    } else if (typeModel.type == ZFGoodsDetailTypeModelStats) {
        ZFGoodsDetailLinkInfoView *linkView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailLinkInfoViewIdenfier];
        linkView.linkType = 3;
        linkView.linkUrl = self.detailModel.model_url;
        @weakify(self);
        linkView.goodsDetailLinkJumpCompletionHandler = ^(NSString *url, NSString *title) {
            @strongify(self);
            [self openWebInfoWithUrl:url title:title];
        };
        return linkView;
    } else if (typeModel.type == ZFGoodsDetailTypeReview) {
        ZFGoodsDetailReviewsHeaderView *reviewView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailReviewsHeaderViewIdentifier];
        reviewView.model = self.detailModel;
        reviewView.isOpen = self->_loadMoreReviews;
        @weakify(self);
        reviewView.goodsDetailReviewsViewMoreCompletionHandler = ^{
            @strongify(self);
            self->_loadMoreReviews = !self->_loadMoreReviews;
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:self.dataArray.count - 2];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return reviewView;
    } else if (typeModel.type == ZFGoodsDetailTypeRecommend) {
        ZFGoodsDetailRecommendView *recommendView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailRecommendViewIdentifier];
        recommendView.dataArray = self.detailModel.same_cat_goods;
        @weakify(self);
        recommendView.goodsDetailRecommendSelectCompletionHandler = ^(NSString *goodsId) {
            @strongify(self);
            self.goodsId = goodsId;
            [tableView setContentOffset:CGPointMake(0, -SCREEN_WIDTH * 1.33) animated:NO];
            [self requestGoodsDetailInfo];
            [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_GoodsDetail_Recommend_Goods_%@", goodsId] itemName:@"GoodsDetail_Recommend" ContentType:@"Goods" itemCategory:@"Goods"];
        };
        return recommendView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[section];
    if (self.dataArray[section + 1].type == ZFGoodsDetailTypeReview) {
        ZFGoodsDetailSepareEmptyView *separeEmptyView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailSepareEmptyViewIdentifier];
        return separeEmptyView;
    }
    if (typeModel.type == ZFGoodsDetailTypeReview  || typeModel.type == ZFGoodsDetailTypeRecommend) {
        ZFGoodsDetailSepareEmptyView *separeEmptyView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFGoodsDetailSepareEmptyViewIdentifier];
        return separeEmptyView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[ZFReviewViewMoreTableViewCell class]]) {
        ZFGoodsDetailReviewViewController *reviewVC = [[ZFGoodsDetailReviewViewController alloc] init];
        reviewVC.goodsId = self.detailModel.goods_id;
        reviewVC.goodsSn = self.detailModel.goods_sn;
        [self.navigationController pushViewController:reviewVC animated:YES];
        [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"More_Review_%@", self.detailModel.goods_id] itemName:@"Review" ContentType:@"Goods - Detail" itemCategory:@"Review"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[indexPath.section];
    if (typeModel.type == ZFGoodsDetailTypeReview) {
        if (indexPath.row < self.detailModel.reviewList.count) {
            return [tableView fd_heightForCellWithIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier configuration:^(ZFGoodsDetailReviewInfoTableViewCell *cell) {
                cell.model = self.detailModel.reviewList[indexPath.row];
            }];
        } else {
            return 48;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[section];
    if (typeModel.type == ZFGoodsDetailTypeGoodsInfo) {
        return 120;
    } else if (typeModel.type == ZFGoodsDetailTypeQualified) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeSizeInfo) {
        return 56;
    } else if (typeModel.type == ZFGoodsDetailTypeShippingTips) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeDescription) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeSizeGuide) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeModelStats) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeReview) {
        return 48;
    } else if (typeModel.type == ZFGoodsDetailTypeRecommend) {
        return 320;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ZFGoodsDetailTypeModel *typeModel = self.dataArray[section];
    if (self.dataArray[section + 1].type == ZFGoodsDetailTypeReview) {
        return 8;
    }
    if (typeModel.type == ZFGoodsDetailTypeReview || typeModel.type == ZFGoodsDetailTypeRecommend) {
        return 8;
    }
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.tableView sendSubviewToBack:self.bannerView];
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat scorllOffsetY = scrollView.contentOffset.y;
    CGFloat changeOffset = (-SCREEN_WIDTH * 1.33 - scorllOffsetY) / 3.0;
    
//    if (scorllOffsetY < -SCREEN_WIDTH * 1.33) {
//        [scrollView setContentOffset:CGPointMake(0, -SCREEN_WIDTH * 1.33)];
//    }
//
    if (scorllOffsetY < 0 && scorllOffsetY >= -SCREEN_WIDTH * 1.33 && self->_hasLayout) {
        //更改Navigation alpha
        CGFloat alphaChange = fabs(-SCREEN_WIDTH * 1.33 - scorllOffsetY) / (SCREEN_WIDTH * 1.33);
        self.navigationView.alpha = alphaChange;
        //Banner轮播视图隐藏视觉差效果
        
        [self.bannerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tableView.mas_top).offset(-SCREEN_WIDTH * 1.33 - changeOffset);
        }];
        
    }
}

#pragma mark - ZFShareViewDelegate
- (void)zfShsreView:(ZFShareView *)shareView didSelectItemAtIndex:(NSUInteger)index {
    NativeShareModel *model = [[NativeShareModel alloc] init];
    model.share_url = [NSString stringWithFormat:@"%@?actiontype=3&url=%@&name=%@&source=sharelink&lang=%@",CommunityShareURL,self.goodsId,self.detailModel.goods_name, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    model.fromviewController = self;
    [ZFShareManager shareManager].model = model;
    switch (index) {
        case ZFShareTypeFacebook: {
            [[ZFShareManager shareManager] shareToFacebook];
        }
            break;
        case ZFShareTypeMessenger: {
            [[ZFShareManager shareManager] shareToMessenger];
        }
            break;
        case ZFShareTypeCopy: {
            [[ZFShareManager shareManager] copyLinkURL];
        }
            break;
    }
}

#pragma mark - <ZFBannerScrollViewDelegate>
- (void)ZFBannerScrollView:(ZFBannerScrollView *)view didSelectItemAtIndex:(NSInteger)index {
    [self refreshGoodsImagesInfo];
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:self.items];
    [groupView presentFromImageView:self.imageViews[index] toContainer:self.navigationController.view animated:YES completion:nil];
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Detail" actionName:@"Product Detail - Big Pic" label:@"Product Detail - Big Pic"];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containView];
    [self.containView addSubview:self.tableView];
    [self.tableView addSubview:self.bannerView];
    [self.containView addSubview:self.navigationView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.addCartView];
    [self.view addSubview:self.selectView];
}

- (void)zfAutoLayoutView {
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.tableView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH * 1.33);
        make.top.mas_equalTo(self.tableView.mas_top).offset(-SCREEN_WIDTH * 1.33);
    }];
    
    [self.addCartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.containView);
        make.height.mas_equalTo(64);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 44));
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.leading.mas_equalTo(self.view);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 44));
        make.top.mas_equalTo(self.view.mas_top).offset(20);
        make.trailing.mas_equalTo(self.view);
    }];
    
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - getter
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectZero];
        _containView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containView;
}

- (NSMutableArray<ZFGoodsDetailTypeModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<YYPhotoGroupItem *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (ZFGoodsDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFGoodsDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFGoodsDetailNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[ZFGoodsDetailNavigationView alloc] initWithFrame:CGRectZero];
    }
    return _navigationView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.backgroundColor = [UIColor clearColor];
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (ZFGoodsDetailAddCartView *)addCartView {
    if (!_addCartView) {
        _addCartView = [[ZFGoodsDetailAddCartView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _addCartView.addCartButtonCompletionHandler = ^{
            @strongify(self);
            if (!self->_hasChooseSize) {
                [self goodsDetailSizeSelectOption];
            } else {
                [self.selectView hideSelectTypeView];
                [self addGoodsToCartOption];
            }
        };
        _addCartView.cartButtonCompletionHandler = ^{
            @strongify(self);
            [self jumpToCartViewController];
        };
    }
    return _addCartView;
}

- (ZFGoodsDetailSelectTypeView *)selectView {
    if (!_selectView) {
        _selectView = [[ZFGoodsDetailSelectTypeView alloc] initWithFrame:CGRectZero];
        _selectView.hidden = YES;
        _selectView.chooseNumebr = self->_goodsNumber;
        @weakify(self);
        _selectView.goodsDetailSelectTypeCloseCompletionHandler = ^{
            @strongify(self);
            self.selectView.hidden = YES;
            self->_hasChooseSize = NO;
        };
        
        _selectView.goodsDetailSelectHideAnimationCompletionHandler = ^{
            @strongify(self);
            [self.containView.layer addAnimation:self.frontAnimation forKey:@"frontAnimation"];
            [ZFFireBaseAnalytics selectContentWithItemId:@"Close_Attributes" itemName:@"Attributes" ContentType:@"Goods - Detail" itemCategory:@"Attributes"];
        };
        
        _selectView.goodsDetailSelectTypeCompletionHandler = ^(NSString *goodsId) {
            @strongify(self);
            self.goodsId = goodsId;
            self->_goodsNumber = 1;
            [self requestGoodsDetailInfo];
        };
        
        _selectView.goodsDetailSelectSizeGuideCompletionHandler = ^{
            @strongify(self);
            [self openWebInfoWithUrl:self.detailModel.size_url title:ZFLocalizedString(@"Detail_Product_SizeGuides",nil)];
        };
        
        _selectView.goodsDetailSelectNumberChangeCompletionHandler = ^(NSInteger number) {
            @strongify(self);
            self->_goodsNumber = number;
            [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Change_GoodsNumber_%@_%ld", self.detailModel.goods_id, number] itemName:@"" ContentType:@"Goods - Detail" itemCategory:@""];
        };
    }
    return _selectView;
}

- (ZFBannerScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[ZFBannerScrollView alloc] initWithFrame:CGRectZero];
        _bannerView.delegate = self;
        _bannerView.bannerType = ZFBannerTypeParallax;
        _bannerView.autoScroll = NO;
//        _bannerView.currentPageDotImage = [UIImage imageNamed:@"scroll_select"];
//        _bannerView.pageDotImage = [UIImage imageNamed:@"scroll_normal"];
    }
    return _bannerView;
}

- (ZFShareView *)shareView {
    if (!_shareView) {
        _shareView = [[ZFShareView alloc] initWithFrame:CGRectZero];
        _shareView.delegate = self;
    }
    return _shareView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.alwaysBounceVertical = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH * 1.33 - 20, 0, 0, 0);
        [_tableView registerClass:[ZFGoodsDetailInfoView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailInfoViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailQualifiedView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailQualifiedViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailSizeSelectView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailSizeSelectViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailLinkInfoView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailLinkInfoViewIdenfier];
        [_tableView registerClass:[ZFGoodsDetailReviewsHeaderView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailReviewsHeaderViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailReviewInfoTableViewCell class] forCellReuseIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier];
        [_tableView registerClass:[ZFReviewViewMoreTableViewCell class] forCellReuseIdentifier:kZFReviewViewMoreTableViewCellIdentifier];
        [_tableView registerClass:[ZFGoodsDetailRecommendView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailRecommendViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailSepareEmptyView class] forHeaderFooterViewReuseIdentifier:kZFGoodsDetailSepareEmptyViewIdentifier];
    }
    return _tableView;
}

- (UIImageView *)animationView {
    if (!_animationView) {
        _animationView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _animationView.hidden = YES;
    }
    return _animationView;
}

- (UIBezierPath *)bezierPath {
    if (!_bezierPath) {
        _bezierPath = [[UIBezierPath alloc] init];
    }
    return _bezierPath;
}

- (CABasicAnimation *)backAnimation {
    if (!_backAnimation) {
        _backAnimation = [CABasicAnimation animation];
        _backAnimation.keyPath = @"transform.scale";
        _backAnimation.fromValue = @(1.0);
        _backAnimation.toValue = @(0.9);
        _backAnimation.duration = 0.35f;
        _backAnimation.fillMode = kCAFillModeForwards;
        _backAnimation.removedOnCompletion = NO;
    }
    return _backAnimation;
}

- (CABasicAnimation *)frontAnimation {
    if (!_frontAnimation) {
        _frontAnimation = [CABasicAnimation animation];
        _frontAnimation.keyPath = @"transform.scale";
        _frontAnimation.fromValue = @(0.9);
        _frontAnimation.toValue = @(1.0);
        _frontAnimation.duration = 0.35f;
        _frontAnimation.fillMode = kCAFillModeForwards;
        _frontAnimation.removedOnCompletion = NO;
    }
    return _frontAnimation;
}
@end
