//
//  ZFCartViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//
#import "ZFCartViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCartPriceOptionView.h"
#import "ZFCartViewModel.h"
#import "ZFCartListResultModel.h"
#import "ZFCartGoodsListModel.h"
#import "ZFCartDiscountGoodsHeaderView.h"
#import "ZFCartDiscountGoodsTableViewCell.h"
#import "ZFCartUnavailableGoodsHeaderView.h"
#import "ZFCartUnavailableGoodsTableViewCell.h"
#import "ZFCartRecentHistoryView.h"
#import "ZFCartDiscountTipsView.h"
#import "ZFCartUnavailableViewAllView.h"
#import "ZFCartGoodsModel.h"
#import "ZFGoodsDetailViewController.h"
#import "ZFWebViewViewController.h"
#import "ZFCartDeleteGoodsTipsView.h"
#import "ZFCartUnavailableClearAllTipsView.h"
#import "ZFLoginViewController.h"
#import "ZFOrderCheckInfoModel.h"
#import "ZFOrderCheckInfoDetailModel.h"
#import "CheckOutGoodListModel.h"
#import "ZFAddressEditViewController.h"
#import "ZFOrderInfoViewController.h"
#import "ZFPayMethodsViewController.h"
#import "ZFOrderContentViewController.h"
#import "FastPamentView.h"
#import "ZFCartNoDataEmptyView.h"
#import "ZFNoNetEmptyView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FilterManager.h"
#import "GoodsDetailModel.h"

static NSString *const kZFCartRecentHistoryViewIdentifier = @"kZFCartRecentHistoryViewIdentifier";
static NSString *const kZFCartDiscountGoodsHeaderViewIdentifier = @"kZFCartDiscountGoodsHeaderViewIdentifier";
static NSString *const kZFCartDiscountGoodsTableViewCellIdentifier = @"kZFCartDiscountGoodsTableViewCellIdentifier";
static NSString *const kZFCartUnavailableGoodsHeaderViewIdentifier = @"kZFCartUnavailableGoodsHeaderViewIdentifier";
static NSString *const kZFCartUnavailableGoodsTableViewCellIdentifier = @"kZFCartUnavailableGoodsTableViewCellIdentifier";
static NSString *const kZFCartUnavailableViewAllViewIdentifier = @"kZFCartUnavailableViewAllViewIdentifier";

@interface ZFCartViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource> {
    BOOL            _isUnavailableViewAll;
}
@property (nonatomic, strong) UITableView                           *tableView;
@property (nonatomic, strong) ZFCartPriceOptionView                 *priceOptionView;
@property (nonatomic, strong) UIButton                              *checkOutButton;
@property (nonatomic, strong) UIButton                              *fastPayButton;
@property (nonatomic, strong) ZFCartViewModel                       *viewModel;
@property (nonatomic, strong) ZFCartListResultModel                 *cartListResultModel;
@property (nonatomic, strong) ZFCartDeleteGoodsTipsView             *deleteTipsView;
@property (nonatomic, strong) ZFCartUnavailableClearAllTipsView     *clearAllTipsView;
@property (nonatomic, strong) NSMutableArray                        *selectGoodsArray;
@property (nonatomic, strong) ZFCartNoDataEmptyView                 *noGoodsEmptyView;
@property (nonatomic, strong) ZFCartDiscountTipsView                *discountTipsView;
@property (nonatomic, strong) ZFNoNetEmptyView                      *noNetworkView;
@end

@implementation ZFCartViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigNavigationView];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self requestCartListDataInfoOption];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCartListDataInfoOption) name:kLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCartListDataInfoOption) name:kCartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCartListDataInfoOption) name:kLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recentHistoryInfoChangeRefresh) name:kCommendNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeCollectionInfoRefresh) name:kCollectionGoodsNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - private methods
- (void)cofigNavigationView {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0],NSForegroundColorAttributeName:ZFCOLOR(51, 51, 51, 1.0)}];
    self.title = [NSString stringWithFormat:@"%@(0)",ZFLocalizedString(@"ZFCheckout_mybag",nil)];
}

- (void)dealAllSelectGoodsIntoArray {
    [self.selectGoodsArray removeAllObjects];
    [self.cartListResultModel.goodsBlockList enumerateObjectsUsingBlock:^(ZFCartGoodsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
            *stop = YES;
            return ;
        }
        [obj.cartList enumerateObjectsUsingBlock:^(ZFCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_selected) {
                [self.selectGoodsArray addObject:obj];
            }
        }];
    }];
    self.fastPayButton.enabled = (self.selectGoodsArray && self.selectGoodsArray.count > 0);
}

