//
//  ZFTrackingListModel.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFTrackingListModel : NSObject
@property (nonatomic, copy) NSString        *ondate;
@property (nonatomic, copy) NSString        *status;
@property (nonatomic, assign) NSInteger     trackTime;  //用于排序的时间戳
@property (assign, nonatomic, readonly)CGFloat height;
@end
