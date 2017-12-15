//
//  ZFOrderCheckInfoModel.h
//  Zaful
//
//  Created by TsangFa on 23/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFOrderCheckInfoDetailModel;
@interface ZFOrderCheckInfoModel : NSObject
@property (nonatomic, strong) ZFOrderCheckInfoDetailModel                       *order_info;
@property (nonatomic, assign) NSInteger                                         node;                       //1 cod方式， 2 online方式 3.组合方式

@end
