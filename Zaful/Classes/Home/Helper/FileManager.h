//
//  FileManager.h
//  WuZhouHui
//
//  Created by karl.luo on 16/7/22.
//  Copyright © 2016年 wuzhouhui. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 文件管理
 */
@interface FileManager : NSObject

+ (instancetype)sharedInstance;
/**
 *  @brief 创建文件目录
 *
 *  @param fileName   文件名
 *  @param folderName 文件夹名
 *
 *  @return 文件路径
 */
- (NSString *)createFilePathWithFileName:(NSString *)fileName folderName:(NSString *)folderName;
/**
 *  @brief 获取文件目录
 *
 *  @param fileName   文件名
 *  @param folderName 文件夹名
 *
 *  @return 文件路径
 */
- (NSString *)filePathWithFileName:(NSString *)fileName folderName:(NSString *)folderName;
/**
 *  @brief 判断文件是否存在
 *
 *  @param fileName   文件名
 *  @param folderName 文件夹名
 *
 *  @return 是否存在， YES 存在 NO 不存在
 */
- (BOOL)isExistFilepath:(NSString *)filePath;
/**
 *  @brief 删除某文件夹下的所有文件
 *
 *  @param folder 文件夹名
 */
- (void)deleteAllFileOfFolder:(NSString *)folder;
/**
 *  @brief 删除某文件
 *
 *  @param filePath 文件路径
 */
- (void)deleteAllFileOfFilePath:(NSString *)filePath;
/**
 *  @brief 删除某文件夹下某个后缀名的所有文件
 *
 *  @param folder 文件夹名
 *  @param ex 后缀名
 */
- (void)deleteAllFileOfFolder:(NSString *)folder extension:(NSString *)ex;


@end
