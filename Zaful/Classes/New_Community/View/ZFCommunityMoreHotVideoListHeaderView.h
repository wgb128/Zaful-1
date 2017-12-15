//
//  ZFCommunityMoreHotVideoListHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerModel;

typedef void(^MoreHotVideoBannerJumpCompletionHandler)(BannerModel *bannerModel);

@interface ZFCommunityMoreHotVideoListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSMutableArray<BannerModel *>  *bannerArray;

@property (nonatomic, copy) MoreHotVideoBannerJumpCompletionHandler     moreHotVideoBannerJumpCompletionHandler;


@end
