//
//  ZFPayMethodsWaysModel.h
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFPayMethodsChildModel;

@interface ZFPayMethodsWaysModel : NSObject

@property (nonatomic, strong) NSArray<ZFPayMethodsChildModel *>               *child;
@property (nonatomic, assign) NSInteger             node;   //1 cod方式， 2 online方式 3.组合方式

@end
