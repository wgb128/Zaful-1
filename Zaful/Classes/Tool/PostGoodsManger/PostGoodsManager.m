//
//  PostGoodsManger.m
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostGoodsManager.h"
#import "SelectGoodsModel.h"
#import "ZFCollectionModel.h"
#import "GoodListModel.h"
#import "PostOrderListModel.h"
#import "CommendModel.h"

@interface PostGoodsManager ()


@end

@implementation PostGoodsManager

+ (PostGoodsManager *)sharedManager {
    static PostGoodsManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
        sharedManagerInstance.wishArray = [NSMutableArray array];
        sharedManagerInstance.bagArray = [NSMutableArray array];
        sharedManagerInstance.orderArray = [NSMutableArray array];
        sharedManagerInstance.recentArray = [NSMutableArray array];
        sharedManagerInstance.isFirstTimeEnter = YES;
    });
    return sharedManagerInstance;
}

- (void)removeGoodsWithModel:(SelectGoodsModel *)model {
    switch (model.goodsType) {
        case CommunityGoodsTypeWish:
        {
            [self.wishArray enumerateObjectsUsingBlock:^(ZFCollectionModel *wishModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([wishModel.goods_id isEqualToString:model.goodsID]) {
                    [self.wishArray removeObject:wishModel];
                }
            }];
            break;
        }
        case CommunityGoodsTypeBag:
        {
            [self.bagArray enumerateObjectsUsingBlock:^(GoodListModel *bagModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([bagModel.goods_id isEqualToString:model.goodsID]) {
                    [self.bagArray removeObject:bagModel];
                }
            }];
            break;
        }
        case CommunityGoodsTypeOrder:
        {
            [self.orderArray enumerateObjectsUsingBlock:^(PostOrderListModel *orderModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([orderModel.goods_id isEqualToString:model.goodsID]) {
                    [self.orderArray removeObject:orderModel];
                }
            }];
            break;
        }
        case CommunityGoodsTypeRecent:
        {
            [self.recentArray enumerateObjectsUsingBlock:^(CommendModel *recentModel, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([recentModel.goodsId isEqualToString:model.goodsID]) {
                    [self.recentArray removeObject:recentModel];
                }
            }];
            break;
        }
    }
}

- (void)clearData {
    [self.wishArray removeAllObjects];
    [self.bagArray removeAllObjects];
    [self.orderArray removeAllObjects];
    [self.recentArray removeAllObjects];
}


@end
