//
//  TopicListModel.h
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicListModel : NSObject

@property (nonatomic, strong) NSString *topicId; //话题的id
@property (nonatomic, strong) NSString *siteVersion; //
@property (nonatomic, strong) NSString *title; //话题标题
@property (nonatomic, strong) NSString *content; //话题内容
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *labelStatus;
@property (nonatomic, strong) NSString *iosIndexpic;
@property (nonatomic, strong) NSString *iosListpic;
@property (nonatomic, strong) NSString *iosDetailpic;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *virtualNumber;
@property (nonatomic, strong) NSString *readNumber;
@property (nonatomic, strong) NSString *orderby;
@property (nonatomic, strong) NSString *isTopic;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *joinNumber; //参加话题人数

@end
