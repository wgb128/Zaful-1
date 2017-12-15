//
//  CommunityHeaderView.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopularModel;

@interface CommunityHeaderView : UIView

@property (nonatomic, strong) PopularModel *model;

@property (nonatomic, weak) UIViewController *controller;

@end
