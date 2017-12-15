//
//  ZFCommunityExploreBannersCell.h
//  Zaful
//
//  Created by liuxi on 2017/7/27.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityExploreModel;
@class BannerModel;
typedef void(^JumpToBannerCompletionHandler)(BannerModel *model);

@interface ZFCommunityExploreBannersCell : UITableViewCell
@property (nonatomic, strong) ZFCommunityExploreModel       *model;

@property (nonatomic, copy) JumpToBannerCompletionHandler   jumpToBannerCompletionHandler;
@end

