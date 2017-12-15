//
//  ZFCommunityMoreHotVideoListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCommunityMoreHotVideoModel;
@interface ZFCommunityMoreHotVideoListModel : NSObject
@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray<ZFCommunityMoreHotVideoModel *> *videoList;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger pageCount;
@end
