//
//  FastPayPalView
//  Zaful
//
//  Created by DBP on 17/3/18.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface FastPamentView : UIView
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) void (^paymentCallBackBlock)(NSString *token,NSString *payid);
- (void)show;
@end
