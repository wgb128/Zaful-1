//
//  TopicDetailHeadLabelModel.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicDetailHeadLabelModel.h"

@implementation TopicDetailHeadLabelModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"topicLabelId"    :   @"id",
             @"content"         :   @"content",
             @"topicLabel"      :   @"label",
             @"labelStatus"     :   @"label_status",
             @"number"          :   @"number",
             @"virtualNumber"   :   @"virtual_number",
             @"joinNumber"      :   @"join_number",
             @"type"            :   @"type",
             @"title"           :   @"title",
             @"iosDetailpic"    :   @"ios_detailpic"
             };
}

// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
+ (NSArray *)modelPropertyWhitelist {
    return @[
             @"topicLabelId",
             @"content",
             @"topicLabel",
             @"labelStatus",
             @"number",
             @"virtualNumber",
             @"joinNumber",
             @"type",
             @"title",
             @"iosDetailpic"
             ];
}

@end
