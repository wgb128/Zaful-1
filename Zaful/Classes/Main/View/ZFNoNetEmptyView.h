//
//  ZFNoNetEmptyView.h
//  Zaful
//
//  Created by liuxi on 2017/9/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NoNetEmptyReRequestCompletionHandler)(void);

@interface ZFNoNetEmptyView : UIView
@property (nonatomic, copy) NoNetEmptyReRequestCompletionHandler          noNetEmptyReRequestCompletionHandler;
@end
