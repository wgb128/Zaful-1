//
//  DBDataManager.h
//  WuZhouHui
//
//  Created by QianHan on 16/10/28.
//  Copyright © 2016年 wuzhouhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface DBDataManager : NSObject

@property (nonatomic, strong) FMDatabase *db;

+ (instancetype)shareInstance;
- (BOOL)isTableExist:(NSString *)tableName;

@end
