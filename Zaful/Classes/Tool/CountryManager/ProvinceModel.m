//
//  ProvinceModel.m
//  Yoshop
//
//  Created by zhaowei on 16/6/2.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ProvinceModel.h"

#define PROVINCE_ID @"provinceId"
#define PROVINCE_NAME @"provinceName"

@implementation ProvinceModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.provinceId forKey:PROVINCE_ID];
    [aCoder encodeObject:self.provinceName forKey:PROVINCE_NAME];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.provinceId = [aDecoder decodeObjectForKey:PROVINCE_ID];
        self.provinceName = [aDecoder decodeObjectForKey:PROVINCE_NAME];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"provinceId" : @"province_id",@"provinceName" : @"province_name"};
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"provinceId",@"provinceName"];
}
@end
