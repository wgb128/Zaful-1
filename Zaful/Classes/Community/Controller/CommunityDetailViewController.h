//
//  CommunityDetailViewController.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface CommunityDetailViewController : ZFBaseViewController

//接收外部创建传进来的 reviewId,userId
- (instancetype)initWithReviewId:(NSString *)reviewId userId:(NSString *)userId;

//首页获取的 reviewsId
@property (nonatomic, copy) NSString *reviewsId;

//首页获取的 userId
@property (nonatomic,copy) NSString *userId;

@property (nonatomic, assign) BOOL   isOutfits;
@end
