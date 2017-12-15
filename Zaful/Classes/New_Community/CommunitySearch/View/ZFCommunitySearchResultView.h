//
//  ZFCommunitySearchResultView.h
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommunitySearchNoResultsCompletionHandler)(void);

typedef void(^CommunitySearchResultUserInfoCompletionHandler)(NSString *userId);

@interface ZFCommunitySearchResultView : UIView

@property (nonatomic, copy) NSString            *searchKey;

@property (nonatomic, copy) CommunitySearchResultUserInfoCompletionHandler  communitySearchResultUserInfoCompletionHandler;

@property (nonatomic, copy) CommunitySearchNoResultsCompletionHandler       communitySearchNoResultsCompletionHandler;

/*
 * 清空搜索数据源
 */
- (void)clearOldSearchResultsInfo;
@end
