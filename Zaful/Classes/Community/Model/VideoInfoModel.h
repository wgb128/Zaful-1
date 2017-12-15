//
//  VideoInfoModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoInfoModel : NSObject

@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *viewNum;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoDesc;

@end
