//
//  CountryListModel.m
//  Yoshop
//
//  Created by zhaowei on 16/6/8.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "CountryListModel.h"
#import "CountryModel.h"

#define COUNTRY_KEY @"key"
#define COUNTRY_LIST @"countryList"

@implementation CountryListModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.key forKey:COUNTRY_KEY];
    [aCoder encodeObject:self.countryList forKey:COUNTRY_LIST];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.key = [aDecoder decodeObjectForKey:COUNTRY_KEY];
        self.countryList = [aDecoder decodeObjectForKey:COUNTRY_LIST];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"countryList" : @"country_list"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"countryList" : [CountryModel class]
             };
}

+ (NSArray *)modelPropertyWhitelist {
    return @[@"key",@"countryList"];
}
@end
