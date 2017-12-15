//
//  ZFCommunitySearchResultViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCommunitySearchViewModel : BaseViewModel

- (void)requestFollowedNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;

- (void)requestSearchUsersNetwork:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
