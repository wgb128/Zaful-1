//
//  ZFAnalyticsTimeManager.h
//  Zaful
//
//  Created by zhaowei on 2016/12/19.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFAnalyticsTimeManager : NSObject
@property (nonatomic,strong) NSMutableDictionary *recodeTimeDict;

+ (ZFAnalyticsTimeManager *)sharedManager;

- (void)logTimeWithEventName:(NSString*)name;
@end
