//
//  AddressStateModel.h
//  Zaful
//
//  Created by zhaowei on 2017/4/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressStateModel : NSObject
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, assign) BOOL is_city;
@end
