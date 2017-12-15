//
//  ZFChannelBannerModel.m
//  Zaful
//
//  Created by QianHan on 2017/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFChannelBannerModel.h"

@implementation ZFChannelBannerModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"bannerId":@"banner_id",
             @"bannerImgURL":@"banner_img",
             @"bannerImgHeight": @"banner_img_height",
             @"bannerName": @"banner_name",
             @"bannerSort": @"banner_sort",
             @"channelId":@"channel_id",
             @"deepLinkURL": @"deeplink_uri",
             @"isShow": @"is_show"
             };
}

@end
