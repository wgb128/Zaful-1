
//
//  ZFGoodsDetailReviewViewController.m
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailReviewViewController.h"
#import "ZFInitViewProtocol.h"
#import "YYPhotoBrowseView.h"
#import "ZFGoodsDetailReviewInfoTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFGoodsDetailReviewsViewModel.h"
#import "ZFReviewDetailHeaderView.h"
#import "GoodsDetailsReviewsModel.h"
#import "GoodsDetailFirstReviewModel.h"
#import "GoodsDetailsReviewsImageListModel.h"

static NSString *const kZFReviewDetailHeaderViewIdentifier = @"kZFReviewDetailHeaderViewIdentifier";
static NSString *const kZFGoodsDetailReviewInfoTableViewCellIdentifier = @"kZFGoodsDetailReviewInfoTableViewCellIdentifier";

@interface ZFGoodsDetailReviewViewController () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate> {
    NSInteger       _currentPage;
}
@property (nonatomic, strong) UITableView                                       *tableView;
@property (nonatomic, strong) ZFGoodsDetailReviewsViewModel                     *viewModel;
@property (nonatomic, strong) GoodsDetailsReviewsModel                          *reviewsModel;
@property (nonatomic, strong) YYPhotoBrowseView                                 *browseView;
@property (nonatomic, strong) NSMutableArray<GoodsDetailFirstReviewModel *>     *dataArray;
@property (nonatomic, strong) NSMutableArray                                    *imageViews;
@property (nonatomic, strong) NSMutableArray<YYPhotoGroupItem *>                *items;
@end

@implementation ZFGoodsDetailReviewViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - private methods
- (void)openPhotosBrowseViewWithIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index{
    [self.items removeAllObjects];
    [self.imageViews removeAllObjects];
    [self.dataArray[indexPath.row].imgList enumerateObjectsUsingBlock:^(GoodsDetailsReviewsImageListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFGoodsDetailReviewInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier];
    cell.isTimeStamp = YES;
    cell.model = self.dataArray[indexPath.row];
    
    @weakify(self);
    cell.goodsDetailReviewImageCheckCompletionHandler = ^(NSInteger index) {
        @strongify(self);
        [self openPhotosBrowseViewWithIndexPath:indexPath andIndex:index];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier configuration:^(ZFGoodsDetailReviewInfoTableViewCell *cell) {
        cell.model = self.dataArray[indexPath.row];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.dataArray.count <= 0 ? CGFLOAT_MIN : 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count <= 0) {
        return nil;
    }
    ZFReviewDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFReviewDetailHeaderViewIdentifier];
    headerView.points = [NSString stringWithFormat:@"%.lf", self.reviewsModel.agvRate];
    headerView.reviewsCount = self.reviewsModel.reviewCount;
    return headerView;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"GoodsReviews_VC_Title", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (NSMutableArray<YYPhotoGroupItem *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray<GoodsDetailFirstReviewModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ZFGoodsDetailReviewsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFGoodsDetailReviewsViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ZFCOLOR_WHITE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[ZFReviewDetailHeaderView class] forHeaderFooterViewReuseIdentifier:kZFReviewDetailHeaderViewIdentifier];
        [_tableView registerClass:[ZFGoodsDetailReviewInfoTableViewCell class] forCellReuseIdentifier:kZFGoodsDetailReviewInfoTableViewCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[self.goodsId, self.goodsSn, Refresh] completion:^(id obj) {
                self.reviewsModel = obj;
                self->_currentPage = 1;
                self.dataArray = [NSMutableArray arrayWithArray:self.reviewsModel.reviewList];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (self->_currentPage >= self.reviewsModel.pageCount) {
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    self.tableView.mj_footer.hidden = NO;
                }
            } failure:^(id obj) {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:@[self.goodsId, self.goodsSn, LoadMore] completion:^(id obj) {
                self.reviewsModel = obj;
                self->_currentPage = self.reviewsModel.page;
                [self.dataArray addObjectsFromArray:self.reviewsModel.reviewList];
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
                if (self->_currentPage >= self.reviewsModel.pageCount) {
                    self.tableView.mj_footer.hidden = YES;
                }
            } failure:^(id obj) {
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
    }
    return _tableView;
}

@end
