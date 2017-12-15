//
//  ZFPayMethodsChildModel.h
//  Zaful
//
//  Created by liuxi on 2017/10/13.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckOutGoodListModel;
@interface ZFPayMethodsChildModel : NSObject
@property (nonatomic, assign) NSInteger                                  type;   //1.cod方式， 2. online方式
@property (nonatomic, strong) NSArray<CheckOutGoodListModel *>           *goodsList;
@end
