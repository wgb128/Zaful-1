//
//  ZFCommunitySuggestedUsersModel.h
//  Zaful
//
//  Created by liuxi on 2017/7/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunitySuggestedUsersModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, copy) NSString *likes_total;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *review_total;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSArray *postlist;
@end
