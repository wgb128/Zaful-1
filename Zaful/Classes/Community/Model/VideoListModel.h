//
//  VideoListModel.h
//  Zaful
//
//  Created by zhaowei on 2016/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoListModel : NSObject

@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray *videoList;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageCount;

@end
