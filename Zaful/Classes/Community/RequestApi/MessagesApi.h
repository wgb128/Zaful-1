//
//  MessagesApi.h
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface MessagesApi : SYBaseRequest

- (instancetype)initWithcurPage:(NSInteger)curPage pageSize:(NSString *)pageSize;

@end