- (void)requestCartListDataInfoOption {
    if ([NoNetworkReachabilityManager shareManager].networkStatus == AFNetworkReachabilityStatusNotReachable
        && (!self.cartListResultModel.goodsBlockList || self.cartListResultModel.goodsBlockList.count == 0)) {
        [self.view addSubview:self.noNetworkView];
        [self.noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        return ;
    } else {
        [self.noNetworkView removeFromSuperview];
        self.noNetworkView = nil;
    }
    
    @weakify(self);
    [self.viewModel requestCartListNetwork:@"" completion:^(id obj) {
        @strongify(self);
        self.cartListResultModel = obj;
        self.priceOptionView.model = self.cartListResultModel;
        [[NSUserDefaults standardUserDefaults] setValue:@(self.cartListResultModel.totalNumber) forKey:kCollectionBadgeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.title = [NSString stringWithFormat:@"%@(%lu)",ZFLocalizedString(@"Bag_VC_Title",nil), self.cartListResultModel.totalNumber];
        if (self.cartListResultModel.goodsBlockList.count == 0) {
            [self noGoodsInCartRefresh];
        } else {
            self.tableView.tableHeaderView = nil;
        }
        [self dealAllSelectGoodsIntoArray];
        [self.tableView reloadData];
    } failure:^(id obj) {
        if (self.cartListResultModel.goodsBlockList.count == 0) {
            [self noGoodsInCartRefresh];
        } else {
            self.tableView.tableHeaderView = nil;
        }
        [self dealAllSelectGoodsIntoArray];
        [self.tableView reloadData];
    }];
}

- (void)noGoodsInCartRefresh {
    self.tableView.mj_header.hidden = YES;
    self.tableView.tableHeaderView = self.noGoodsEmptyView;
}

- (void)selectAllGoodsWithSelect:(BOOL)isSelect {
    @weakify(self);
    NSMutableArray<NSDictionary<NSString *, NSString *> *>  *selectArray = [NSMutableArray array];
    [self.cartListResultModel.goodsBlockList enumerateObjectsUsingBlock:^(ZFCartGoodsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
            *stop = YES;
            return ;
        }
        [obj.cartList enumerateObjectsUsingBlock:^(ZFCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = @{@"goods_id" : obj.goods_id, @"select" : @(isSelect)};
            [selectArray addObject:dic];
        }];
    }];
    
    [self.viewModel requestCartSelectAllGoodsNetwork:selectArray completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            [self requestCartListDataInfoOption];
        }
    }];
    
    // firebase 统计
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag_All_Goods" itemName:@"GoodsSelect" ContentType:@"Goods_Select" itemCategory:@"Button"];
}

- (void)cartSelectGoodsOptionWithModel:(ZFCartGoodsModel *)model {
    @weakify(self);
    [self.viewModel requestCartSelectGoodsNetwork:model completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            [self requestCartListDataInfoOption];
        }
    }];
}

- (void)cartGoodsAddCollectionWithGoodsId:(NSString *)goodsId andIndexPath:(NSIndexPath *)indexPath{
    //添加收藏
    @weakify(self);
    [self.viewModel requestAddGoodCollectionNetwork:goodsId completion:^(BOOL isOK) {
        @strongify(self);
        if (!isOK) {
            self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = NO;
            [self.tableView reloadData];
        } else {
            self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = YES;
            [self.tableView reloadData];
        }
    } failure:^{
        @strongify(self);
        self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = NO;
        [self.tableView reloadData];
    }];
}

- (void)cartGoodsCancelCollectionWithGoodsId:(NSString *)goodsId andIndexPath:(NSIndexPath *)indexPath{
    //取消收藏
    @weakify(self);
    [self.viewModel requestCancelGoodCollectionNetwork:goodsId completion:^(BOOL isOK) {
        @strongify(self);
        if (!isOK) {
            self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = YES;
            [self.tableView reloadData];
        } else {
            self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = NO;
            [self.tableView reloadData];
        }
    } failure:^{
        @strongify(self);
        self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row].if_collect = YES;
        [self.tableView reloadData];
    }];
}

- (void)cartGoodsNumberEditWithGoodsId:(NSString *)goodsId andGoodsNumber:(NSInteger)goodsNumber {
    //修改数量。成功之后重新请求一次购物车列表
    @weakify(self);
    [self.viewModel requestUpdateCartNumNetworkWithNum:goodsNumber goodId:goodsId completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            [self requestCartListDataInfoOption];
        }
    }];
    
    // firebase 统计
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Bag_Goods_%@_%ld", goodsId, goodsNumber] itemName:@"GoodsNumber" ContentType:@"Goods_Number" itemCategory:@"Button"];
}

