//
//  TopicLabelModel.m
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "TopicLabelModel.h"

@implementation TopicLabelModel
+ (NSArray *)modelPropertyWhitelist {
    
    return @[
             @"topic_id",
             @"topic_label"
             ];
}

@end
