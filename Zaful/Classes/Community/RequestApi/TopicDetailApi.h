//
//  TopicDetailApi.h
//  Zaful
//
//  Created by DBP on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface TopicDetailApi : SYBaseRequest

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString*)pageSize topicId:(NSString *)topicId sort:(NSString *)sort;

@end
