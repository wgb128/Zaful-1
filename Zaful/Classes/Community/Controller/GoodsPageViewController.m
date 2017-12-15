//
//  GoodsPageViewController.m
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "GoodsPageViewController.h"
#import "WishlistViewController.h"
#import "BagViewController.h"
#import "OrderViewController.h"
#import "RecentViewController.h"
#import "ZFCollectionModel.h"
#import "GoodListModel.h"
#import "PostOrderListModel.h"
#import "CommendModel.h"
#import "SelectGoodsModel.h"
#import "PostGoodsManager.h"

static NSInteger const KMenuHeight = 44;

@interface GoodsPageViewController ()
@property (nonatomic, strong) NSArray *pageArray;
@property (nonatomic,strong) NSMutableArray *wishArray;
@property (nonatomic,strong) NSMutableArray *bagArray;
@property (nonatomic,strong) NSMutableArray *orderArray;
@property (nonatomic,strong) NSMutableArray *recentArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,assign) BOOL isFirstTimeEnter;
@end

@implementation GoodsPageViewController

#pragma mark - Life cycle
- (instancetype)init {
    NSArray *viewControllers = @[[WishlistViewController class],
                                 [BagViewController class],
                                 [OrderViewController class],
                                 [RecentViewController class]];
    NSArray *titles = @[ZFLocalizedString(@"GoodsPage_VC_WishList",nil),
                        ZFLocalizedString(@"GoodsPage_VC_Bag",nil),
                        ZFLocalizedString(@"GoodsPage_VC_Order",nil),
                        ZFLocalizedString(@"GoodsPage_VC_Recent",nil)];
    
    self = [super initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.progressViewIsNaughty = YES;
        self.bounces = YES;
        self.pageAnimatable = YES;
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 16;
        self.titleColorSelected = ZFCOLOR(51, 51, 51, 1);
        self.titleColorNormal = ZFCOLOR(153, 153, 153, 1);
        self.menuItemWidth = SCREEN_WIDTH / self.pageArray.count;
        self.progressWidth = SCREEN_WIDTH / self.pageArray.count;
        self.progressHeight = 2;
        
        self.wishArray = [PostGoodsManager sharedManager].wishArray;
        self.bagArray = [PostGoodsManager sharedManager].bagArray;
        self.orderArray = [PostGoodsManager sharedManager].orderArray;
        self.recentArray = [PostGoodsManager sharedManager].recentArray;
        self.isFirstTimeEnter = [PostGoodsManager sharedManager].isFirstTimeEnter;
        
        NSDictionary *wishDict = @{@"selectArray":self.wishArray,
                                   @"bagArray":self.bagArray,
                                   @"orderArray":self.orderArray,
                                   @"recentArray":self.recentArray,
                                   @"isFirstTimeEnter":@(self.isFirstTimeEnter)
                                   };
        NSDictionary *bagDict = @{@"selectArray":self.bagArray,
                                   @"wishArray":self.wishArray,
                                   @"orderArray":self.orderArray,
                                   @"recentArray":self.recentArray
                                   };
        NSDictionary *orderDict = @{@"selectArray":self.orderArray,
                                  @"wishArray":self.wishArray,
                                  @"bagArray":self.bagArray,
                                  @"recentArray":self.recentArray
                                  };
        NSDictionary *recentDict = @{@"selectArray":self.recentArray,
                                    @"wishArray":self.wishArray,
                                    @"bagArray":self.bagArray,
                                    @"orderArray":self.orderArray
                                    };

        self.values = @[wishDict, bagDict, orderDict,recentDict].mutableCopy;
        self.keys = @[@"wishDict", @"bagDict",@"orderDict",@"recentDict"].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    [self setNavagationBarDefaultBackButton];
    [self setNavagationBarRightButtonWithTitle:ZFLocalizedString(@"GoodsPage_VC_Done",nil) font:[UIFont systemFontOfSize:18] color:ZFCOLOR(255, 168, 0, 1)];
    @weakify(self)
    self.rightBarItemBlock = ^{
        @strongify(self)
        [self sendSelectGoods];
    };
    
    self.leftBarItemBlock = ^{
        //[[PostGoodsManager sharedManager] clearData];
    };
    
}

#pragma mark - WMPageControllerDelegate
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = ZFCOLOR(245, 245, 245, 1);;
    return CGRectMake(0, 0, KScreenWidth, KMenuHeight);
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, KScreenWidth, KScreenHeight - originY);
}


#pragma mark - DoneButton Action
- (void)sendSelectGoods {
    [PostGoodsManager sharedManager].wishArray = self.wishArray;
    [PostGoodsManager sharedManager].bagArray = self.bagArray;
    [PostGoodsManager sharedManager].orderArray = self.orderArray;
    [PostGoodsManager sharedManager].recentArray = self.recentArray;
    
    [self.selectArray removeAllObjects];
    @autoreleasepool {
        [self.wishArray enumerateObjectsUsingBlock:^(ZFCollectionModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            SelectGoodsModel *selectModel = [[SelectGoodsModel alloc] init];
            selectModel.imageURL = model.goods_grid;
            selectModel.goodsID = model.goods_id;
            selectModel.goodsType = CommunityGoodsTypeWish;
            [self.selectArray addObject:selectModel];
        }];
        
        [self.bagArray enumerateObjectsUsingBlock:^(GoodListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            SelectGoodsModel *selectModel = [[SelectGoodsModel alloc] init];
            selectModel.imageURL = model.goods_img;
            selectModel.goodsID = model.goods_id;
            selectModel.goodsType = CommunityGoodsTypeBag;
            [self.selectArray addObject:selectModel];
        }];
        
        [self.orderArray enumerateObjectsUsingBlock:^(PostOrderListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            SelectGoodsModel *selectModel = [[SelectGoodsModel alloc] init];
            selectModel.imageURL = model.goods_thumb;
            selectModel.goodsID = model.goods_id;
            selectModel.goodsType = CommunityGoodsTypeOrder;
            [self.selectArray addObject:selectModel];
        }];
        
        [self.recentArray enumerateObjectsUsingBlock:^(CommendModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            SelectGoodsModel *selectModel = [[SelectGoodsModel alloc] init];
            selectModel.imageURL = model.goodsThumb;
            selectModel.goodsID = model.goodsId;
            selectModel.goodsType = CommunityGoodsTypeRecent;
            [self.selectArray addObject:selectModel];
        }];
        if (self.doneBlock) {
            self.doneBlock(self.selectArray);
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark - Setter/Getter
-(NSArray *)pageArray {
    if (!_pageArray) {
        _pageArray = @[ZFLocalizedString(@"GoodsPage_VC_WishList",nil),
                       ZFLocalizedString(@"GoodsPage_VC_Bag",nil),
                       ZFLocalizedString(@"GoodsPage_VC_Order",nil),
                       ZFLocalizedString(@"GoodsPage_VC_Recent",nil)];
    }
    return _pageArray;
}

-(NSMutableArray *)wishArray {
    if (!_wishArray) {
        _wishArray = [NSMutableArray array];
    }
    return _wishArray;
}

-(NSMutableArray *)bagArray {
    if (!_bagArray) {
        _bagArray = [NSMutableArray array];
    }
    return _bagArray;
}

-(NSMutableArray *)orderArray {
    if (!_orderArray) {
        _orderArray = [NSMutableArray array];
    }
    return _orderArray;
}

-(NSMutableArray *)recentArray {
    if (!_recentArray) {
        _recentArray = [NSMutableArray array];
    }
    return _recentArray;
}

-(NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

@end
