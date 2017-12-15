//
//  TopicDetailHeadLabelModel.h
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicDetailHeadLabelModel : NSObject

@property (nonatomic, strong) NSString *topicLabelId;//话题标签Id
@property (nonatomic, strong) NSString *content;//内容
@property (nonatomic, strong) NSString *topicLabel;//话题标签
@property (nonatomic, strong) NSString *labelStatus;//标签状态
@property (nonatomic, strong) NSString *number;//
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *virtualNumber;//评论ID
@property (nonatomic, strong) NSString *joinNumber;//参与人数
@property (nonatomic, strong) NSString *type;//当前回复用户的ID
@property (nonatomic, strong) NSString *iosDetailpic;

@end
