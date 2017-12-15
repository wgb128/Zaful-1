//
//  ZFSizeSelectItemsModel.h
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZFSizeSelectItemType) {
    ZFSizeSelectItemTypeColor = 0,
    ZFSizeSelectItemTypeSize,
    ZFSizeSelectItemTypeMultAttr
};

@interface ZFSizeSelectItemsModel : NSObject

@property (nonatomic, assign) ZFSizeSelectItemType          type;
@property (nonatomic, copy) NSString                        *attrName;
@property (nonatomic, copy) NSString                        *color;
@property (nonatomic, assign) BOOL                          is_click;
@property (nonatomic, copy) NSString                        *goodsId;
@property (nonatomic, assign) CGFloat                       width;
@property (nonatomic, assign) BOOL                          isSelect;
@end