- (void)cartGoodsDeleteOptionWithGoodsId:(NSString *)goodsId {
    @weakify(self);
    [self.viewModel requestCartDelNetwork:goodsId completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            [self requestCartListDataInfoOption];
        }
    }];
    
    // firebase 统计
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Delete_Bag_Goods_%@", goodsId] itemName:@"GoodsDelete" ContentType:@"Goods_Delete" itemCategory:@"Button"];
}

- (void)cartClearAllUnavailableGoodsOption {
    NSMutableArray *unavailableGoods = [NSMutableArray array];
    [self.cartListResultModel.goodsBlockList enumerateObjectsUsingBlock:^(ZFCartGoodsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
            [obj.cartList enumerateObjectsUsingBlock:^(ZFCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [unavailableGoods addObject:obj.goods_id];
            }];
        }
    }];
    @weakify(self);
    [self.viewModel requestCartUnavailableClearAllNetwork:unavailableGoods completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            [self requestCartListDataInfoOption];
        }
    }];
}

- (void)cartSelectDiscountTopicJumpWithUrl:(NSString *)url{
    ZFWebViewViewController *webView = [[ZFWebViewViewController alloc] init];
    webView.link_url = url;
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)cartGoodsIdDetailJumpWithGoodsId:(NSString *)goodsId {
    [self.view endEditing:YES];
    ZFGoodsDetailViewController *detailVC = [[ZFGoodsDetailViewController alloc] init];
    detailVC.goodsId = goodsId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)recentHistoryInfoChangeRefresh {
    [self.tableView reloadData];
}

- (void)changeCollectionInfoRefresh {
    [self.tableView.mj_header beginRefreshing];
}

- (void)oldPaymentProcess {
    @weakify(self);
    NSDictionary *dict = @{
                           @"payCode" : @(PayCodeTypeOld),
                           @"order_info" : @""
                           };
    [self.viewModel requestCartCheckOutNetwork:dict completion:^(id obj) {
        NSArray *modelArray = obj;
        ZFOrderCheckInfoModel *checkInfoModel = modelArray.firstObject;
        ZFOrderCheckInfoDetailModel *model = checkInfoModel.order_info;
        if ([NSStringUtils isEmptyString:model.address_info.address_id]) {
            ZFAddressEditViewController *addressVC = [[ZFAddressEditViewController alloc] init];
            addressVC.addressEditSuccessCompletionHandler = ^{
                @strongify(self);
                [self checkOutButtonAction:nil];
            };
            [self.navigationController pushViewController:addressVC animated:YES];
        } else {
            [FilterManager saveIsComb:NO];
            ZFOrderContentViewController *contentVC = [[ZFOrderContentViewController alloc] init];
            contentVC.paymentUIType = PaymentUITypeSingle;
            contentVC.paymentProcessType = PaymentProcessTypeOld;
            contentVC.payCode = PayCodeTypeOld; // 代表老流程
            contentVC.checkoutModel = model;
            [self.navigationController pushViewController:contentVC animated:YES];
            
            
            //统计
            NSMutableString *goodsStr = [NSMutableString string];
            for (CheckOutGoodListModel *goodsModel in model.cart_goods.goods_list) {
                [goodsStr appendString:goodsModel.goods_sn];
            }
            [ZFAnalytics appsFlyerTrackEvent:@"af_process_to_pay" withValues:@{
                                                                               @"af_contentid" : goodsStr
                                                                               }];
            [ZFFireBaseAnalytics beginCheckOutWithGoodsInfo:model];
        }
    } failure:^(id obj) {
    }];
}

- (void)newPaymentProcess {
    ZFPayMethodsViewController *payMethodVC = [[ZFPayMethodsViewController alloc] init];
    [self.navigationController pushViewController:payMethodVC animated:YES];
}

- (void)fireBaseGoodsCollectionWithModel:(ZFCartGoodsModel *)model {
    
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Bag_Goods_%@", model.goods_id] itemName:model.goods_name ContentType:@"Goods_Collection" itemCategory:@"Button"];
    GoodsDetailModel *goodsDetailModel = [[GoodsDetailModel alloc] init];
    goodsDetailModel.goods_id = model.goods_id;
    goodsDetailModel.goods_name = model.goods_title;
    goodsDetailModel.long_cat_name = model.cat_name;
    goodsDetailModel.goods_sn = model.goods_sn;
    [ZFFireBaseAnalytics addCollectionWithGoodsModel:goodsDetailModel];
}

