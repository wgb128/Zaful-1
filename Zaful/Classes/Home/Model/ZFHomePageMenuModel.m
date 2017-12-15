//
//  ZFHomePageMenuModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageMenuModel.h"
#import "ZFHomePageMenuApi.h"
#import "DBDataManager.h"

static NSString *const kTableName = @"zf_channelmenuInfo";
@interface ZFHomePageMenuModel ()

@property (nonatomic, strong) NSMutableArray *tabMenuModels;

@end

@implementation ZFHomePageMenuModel

+ (void)load {
    @autoreleasepool {
        if ([[DBDataManager shareInstance].db open]) {
            if (![[DBDataManager shareInstance] isTableExist:kTableName]) {
                NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE '%@' ('channel_id' VARCHAR NOT NULL UNIQUE , 'channel_title' VARCHAR, 'jump_type' VARCHAR)", kTableName];
                BOOL res = [[DBDataManager shareInstance].db executeUpdate:sqlCreateTable];
                if (!res) {
                    ZFLog(@"error when creating db table");
                } else {
                    ZFLog(@"success to creating db table");
                }
            }
            [[DBDataManager shareInstance].db close];
        }
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"tabTitle": @"channel_title",
             @"tabType": @"channel_id",
             @"jumpType": @"jump_type"
             };
}

- (void)requestHomePageMenuWithParam:(id)paramaters completeHandler:(void (^)(NSString *message, BOOL isSuccess))completeHandler {
    
    ZFHomePageMenuApi *homePageMenuApi = [[ZFHomePageMenuApi alloc] init];
    [homePageMenuApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        
        id requestJSON = request.responseJSONObject;
        NSInteger statusCode = [requestJSON ds_integerForKey:@"statusCode"];
        NSArray *resultArray = [requestJSON ds_arrayForKey:@"result"];
        // 成功
        if (statusCode == 200) {
            
            self.tabMenuModels = [[NSMutableArray alloc] initWithCapacity:resultArray.count];
            [ZFHomePageMenuModel deleteAllModels];
            if ([SystemConfigUtils isRightToLeftShow]) {
                for (NSInteger i = 0; i < resultArray.count; i++) {
                    NSInteger realIndex = resultArray.count - 1 - i;
                    NSDictionary *modelDictionary = resultArray[realIndex];
                    ZFHomePageMenuModel *model = [ZFHomePageMenuModel yy_modelWithJSON:modelDictionary];
                    [self.tabMenuModels addObject:model];
                    [ZFHomePageMenuModel instertWithModel:model];
                }
            } else {
                for (NSDictionary *modelDictionary in resultArray) {
                    ZFHomePageMenuModel *model = [ZFHomePageMenuModel yy_modelWithJSON:modelDictionary];
                    [self.tabMenuModels addObject:model];
                    [ZFHomePageMenuModel instertWithModel:model];
                }
            }
            completeHandler(nil, YES);
        } else { // 失败
            
            NSString *message = [requestJSON ds_stringForKey:@"msg"];
            completeHandler(message, NO);
        }
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
        
        completeHandler(error.localizedDescription, NO);
    }];
}

- (NSArray *)getTabMenuModels {
    return self.tabMenuModels;
}

#pragma mark - 数据库操作
+ (NSArray <ZFHomePageMenuModel *> *)selectAllModels {
    NSMutableArray *goodsArray  = [NSMutableArray new];
    if ([[DBDataManager shareInstance].db open]) {
        NSString *sql   = [NSString stringWithFormat:@"SELECT * FROM %@", kTableName];
        FMResultSet *rs = [[DBDataManager shareInstance].db executeQuery:sql];
        while ([rs next]) {
            ZFHomePageMenuModel *model = [[ZFHomePageMenuModel alloc] init];
            model.tabType  = [rs intForColumn:@"channel_id"];
            model.tabTitle = [model base64DecodedString:[rs stringForColumn:@"channel_title"]];
            model.jumpType = [model base64DecodedString:[rs stringForColumn:@"jump_type"]];;
            [goodsArray addObject:model];
        }
        [[DBDataManager shareInstance].db close];
    }
    return goodsArray;
}

+ (BOOL)deleteAllModels {
    BOOL success    = NO;
    if ([[DBDataManager shareInstance].db open]) {
        NSString *sql   = [NSString stringWithFormat:@"DELETE FROM %@", kTableName];
        BOOL rs = [[DBDataManager shareInstance].db executeUpdate:sql];
        if (!rs) {
            ZFLog(@"error when DELETE db zf_channelmenuInfo");
            success = NO;
        } else {
            ZFLog(@"success to DELETE db zf_channelmenuInfo");
            success = YES;
        }
        
        [[DBDataManager shareInstance].db close];
    }
    return success;
}

+ (BOOL)instertWithModel:(ZFHomePageMenuModel *)model {
    BOOL success    = NO;
    NSString *tabTypeString = [NSString stringWithFormat:@"%ld", model.tabType];
    NSString *tabTitleString = [model base64EncodedString:model.tabTitle];
    NSString *jumTypeString  = [model base64EncodedString:model.jumpType];
    if ([[DBDataManager shareInstance].db open]) {
        NSString *sql   = [NSString stringWithFormat:@"INSERT INTO %@ (channel_id, channel_title, jump_type) VALUES ('%@', '%@', '%@')", kTableName, tabTypeString, tabTitleString, jumTypeString];
        
        BOOL rs = [[DBDataManager shareInstance].db executeUpdate:sql];
        if (!rs) {
            ZFLog(@"error when insert db zf_channelmenuInfo");
            success = NO;
        } else {
            ZFLog(@"success to insert db zf_channelmenuInfo");
            success = YES;
        }
        
        [[DBDataManager shareInstance].db close];
    }
    return success;
}

+ (BOOL)deleteModelWithTabType:(NSInteger)tabType {
    BOOL success = NO;
    if ([[DBDataManager shareInstance].db open]) {
        NSString *sql   = [NSString stringWithFormat:@"DELETE FROM %@ where channel_id = '%ld'", kTableName, tabType];
        BOOL rs = [[DBDataManager shareInstance].db executeUpdate:sql];
        if (!rs) {
            ZFLog(@"error when DELETE tabType");
            success = NO;
        } else {
            ZFLog(@"success to DELETE tabType");
            success = YES;
        }
        
        [[DBDataManager shareInstance].db close];
    }
    return success;
}

+ (ZFHomePageMenuModel *)selectModelWithTabType:(NSInteger)tabType {
    ZFHomePageMenuModel *model   = [[ZFHomePageMenuModel alloc] init];
    if ([[DBDataManager shareInstance].db open]) {
        NSString *sql   = [NSString stringWithFormat:@"SELECT * FROM %@ where channel_id = %ld", kTableName, tabType];
        FMResultSet *rs = [[DBDataManager shareInstance].db executeQuery:sql];
        while ([rs next]) {
            model.tabType  = [rs intForColumn:@"channel_id"];
            model.tabTitle = [model base64DecodedString:[rs stringForColumn:@"channel_title"]];
            model.jumpType = [model base64DecodedString:[rs stringForColumn:@"jump_type"]];
        }
        [[DBDataManager shareInstance].db close];
    }
    
    return model;
}

- (NSString *)base64EncodedString:(NSString *)resourceString {
    NSData *data = [resourceString dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString:(NSString *)resourceString {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:resourceString options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
