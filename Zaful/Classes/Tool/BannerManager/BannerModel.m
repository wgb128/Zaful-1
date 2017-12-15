//
//  BannerModel.m
//  Zaful
//
//  Created by DBP on 16/10/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel
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
             @"cat_node"      :@"cat_node",
             @"banner_height" :@"banner_height",
             @"is_child"      :@"is_child",
             @"deeplink_uri"  :@"deeplink_uri"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    
    return @[ @"href_type",
              @"href_location",
              @"key",
              @"title",
              @"image",
              @"cat_node",
              @"banner_height",
              @"is_child",
              @"deeplink_uri"
              ];
}

@end
