//
//  RewardPickerView.h
//  Yoshop
//
//  Created by Stone on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardPickerView;
@protocol RewardPickerViewDelegate <NSObject>

-(void)rewardPickerViewFinishPick:(RewardPickerView *)pickerView andSelectedIndex:(NSInteger )index;//选择完成

@end

@interface RewardPickerView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic,weak) id <RewardPickerViewDelegate> delegate;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger items;
@property (nonatomic, strong) UIToolbar *toolBar;

@end
