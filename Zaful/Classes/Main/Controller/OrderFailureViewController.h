//
//  OrderFailureViewController.h
//  Zaful
//
//  Created by DBP on 16/12/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

typedef void(^OrderFailureBlock)();

@interface OrderFailureViewController : ZFBaseViewController

@property (nonatomic, copy) OrderFailureBlock orderFailureBlock;

@end

