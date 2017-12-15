//
//  DRewardsApi.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SYBaseRequest.h"

@interface MyPointsApi : SYBaseRequest

- (instancetype)initDRewardsApiWithPage:(NSInteger)page withSize:(NSInteger)size;

@end
