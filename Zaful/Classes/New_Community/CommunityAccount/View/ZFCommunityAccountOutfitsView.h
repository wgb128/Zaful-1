//
//  ZFCommunityAccountOutfitsView.h
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommunityAccountOutfitsDetailCompletionHandler)(NSString *userId, NSString *reviewsId, NSString *title);

@interface ZFCommunityAccountOutfitsView : UICollectionViewCell
@property (nonatomic, copy) NSString            *userId;
@property (nonatomic, weak) UIViewController    *controller;
@property (nonatomic, copy) CommunityAccountOutfitsDetailCompletionHandler  communityAccountOutfitsDetailCompletionHandler;
@end
