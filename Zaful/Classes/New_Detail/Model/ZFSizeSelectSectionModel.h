//
//  ZFSizeSelectSectionModel.h
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFSizeSelectItemsModel.h"

typedef NS_ENUM(NSInteger, ZFSizeSelectSectionType) {
    ZFSizeSelectSectionTypeColor = 0,
    ZFSizeSelectSectionTypeSize,
    ZFSizeSelectSectionTypeSizeTips,
    ZFSizeSelectSectionTypeMultAttr,
    ZFSizeSelectSectionTypeQity,
};

@interface ZFSizeSelectSectionModel : NSObject

@property (nonatomic, assign) ZFSizeSelectSectionType                       type;
@property (nonatomic, strong) NSMutableArray<ZFSizeSelectItemsModel *>      *itmesArray;
@property (nonatomic, copy)   NSString                                      *typeName;

@end