#pragma mark - action methods
- (void)checkOutButtonAction:(UIButton *)sender {
    if (![AccountManager sharedManager].isSignIn) {
        //提示用户登陆，登陆成功刷新购物车
        ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
        @weakify(self);
        loginVC.successBlock = ^{
            @strongify(self);
            [self requestCartListDataInfoOption];
        };
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return ;
    }
    //处理选中商品
    if (self.selectGoodsArray.count == 0) {
        //请选择商品
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:ZFLocalizedString(@"CartViewModel_Alert_Message",nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              
                                                          }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        @weakify(self);
        [self.viewModel requestPaymentProcessCompletion:^(NSInteger state) {
            @strongify(self);
            switch (state) {
                case PaymentProcessTypeOld:
                {
                    [self oldPaymentProcess];
                }
                    break;
                case PaymentProcessTypeNew:
                {
                    [self newPaymentProcess];
                }
                    break;
            }
        } failure:^(id obj) {}];
    }
    
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag_CheckOut" itemName:@"Check Out" ContentType:@"Payment" itemCategory:@"Button"];
}

- (void)fastPaymentButtonAction:(UIButton *)sender {
    @weakify(self);
    //2.使用令牌拼接路径，拿到token和payid
    FastPamentView *fastPamentView = [[FastPamentView alloc] init];
    fastPamentView.url = [NSString stringWithFormat:@"%@bizhong=%@&user_id=%@&token=%@&lang=%@&sess_id=%@",AuthQuickPayURL,[ExchangeManager localCurrencyName],USERID,TOKEN, [ZFLocalizationString shareLocalizable].nomarLocalizable, [AccountManager sharedManager].isSignIn ? @"" : SESSIONID];
    fastPamentView.paymentCallBackBlock = ^(NSString *token, NSString *payid) {
        //这里请求类似checkout接口
        @strongify(self);
        [self.viewModel requestCartFastPayNetworkWithPayertoken:token payerId:payid completion:^(BOOL hasAddress, id obj) {
            if (!hasAddress) {
                ZFAddressEditViewController *addressVC = [[ZFAddressEditViewController alloc] init];
                addressVC.model = obj;
                addressVC.addressEditSuccessCompletionHandler = ^{
                    @strongify(self);
                    [self fastPaymentButtonAction:nil];
                };
                [self.navigationController pushViewController:addressVC animated:YES];
            } else {
                @strongify(self);
                ZFOrderInfoViewController *orderInfo = [[ZFOrderInfoViewController alloc] init];
                orderInfo.checkOutModel = obj;
                orderInfo.paymentUIType = PaymentUITypeSingle;
                orderInfo.payCode = PayCodeTypeOld;
                [self.navigationController pushViewController:orderInfo animated:YES];
            }
        } failure:^(id obj) {}];
        
    };
    [fastPamentView show];
    // 谷歌统计
    [ZFAnalytics clickButtonWithCategory:@"Bag" actionName:@"Bag - FastPayment" label:@"Bag - FastPayment"];
    [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bag_PayPal" itemName:@"PayPal" ContentType:@"Payment" itemCategory:@"Button"];
    [ZFFireBaseAnalytics beginCheckOutWithGoodsInfo:nil];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cartListResultModel.goodsBlockList.count + ([[CartOperationManager sharedManager] recentList].count > 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((!self.cartListResultModel.goodsBlockList || !self.cartListResultModel.goodsBlockList.count) && ([[CartOperationManager sharedManager] recentList].count > 0)) {
        return 1;
    }
    if (section < self.cartListResultModel.goodsBlockList.count && [self.cartListResultModel.goodsBlockList[section].goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
        if (self.cartListResultModel.goodsBlockList[section].cartList.count > 2) {
            return _isUnavailableViewAll ? self.cartListResultModel.goodsBlockList[section].cartList.count : 2;
        }
    }
    return (section > self.cartListResultModel.goodsBlockList.count - 1) ? 1 : self.cartListResultModel.goodsBlockList[section].cartList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //判断是否存在history浏览历史
    if (!self.cartListResultModel.goodsBlockList || indexPath.section > self.cartListResultModel.goodsBlockList.count - 1) {
        ZFCartRecentHistoryView *history = [tableView dequeueReusableCellWithIdentifier:kZFCartRecentHistoryViewIdentifier];
        history.selectionStyle = UITableViewCellSelectionStyleNone;
        [history changeCommendGoodsListInfo];
        @weakify(self);
        history.cartRecentHistoryGoodsDetailCompletionHandler = ^(NSString *goodsId) {
            @strongify(self);
            [self cartGoodsIdDetailJumpWithGoodsId:goodsId];
        };
        return history;
    }
    
    if ((!self.cartListResultModel.goodsBlockList || !self.cartListResultModel.goodsBlockList.count) && ([[CartOperationManager sharedManager] recentList].count > 0)) {
        ZFCartRecentHistoryView *history = [tableView dequeueReusableCellWithIdentifier:kZFCartRecentHistoryViewIdentifier];
        history.selectionStyle = UITableViewCellSelectionStyleNone;
        [history changeCommendGoodsListInfo];
        @weakify(self);
        history.cartRecentHistoryGoodsDetailCompletionHandler = ^(NSString *goodsId) {
            @strongify(self);
            [self cartGoodsIdDetailJumpWithGoodsId:goodsId];
        };
        return history;
    }
    ZFCartGoodsListModel *blockModel = self.cartListResultModel.goodsBlockList[indexPath.section];
    /*
     * 如果是普通商品分栏，ZFCartDiscountGoodsTableViewCell
     * 如果是活动满减分栏，ZFCartDiscountGoodsTableViewCell
     * 如果是过期商品分栏，ZFCartUnavailableGoodsTableViewCell;
     */
    switch ([blockModel.goodsModuleType integerValue]) {
        case ZFCartListBlocksTypeNormal: {
            ZFCartDiscountGoodsTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:kZFCartDiscountGoodsTableViewCellIdentifier];
            normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
            normalCell.model = blockModel.cartList[indexPath.row];
            @weakify(self);
            normalCell.cartDiscountGoodsSelectCompletionHandler = ^(BOOL isSelect) {
                @strongify(self);
                ZFCartGoodsModel *model = blockModel.cartList[indexPath.row];
                model.isSelected = isSelect;
                [self cartSelectGoodsOptionWithModel:model];
                
                // firebase 统计
                [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Bag_Goods_%@", model.goods_id] itemName:[NSString stringWithFormat:@"Selecte_%@", model.goods_title] ContentType:@"Goods_Select" itemCategory:@"Button"];
            };
            
            normalCell.cartDiscountGoodsCollectionCompletionHandler = ^(BOOL isCollection) {
                @strongify(self);
                if (isCollection) {
                    ZFCartGoodsModel *model = blockModel.cartList[indexPath.row];
                    [self cartGoodsAddCollectionWithGoodsId:blockModel.cartList[indexPath.row].goods_id andIndexPath:indexPath];
                    
                    // firebase 统计
                    [self fireBaseGoodsCollectionWithModel:model];
                } else {
                    [self cartGoodsCancelCollectionWithGoodsId:blockModel.cartList[indexPath.row].goods_id andIndexPath:indexPath];
                }
            };
            
            normalCell.cartDiscountGoodsChangeCountCompletionHandler = ^(ZFCartGoodsModel *model) {
                @strongify(self);
                [self cartGoodsNumberEditWithGoodsId:model.goods_id andGoodsNumber:model.buy_number];
            };
            return normalCell;
        }
            break;
            
        case ZFCartListBlocksTypeDiscount: {
            ZFCartDiscountGoodsTableViewCell *discountCell = [tableView dequeueReusableCellWithIdentifier:kZFCartDiscountGoodsTableViewCellIdentifier];
            discountCell.selectionStyle = UITableViewCellSelectionStyleNone;
            discountCell.model = blockModel.cartList[indexPath.row];
            @weakify(self);
            discountCell.cartDiscountGoodsSelectCompletionHandler = ^(BOOL isSelect) {
                @strongify(self);
                ZFCartGoodsModel *model = blockModel.cartList[indexPath.row];
                model.isSelected = isSelect;
                [self cartSelectGoodsOptionWithModel:model];
                
                // firebase 统计
                [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Bag_Goods_%@", model.goods_id] itemName:[NSString stringWithFormat:@"Selecte_%@", model.goods_title] ContentType:@"Goods_Select" itemCategory:@"Button"];
            };
            
            discountCell.cartDiscountGoodsCollectionCompletionHandler = ^(BOOL isCollection) {
                @strongify(self);
                if (isCollection) {
                    ZFCartGoodsModel *model = blockModel.cartList[indexPath.row];
                    [self cartGoodsAddCollectionWithGoodsId:blockModel.cartList[indexPath.row].goods_id andIndexPath:indexPath];
                    
                    // firebase 统计
                    [self fireBaseGoodsCollectionWithModel:model];
                } else {
                    [self cartGoodsCancelCollectionWithGoodsId:blockModel.cartList[indexPath.row].goods_id andIndexPath:indexPath];
                }
            };
            
            discountCell.cartDiscountGoodsChangeCountCompletionHandler = ^(ZFCartGoodsModel *model) {
                @strongify(self);
                [self cartGoodsNumberEditWithGoodsId:model.goods_id andGoodsNumber:model.buy_number];
            };
            return discountCell;
        }
            break;
            
        case ZFCartListBlocksTypeUnavailable: {
            ZFCartUnavailableGoodsTableViewCell *unavailableCell = [tableView dequeueReusableCellWithIdentifier:kZFCartUnavailableGoodsTableViewCellIdentifier];
            unavailableCell.model = blockModel.cartList[indexPath.row];
            unavailableCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return unavailableCell;
        }
            break;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
     * 如果是普通商品分栏，设置ZFCartDiscountGoodsHeaderView
     * 如果是活动满减分栏，设置ZFCartDiscountGoodsHeaderView
     * 如果是过期商品分栏，设置ZFCartUnavailableGoodsHeaderView;
     */
    if ((section > self.cartListResultModel.goodsBlockList.count - 1) || self.cartListResultModel.goodsBlockList.count == 0) {
        return nil;
    }
    
    ZFCartGoodsListModel *blockModel = self.cartListResultModel.goodsBlockList[section];
    switch ([blockModel.goodsModuleType integerValue]) {
        case ZFCartListBlocksTypeNormal: {
            ZFCartDiscountGoodsHeaderView *normalHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFCartDiscountGoodsHeaderViewIdentifier];
            normalHeaderView.model = blockModel;
            @weakify(self);
            normalHeaderView.cartDiscountTopicJumpCompletionHandler = ^{
                @strongify(self);
                [self cartSelectDiscountTopicJumpWithUrl:blockModel.url];
            };
            return normalHeaderView;
        }
            break;
            
        case ZFCartListBlocksTypeDiscount: {
            ZFCartDiscountGoodsHeaderView *discountHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFCartDiscountGoodsHeaderViewIdentifier];
            discountHeaderView.model = blockModel;
            @weakify(self);
            discountHeaderView.cartDiscountTopicJumpCompletionHandler = ^{
                @strongify(self);
                [self cartSelectDiscountTopicJumpWithUrl:blockModel.url];
            };
            return discountHeaderView;
        }
            break;
            
        case ZFCartListBlocksTypeUnavailable: {
            ZFCartUnavailableGoodsHeaderView *unavailableHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFCartUnavailableGoodsHeaderViewIdentifier];
            @weakify(self);
            unavailableHeaderView.cartUnavailableGoodsClearAllCompletionHandler = ^{
                @strongify(self);
                [self.view addSubview:self.clearAllTipsView];
                [self.clearAllTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
                }];
                [self.clearAllTipsView tipsShowAnimation];
                @weakify(self);
                self.clearAllTipsView.cartUnavailableClearAllConfirmCompletionHandler = ^(BOOL isConfirm) {
                    @strongify(self);
                    if (isConfirm) {
                        [self cartClearAllUnavailableGoodsOption];
                    }
                    [self.clearAllTipsView removeFromSuperview];
                };
            };
            return unavailableHeaderView;
        }
            break;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section < self.cartListResultModel.goodsBlockList.count && [self.cartListResultModel.goodsBlockList[section].goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
        if (self.cartListResultModel.goodsBlockList[section].cartList.count <= 2) {
            return nil;
        }
        ZFCartUnavailableViewAllView *viewAllView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFCartUnavailableViewAllViewIdentifier];
        viewAllView.isShowMore = self->_isUnavailableViewAll;
        @weakify(self);
        viewAllView.cartUnavailableViewAllSelectCompletionHandler = ^(BOOL isShowMore) {
            @strongify(self);
            self->_isUnavailableViewAll = isShowMore;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
        };
        return viewAllView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > self.cartListResultModel.goodsBlockList.count - 1) {
        return CGFLOAT_MIN;
    }
    ZFCartGoodsListModel *blockModel = self.cartListResultModel.goodsBlockList[section];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *initializeDict = [defaults objectForKey:kInitialize];
    if (![blockModel.goodsModuleType integerValue] && (initializeDict && ![NSStringUtils isEmptyString:initializeDict[@"tips"]])) {
        
        return self.cartListResultModel.goodsBlockList.count == 0 ? CGFLOAT_MIN : 40;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((!self.cartListResultModel.goodsBlockList || !self.cartListResultModel.goodsBlockList.count) && ([[CartOperationManager sharedManager] recentList].count > 0)) {
        return 98 + 200 * DSCREEN_WIDTH_SCALE;
    }
    return (indexPath.section > self.cartListResultModel.goodsBlockList.count - 1) ? 98 + 200 * DSCREEN_WIDTH_SCALE : 144;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section > self.cartListResultModel.goodsBlockList.count - 1 && [[CartOperationManager sharedManager] recentList].count > 0) {
        return CGFLOAT_MIN;
    }
    if (section < self.cartListResultModel.goodsBlockList.count && [self.cartListResultModel.goodsBlockList[section].goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
        return self.cartListResultModel.goodsBlockList[section].cartList.count > 2 ? 52 : 12;
    }
    return 12;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section < self.cartListResultModel.goodsBlockList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ZFLocalizedString(@"Address_List_Cell_Delete", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section < self.cartListResultModel.goodsBlockList.count) {
        ZFCartGoodsModel *goodModel = self.cartListResultModel.goodsBlockList[indexPath.section].cartList[indexPath.row];
        if (!goodModel) return;
        [self.view addSubview:self.deleteTipsView];
        [self.deleteTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        [self.deleteTipsView tipsShowAnimation];
        @weakify(self);
        self.deleteTipsView.cartDeleteGoodsConfirmCompletionHandler = ^(BOOL isConfirm) {
            @strongify(self);
            if (isConfirm) {
                [self cartGoodsDeleteOptionWithGoodsId:goodModel.goods_id];
            }
            [self.deleteTipsView removeFromSuperview];
            self.tableView.editing = NO;
        };
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bag" actionName:@"Bag - Delete" label:@"Bag - Delete"];
        [ZFAnalytics removeFromCartWithItem:goodModel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((!self.cartListResultModel.goodsBlockList || indexPath.section > self.cartListResultModel.goodsBlockList.count - 1) || ((!self.cartListResultModel.goodsBlockList || !self.cartListResultModel.goodsBlockList.count) && ([[CartOperationManager sharedManager] recentList].count > 0))) {
        return ;
    }
    ZFCartGoodsListModel *blockModel = self.cartListResultModel.goodsBlockList[indexPath.section];
    if ([blockModel.goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
        return ;
    }
    ZFCartGoodsModel *goodsModel = blockModel.cartList[indexPath.row];
    [self cartGoodsIdDetailJumpWithGoodsId:blockModel.cartList[indexPath.row].goods_id];
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Click_Bag_Goods_%@", goodsModel.goods_id] itemName:goodsModel.goods_title ContentType:@"Goods" itemCategory:@"Bag_List"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.discountTipsView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.priceOptionView];
    [self.view addSubview:self.checkOutButton];
    [self.view addSubview:self.fastPayButton];
    
}

- (void)zfAutoLayoutView {
    [self.discountTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(self.discountTipsView.discountTips.length > 0 ? 28 : 0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.discountTipsView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-90);
    }];
    
    [self.priceOptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.fastPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceOptionView.mas_bottom);
        make.leading.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 46));
    }];
    
    [self.checkOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, 46));
        make.top.mas_equalTo(self.priceOptionView.mas_bottom);
        make.trailing.mas_equalTo(self.view);
        make.leading.mas_equalTo(self.fastPayButton.mas_trailing);
    }];
}

