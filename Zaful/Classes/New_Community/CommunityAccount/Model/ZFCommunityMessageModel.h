//
//  ZFCommunityMessageModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityMessageModel : NSObject
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *review_id;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *pic_src;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) MessageListType message_type;
@property (nonatomic, assign) BOOL is_delete;
@end
