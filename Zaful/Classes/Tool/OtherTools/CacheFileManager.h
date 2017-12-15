//
//  CacheFileManager.h
//  Yoshop
//
//  Created by zhaowei on 16/6/15.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheFileManager : NSObject
+ (CGFloat)fileSizeAtPath:(NSString *)path;

+ (CGFloat)folderSizeAtPath:(NSString *)path;

+ (void)clearCache:(NSString *)path;

+ (void)clearDatabaseCache:(NSString *)path;
@end
