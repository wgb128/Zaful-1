//
//  VideoDetailApi.h
//  Zaful
//
//  Created by huangxieyue on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SYBaseRequest.h"

@interface VideoDetailApi : SYBaseRequest

- (instancetype)initWithVideoId:(NSString*)videoId;

@end
