//
//  AccountHeaderView.h
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountViewController.h"

@class AccountHeaderView;

@protocol AccountHeaderViewDelegate <NSObject>

- (void)accountHeaderViewEditBtnClick:(AccountHeaderView *)view;

@end

@interface AccountHeaderView : UIView

@property (nonatomic, weak) id <AccountHeaderViewDelegate> delegate;

@property (nonatomic, weak) AccountViewController *controller;

- (void)refreshAcccountHeaderData;

@end
