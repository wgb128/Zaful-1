//
//  DeleteApi.h
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface DeleteApi : SYBaseRequest

- (instancetype)initWithDeleteId:(NSString *)deleteId andUserId:(NSString *)userId;


@end
