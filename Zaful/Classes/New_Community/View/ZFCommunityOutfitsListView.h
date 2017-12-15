//
//  ZFCommunityOutfitsListView.h
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFCommunityOutfitsListView : UICollectionViewCell
@property (nonatomic, copy) NSString                *userId;
@property (nonatomic, weak) UIViewController        *controller;
@end
