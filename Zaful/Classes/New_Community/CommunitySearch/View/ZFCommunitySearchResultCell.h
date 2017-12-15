//
//  ZFCommunitySearchResultCell.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunitySearchResultModel;

typedef void(^SearchResultFollowUserCompletionHandler)(ZFCommunitySearchResultModel *model);

@interface ZFCommunitySearchResultCell : UITableViewCell
@property (nonatomic, strong) ZFCommunitySearchResultModel              *model;

@property (nonatomic, copy) SearchResultFollowUserCompletionHandler     searchResultFollowUserCompletionHandler;
@end
