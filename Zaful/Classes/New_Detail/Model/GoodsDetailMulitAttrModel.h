//
//  GoodsDetailMulitAttrModel.h
//  Zaful
//
//  Created by liuxi on 2017/10/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetailMulitAttrInfoModel.h"
@interface GoodsDetailMulitAttrModel : NSObject
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, strong) NSArray<GoodsDetailMulitAttrInfoModel *>       *value;
@end
