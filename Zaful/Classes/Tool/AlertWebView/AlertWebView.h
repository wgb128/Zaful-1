//
//  AlertWebView.h
//  Zaful
//
//  Created by DBP on 17/3/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertWebView : UIView
- (instancetype)initWithUrlStr:(NSString *)urlStr;
- (void)show;
- (void)dismiss;
@end
