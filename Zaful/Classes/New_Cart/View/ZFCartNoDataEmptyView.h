//
//  ZFCartNoDataEmptyView.h
//  Zaful
//
//  Created by liuxi on 2017/9/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartNoDataContinueShopCompletionHandler)(void);

@interface ZFCartNoDataEmptyView : UIView
@property (nonatomic, copy) CartNoDataContinueShopCompletionHandler     cartNoDataContinueShopCompletionHandler;
@end
