//
//  FollowItemModel.h
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowItemModel : NSObject

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nikename;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL isFollow;

@end
