//
//  ZFStartLoadingViewController.h
//  Zaful
//
//  Created by liuxi on 2017/11/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

typedef void(^StartLoadingSkipCompletionHandler)(void);
typedef void(^StartLoadingJumpBannerCompletionHandler)(void);

@interface ZFStartLoadingViewController : ZFBaseViewController
@property (nonatomic, copy) NSString        *loadUrl;
@property (nonatomic, copy) StartLoadingJumpBannerCompletionHandler     startLoadingJumpBannerCompletionHandler;
@property (nonatomic, copy) StartLoadingSkipCompletionHandler           startLoadingSkipCompletionHandler;
@end
