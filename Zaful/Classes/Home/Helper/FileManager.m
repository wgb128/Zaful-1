//
//  FileManager.m
//  WuZhouHui
//
//  Created by karl.luo on 16/7/22.
//  Copyright © 2016年 wuzhouhui. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (instancetype)sharedInstance {
    
    static FileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        fileManager = [[FileManager alloc] init];
    });
    return fileManager;
}

- (NSString *)createFilePathWithFileName:(NSString *)fileName folderName:(NSString *)folderName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpPath = [self filePathWithFileName:fileName folderName:folderName];
    if ([fileManager fileExistsAtPath:tmpPath]) {
        
        return tmpPath;
    }
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    NSString *path = [array objectAtIndex:0];
    if (folderName.length > 0) {
        
        path = [path stringByAppendingPathComponent:folderName];
    }
    BOOL bo = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(bo, @"创建目录失败");
    
    NSString *result = [path stringByAppendingPathComponent:fileName];
    
    return result;
}

- (NSString *)filePathWithFileName:(NSString *)fileName folderName:(NSString *)folderName {
    
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 在iOS中，只有一个目录跟传入的参数匹配，所以这个集合里面只有一个元素
    NSString *path = [array objectAtIndex:0];
    if (folderName.length > 0) {
        
        path = [path stringByAppendingPathComponent:folderName];
    }
    NSString *result = [path stringByAppendingPathComponent:fileName];
    
    return result;
}

- (BOOL)isExistFilepath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

- (void)deleteAllFileOfFolder:(NSString *)folder {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:folder];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
}

- (void)deleteAllFileOfFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:NULL];
}

- (void)deleteAllFileOfFolder:(NSString *)folder extension:(NSString *)ex {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:folder];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:ex]) {
            
            [fileManager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

@end
