//
//  PostGoodsManger.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SelectGoodsModel;
@interface PostGoodsManager : NSObject
@property (nonatomic,strong) NSMutableArray *wishArray;
@property (nonatomic,strong) NSMutableArray *bagArray;
@property (nonatomic,strong) NSMutableArray *orderArray;
@property (nonatomic,strong) NSMutableArray *recentArray;
@property (nonatomic,assign) BOOL isFirstTimeEnter;


+ (PostGoodsManager *)sharedManager;

- (void)removeGoodsWithModel:(SelectGoodsModel *)model;

- (void)clearData;


@end
