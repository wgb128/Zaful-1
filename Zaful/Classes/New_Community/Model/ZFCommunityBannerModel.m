//
//  ZFCommunityBannerModel.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityBannerModel.h"

@implementation ZFCommunityBannerModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.href_type = [aDecoder decodeObjectForKey:@"href_type"];
        self.key = [aDecoder decodeObjectForKey:@"key"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.href_type forKey:@"href_type"];
    [aCoder encodeObject:self.key forKey:@"key"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"href_type"     :@"href_type",
             @"href_location" :@"href_location",
             @"key"           :@"key",
             @"title"         :@"title",
             @"image"         :@"image",
             @"cat_node"      :@"cat_node"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[ @"href_type",
              @"href_location",
              @"key",
              @"title",
              @"image",
              @"cat_node"];
}
@end
