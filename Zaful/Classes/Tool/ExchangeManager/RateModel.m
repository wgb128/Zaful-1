//
//  RateModel.m
//  Yoshop
//
//  Created by zhaowei on 16/6/1.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "RateModel.h"
#define RATE_CODE @"code"
#define RATE_RATE @"rate"
#define RATE_SYMBOL @"symbol"
@implementation RateModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.code forKey:RATE_CODE];
    [aCoder encodeObject:self.rate forKey:RATE_RATE];
    [aCoder encodeObject:self.symbol forKey:RATE_SYMBOL];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:RATE_CODE];
        self.rate = [aDecoder decodeObjectForKey:RATE_RATE];
        self.symbol = [aDecoder decodeObjectForKey:RATE_SYMBOL];
    }
    return self;
}

-(NSString*) description{
    NSString* descriptionString = [NSString stringWithFormat:@"code:%@ \n rate:%@ \n symbol:%@ \n ", self.code, self.rate, self.symbol];
    
    return descriptionString;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"code"     : @"name",
             @"symbol"     : @"sign"
             };
}

@end
