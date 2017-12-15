//
//  ZFCommunityFollowListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFCommunityFollowModel;

@interface ZFCommunityFollowListModel : NSObject
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray<ZFCommunityFollowModel *> *listArray;
@end
