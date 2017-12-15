//
//  CountryModel.m
//  Yoshop
//
//  Created by zhaowei on 16/6/2.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CountryModel.h"
#import "ProvinceModel.h"

#define COUNTRY_ID @"countryId"
#define COUNTRY_NAME @"countryName"
#define COUNTRY_PROVINCE @"province"

@implementation CountryModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.countryId forKey:COUNTRY_ID];
    [aCoder encodeObject:self.countryName forKey:COUNTRY_NAME];
    [aCoder encodeObject:self.provinceList forKey:COUNTRY_PROVINCE];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.countryId = [aDecoder decodeObjectForKey:COUNTRY_ID];
        self.countryName = [aDecoder decodeObjectForKey:COUNTRY_NAME];
        self.provinceList = [aDecoder decodeObjectForKey:COUNTRY_PROVINCE];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"countryId" : @"country_id",@"countryName" : @"country_name",@"provinceList" : @"province"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"provinceList" : [ProvinceModel class]
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"countryId",@"countryName",@"provinceList"];
}
@end
