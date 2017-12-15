//
//  MessagesListModel.h
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesListModel : NSObject

@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *review_id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *pic_src;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) MessageListType message_type;
@property (nonatomic, assign) BOOL is_delete;
@end
