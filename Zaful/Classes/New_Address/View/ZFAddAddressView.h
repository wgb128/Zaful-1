//
//  ZFAddAddressView.h
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddAddressCompletionHandler)(void);

@interface ZFAddAddressView : UIView
@property (nonatomic, copy) AddAddressCompletionHandler         addAddressCompletionHandler;
@end
