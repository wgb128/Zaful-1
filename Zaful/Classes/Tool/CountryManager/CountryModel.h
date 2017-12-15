//
//  CountryModel.h
//  Yoshop
//
//  Created by zhaowei on 16/6/2.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProvinceModel;
@interface CountryModel : NSObject<NSCoding>
@property (nonatomic,copy) NSString *countryId;
@property (nonatomic,copy) NSString *countryName;
@property (nonatomic,strong) NSArray<ProvinceModel *> *provinceList;
@end
