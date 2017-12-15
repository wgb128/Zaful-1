//
//  FollowViewController.h
//  Buyyer
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 Globalegrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFBaseViewController.h"

@interface FollowViewController : ZFBaseViewController

@property (nonatomic, assign) ZFUserListType userListType;
@property (nonatomic, copy)   NSString       *rid;// 评论ID
@property (nonatomic, copy)   NSString       *userId;

@end
