//
//  RewardPickerView.h
//  DressOnline
//
//  Created by 7FD75 on 16/3/17.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserCouponModel.h"

@class MyCouponPickerView;

@interface MyCouponPickerView : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) NSInteger items;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) CustomTextField *codeTextField;

@property (nonatomic,copy) void (^selectedFinishBlock)(NSString *codeString);

@end
