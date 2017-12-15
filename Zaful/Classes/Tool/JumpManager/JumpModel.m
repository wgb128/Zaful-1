//
//  JumpModel.m
//  Zaful
//
//  Created by DBP on 16/10/25.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "JumpModel.h"

@implementation JumpModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.actionType         = [aDecoder decodeIntegerForKey:@"actionType"];
        self.url                = [aDecoder decodeObjectForKey:@"url"];
        self.name               = [aDecoder decodeObjectForKey:@"name"];
        self.startTime          = [aDecoder decodeObjectForKey:@"startTime"];
        self.endTime            = [aDecoder decodeObjectForKey:@"endTime"];
        self.bannerId           = [aDecoder decodeObjectForKey:@"bannerId"];
        self.imageURL           = [aDecoder decodeObjectForKey:@"imageURL"];
        self.isShare            = [aDecoder decodeBoolForKey:@"isShare"];
        self.shareImageURL      = [aDecoder decodeObjectForKey:@"shareImageURL"];
        self.shareTitle         = [aDecoder decodeObjectForKey:@"shareTitle"];
        self.shareLinkURL       = [aDecoder decodeObjectForKey:@"shareLinkURL"];
        self.shareDoc           = [aDecoder decodeObjectForKey:@"shareDoc"];
        self.leftTime           = [aDecoder decodeObjectForKey:@"leftTime"];
        self.serverTime         = [aDecoder decodeObjectForKey:@"serverTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.actionType forKey:@"actionType"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.bannerId forKey:@"bannerId"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeBool:self.isShare forKey:@"isShare"];
    [aCoder encodeObject:self.shareImageURL forKey:@"shareImageURL"];
    [aCoder encodeObject:self.shareTitle forKey:@"shareTitle"];
    [aCoder encodeObject:self.shareLinkURL forKey:@"shareLinkURL"];
    [aCoder encodeObject:self.shareDoc forKey:@"shareDoc"];
    [aCoder encodeObject:self.leftTime forKey:@"leftTime"];
    [aCoder encodeObject:self.serverTime forKey:@"serverTime"];
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"actionType"               : @"actionType",
             @"endTime"                  : @"endTime",
             @"bannerId"                 : @"id",
             @"imageURL"                 : @"image_url",
             @"isShare"                  : @"is_share",
             @"leftTime"                 : @"leftTime",
             @"name"                     : @"name",
             @"serverTime"               : @"serverTime",
             @"shareTitle"               : @"share_title",
             @"shareImageURL"            : @"share_img",
             @"shareLinkURL"             : @"share_link",
             @"shareDoc"                 : @"share_doc",
             @"goodsShopPrice"           : @"shop_price",
             @"startTime"                : @"startTime",
             @"url"                      : @"url"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist
{
    
    return  @[
              @"actionType",
              @"endTime",
              @"bannerId",
              @"imageURL",
              @"isShare",
              @"leftTime",
              @"name",
              @"serverTime",
              @"shareImageURL",
              @"shareTitle",
              @"shareLinkURL",
              @"shareDoc",
              @"goodsShopPrice",
              @"startTime",
              @"url"
              ];
}

@end
