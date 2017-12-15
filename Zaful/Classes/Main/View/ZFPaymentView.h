//
//  ZFPaymentView.h
//  Yoshop
//
//  Created by zhaowei on 16/6/23.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef void(^ZFPaymentViewCallBackBlock)(PaymentStatus);

@interface ZFPaymentView : UIView

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) ZFPaymentViewCallBackBlock block;

- (void)show;

@end
