//
//  ZFCommunityFollowingViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCommunityFollowingViewModel : BaseViewModel
@property (nonatomic, copy) NSString        *userId;
- (void)requestFollowUserNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
