//
//  ZFHomePageMenuViewModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFHomePageMenuModel.h"

@interface ZFHomePageMenuViewModel : NSObject

@property (nonatomic, strong) NSArray      *tabMenuModels;
@property (nonatomic, copy  ) NSString     *message;
@property (nonatomic, assign) BOOL         isSuccess;

- (void)requestHomePageMenuWithParam:(id)parmaters completeHandler:(void (^)(void))completeHandler;
- (NSArray <NSString *> *)keys;
- (NSArray <NSString *> *)values;
- (NSArray *)tabMenuTitles;

@end
