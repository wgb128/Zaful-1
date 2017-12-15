//
//  OrderDetailPaymentView.h
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPaymentView : UIView
@property (nonatomic, copy) void(^orderDetailPayStatueBlock)(NSInteger tag);
- (instancetype)initWithPaymentStatus:(BOOL)hidden;

- (void)changeName:(NSString *)states;
@end
