//
//  CommunityDetailGoodsView.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/12.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsInfosModel;

@interface CommunityDetailGoodsView : UIView

@property (nonatomic, strong) GoodsInfosModel *infoModel;

@property (nonatomic, weak) UIViewController *controller;

@end
