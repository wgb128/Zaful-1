//
//  ZFCommunityFollowModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityFollowModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isFollow;
@end
