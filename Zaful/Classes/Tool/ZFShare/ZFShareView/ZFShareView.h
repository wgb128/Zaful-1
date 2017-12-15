//
//  ZFShareView.h
//  HyPopMenuView
//
//  Created by TsangFa on 5/8/17.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFShareViewDelegate.h"

typedef NS_ENUM(NSUInteger, ZFShareType) {
    /**
     *  Facebook 分享
     */
    ZFShareTypeFacebook,
    /**
     *  Messenger 分享
     */
    ZFShareTypeMessenger,
    /**
     *  copy link
     */
    ZFShareTypeCopy
};


@class ZFShareButton;

@interface ZFShareView : UIView

@property (nonatomic, strong) NSArray<ZFShareButton*> *dataSource;

@property (nonatomic, assign) id<ZFShareViewDelegate> delegate;

/**
 *  默认为 10.0f         取值范围: 0.0f ~ 20.0f
 *  default is 10.0f    Range: 0 ~ 20
 */
@property (nonatomic, assign) CGFloat popMenuSpeed;

/**
 *  顶部自定义View
 */
@property (nonatomic, strong) UIView   *topView;


- (void)open;

@end
