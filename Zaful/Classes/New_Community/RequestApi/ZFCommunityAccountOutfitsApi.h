//
//  ZFCommunityAccountOutfitsApi.h
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface ZFCommunityAccountOutfitsApi : SYBaseRequest
- (instancetype)initWithUserid:(NSString *)userid currentPage:(NSInteger)currentPage;
@end
