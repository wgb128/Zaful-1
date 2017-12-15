//
//  ZFCommunityAccountInfoModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityAccountInfoModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger followersCount;
@property (nonatomic, assign) NSInteger likeCount;
@property (nonatomic, assign) BOOL isFollow;
@end