#pragma mark - getter
- (NSMutableArray *)selectGoodsArray {
    if (!_selectGoodsArray) {
        _selectGoodsArray = [NSMutableArray array];
    }
    return _selectGoodsArray;
}

- (ZFCartViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCartViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFCartListResultModel *)cartListResultModel {
    if (!_cartListResultModel) {
        _cartListResultModel = [[ZFCartListResultModel alloc] init];
    }
    return _cartListResultModel;
}

- (ZFCartDiscountTipsView *)discountTipsView {
    if (!_discountTipsView) {
        _discountTipsView = [[ZFCartDiscountTipsView alloc] initWithFrame:CGRectZero];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *initializeDict = [defaults objectForKey:kInitialize];
        _discountTipsView.discountTips = initializeDict[@"tips"];
    }
    return _discountTipsView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 144;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZFCartDiscountGoodsTableViewCell class] forCellReuseIdentifier:kZFCartDiscountGoodsTableViewCellIdentifier];
        [_tableView registerClass:[ZFCartUnavailableGoodsTableViewCell class] forCellReuseIdentifier:kZFCartUnavailableGoodsTableViewCellIdentifier];
        [_tableView registerClass:[ZFCartDiscountGoodsHeaderView class] forHeaderFooterViewReuseIdentifier:kZFCartDiscountGoodsHeaderViewIdentifier];
        [_tableView registerClass:[ZFCartUnavailableGoodsHeaderView class] forHeaderFooterViewReuseIdentifier:kZFCartUnavailableGoodsHeaderViewIdentifier];
        [_tableView registerClass:[ZFCartUnavailableViewAllView class] forHeaderFooterViewReuseIdentifier:kZFCartUnavailableViewAllViewIdentifier];
        [_tableView registerClass:[ZFCartRecentHistoryView class] forCellReuseIdentifier:kZFCartRecentHistoryViewIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestCartListNetwork:@"" completion:^(id obj) {
                @strongify(self);
                self.cartListResultModel = obj;
                self.priceOptionView.model = self.cartListResultModel;
                [[NSUserDefaults standardUserDefaults] setValue:@(self.cartListResultModel.totalNumber) forKey:kCollectionBadgeKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                self.title = [NSString stringWithFormat:@"%@(%lu)",ZFLocalizedString(@"Bag_VC_Title",nil), self.cartListResultModel.totalNumber];
                
                if (self.cartListResultModel.goodsBlockList.count == 0) {
                    [self noGoodsInCartRefresh];
                } else {
                    self.tableView.tableHeaderView = nil;
                }
                [self dealAllSelectGoodsIntoArray];
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                
                if (self.cartListResultModel.goodsBlockList.count == 0) {
                    [self noGoodsInCartRefresh];
                } else {
                    self.tableView.tableHeaderView = nil;
                }
                [self dealAllSelectGoodsIntoArray];
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
            }];
        }];
    }
    return _tableView;
}

