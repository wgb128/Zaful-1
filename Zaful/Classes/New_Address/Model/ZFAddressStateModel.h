//
//  ZFAddressStateModel.h
//  Zaful
//
//  Created by Apple on 2017/9/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFAddressStateModel : NSObject
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, assign) BOOL is_city;

@property (nonatomic, assign) NSUInteger        hashCost;
@end
