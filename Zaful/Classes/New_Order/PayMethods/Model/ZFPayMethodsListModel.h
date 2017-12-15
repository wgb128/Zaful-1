//
//  ZFPayMethodsListModel.h
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartCodModel.h"
@class ZFPayMethodsWaysModel;


@interface ZFPayMethodsListModel : NSObject
@property (nonatomic, strong) CartCodModel                      *cod;
@property (nonatomic, copy) NSString                            *cod_msg;
@property (nonatomic, strong) NSArray<ZFPayMethodsWaysModel *>  *pay_ways;
@end
