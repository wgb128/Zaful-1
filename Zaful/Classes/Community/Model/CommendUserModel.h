//
//  CommendUserModel.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//  推荐用户Model

#import <Foundation/Foundation.h>

@interface CommendUserModel : NSObject

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) NSString *likes_total;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *review_total;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSArray *postlist;

@end
