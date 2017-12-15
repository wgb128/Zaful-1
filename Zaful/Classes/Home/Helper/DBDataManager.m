//
//  DBDataManager.m
//  WuZhouHui
//
//  Created by QianHan on 16/10/28.
//  Copyright © 2016年 wuzhouhui. All rights reserved.
//

#import "DBDataManager.h"
#import "FileManager.h"

@implementation DBDataManager

+ (instancetype)shareInstance {
    static DBDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[DBDataManager alloc] init];
        NSString *dbPath    = [[FileManager sharedInstance] createFilePathWithFileName:kSQLiteDBName folderName:@"db"];
        NSLog(@"%@", dbPath);
        dataManager.db  = [FMDatabase databaseWithPath:dbPath];
    });
    return dataManager;
}

- (BOOL)isTableExist:(NSString *)tableName {
    FMResultSet *rs = [self.db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableExist %ld", (long)count);
        if (0 == count) {
            return NO;
        } else {
            return YES;
        }
    }
    
    return NO;
}

@end
