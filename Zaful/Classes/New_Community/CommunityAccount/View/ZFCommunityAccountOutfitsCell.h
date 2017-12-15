//
//  ZFCommunityAccountOutfitsCell.h
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFCommunityOutfitsModel;

typedef void(^CommunityAccountOutfitsLikeCompletionHandler)(ZFCommunityOutfitsModel *model);

@interface ZFCommunityAccountOutfitsCell : UICollectionViewCell
@property (nonatomic, strong) ZFCommunityOutfitsModel       *model;

@property (nonatomic, copy) CommunityAccountOutfitsLikeCompletionHandler    communityAccountOutfitsLikeCompletionHandler;
@end