- (ZFCartPriceOptionView *)priceOptionView {
    if (!_priceOptionView) {
        _priceOptionView = [[ZFCartPriceOptionView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _priceOptionView.cartSelctAllGoodsCompletionHandler = ^(BOOL isSelect) {
            @strongify(self);
            [self selectAllGoodsWithSelect:isSelect];
        };
    }
    return _priceOptionView;
}

- (UIButton *)checkOutButton {
    if (!_checkOutButton ) {
        _checkOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkOutButton.backgroundColor = [UIColor blackColor];
        _checkOutButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _checkOutButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_checkOutButton setTitle:ZFLocalizedString(@"Bag_CheckOut",nil) forState:UIControlStateNormal];
        [_checkOutButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        [_checkOutButton addTarget:self action:@selector(checkOutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _checkOutButton;
}

- (UIButton *)fastPayButton {
    if (!_fastPayButton) {
        _fastPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fastPayButton.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        [_fastPayButton setImage:[UIImage imageNamed:@"fast_paypal"] forState:UIControlStateNormal];
        [_fastPayButton setImage:[UIImage imageNamed:@"fast_paypal_disable"] forState:UIControlStateDisabled];
        [_fastPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fastPayButton addTarget:self action:@selector(fastPaymentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fastPayButton;
}

- (ZFCartDeleteGoodsTipsView *)deleteTipsView {
    if (!_deleteTipsView) {
        _deleteTipsView = [[ZFCartDeleteGoodsTipsView alloc] initWithFrame:CGRectZero];
    }
    return _deleteTipsView;
}

- (ZFCartUnavailableClearAllTipsView *)clearAllTipsView {
    if (!_clearAllTipsView) {
        _clearAllTipsView = [[ZFCartUnavailableClearAllTipsView alloc] initWithFrame:CGRectZero];
    }
    return _clearAllTipsView;
}

- (ZFCartNoDataEmptyView *)noGoodsEmptyView {
    if (!_noGoodsEmptyView) {
        _noGoodsEmptyView = [[ZFCartNoDataEmptyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 288)];
        @weakify(self);
        _noGoodsEmptyView.cartNoDataContinueShopCompletionHandler = ^{
            @strongify(self);
            ZFTabBarController *tabBarVC = APPDELEGATE.tabBarVC;
            tabBarVC.selectedIndex = TabBarIndexHome;
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
    }
    return _noGoodsEmptyView;
}

- (ZFNoNetEmptyView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[ZFNoNetEmptyView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _noNetworkView.noNetEmptyReRequestCompletionHandler = ^{
            @strongify(self);
            [self requestCartListDataInfoOption];
        };
    }
    return _noNetworkView;
}
@end


