//
//  ZFHomePageMenuModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFHomePageMenuModel : NSObject<YYModel>

@property (nonatomic, copy) NSString *tabTitle;
@property (nonatomic, assign) NSInteger tabType;
@property (nonatomic, copy) NSString *jumpType;

- (void)requestHomePageMenuWithParam:(id)paramaters completeHandler:(void (^)(NSString *message, BOOL isSuccess))completeHandler;
- (NSArray *)getTabMenuModels;

+ (NSArray <ZFHomePageMenuModel *> *)selectAllModels;
+ (BOOL)deleteAllModels;
+ (BOOL)instertWithModel:(ZFHomePageMenuModel *)goodsModel;

@end
