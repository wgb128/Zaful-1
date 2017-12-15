//
//  CartInfoTotalSubView.h
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartInfoTotalSubView : UIView
@property (nonatomic, strong) UILabel *leftTitleLabel;
@property (nonatomic, copy) NSString *rightValue;
@property (nonatomic, assign) BOOL defaultColor;
- (instancetype)initWithRightTitle:(NSString *)rightTitle defaultColor:(BOOL)defaultColor;
@end
