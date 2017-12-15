//
//  FriendsResultModel.h
//  Zaful
//
//  Created by zhaowei on 2017/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsResultModel : NSObject

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) NSString *likes_total;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *review_total;
@property (nonatomic, strong) NSString *user_id;

@end
