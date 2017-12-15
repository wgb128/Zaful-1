//
//  OrderDetailTotalView.h
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailTotalView : UIView
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) NSString *rightValue;
@property (nonatomic, assign) BOOL DefaultColor;
- (instancetype)initWithTitle:(NSString *)leftTitle andDefaultColor:(BOOL)DefaultColor;

@end
