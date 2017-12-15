//
//  ZFCartUnavailableClearAllTipsView.h
//  Zaful
//
//  Created by liuxi on 2017/9/21.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartUnavailableClearAllConfirmCompletionHandler)(BOOL isConfirm);

@interface ZFCartUnavailableClearAllTipsView : UIView

@property (nonatomic, copy) CartUnavailableClearAllConfirmCompletionHandler cartUnavailableClearAllConfirmCompletionHandler;

- (void)tipsShowAnimation;

@end
