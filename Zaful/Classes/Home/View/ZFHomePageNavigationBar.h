//
//  ZFHomePageNavigationBar.h
//  Zaful
//
//  Created by QianHan on 2017/10/11.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFHomePageNavigationBar : UIView

@property (nonatomic, copy) void(^searchActionHandle)();
@property (nonatomic, copy) void(^bagActionHandle)();
@property (nonatomic, copy) void(^changeLocalHostHandle)();
- (void)setBagValues;
- (void)subViewWithAlpa:(CGFloat)alpha;

@end
