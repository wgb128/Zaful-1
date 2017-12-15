//
//  ZFCommunityHotMoreVideoBannerCell.h
//  Zaful
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BannerModel;

typedef void(^MoreHotVideoBannerJumpCompletionHandler)(BannerModel *bannerModel);

@interface ZFCommunityHotMoreVideoBannerCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray<BannerModel *>  *bannerArray;

@property (nonatomic, copy) MoreHotVideoBannerJumpCompletionHandler     moreHotVideoBannerJumpCompletionHandler;

@end
