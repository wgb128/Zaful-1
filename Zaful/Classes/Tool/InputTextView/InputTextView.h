//
//  InputTextView.h
//  Yoshop
//
//  Created by zhaowei on 16/6/28.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MaxTextViewHeight 80 //限制文字输入的高度
@interface InputTextView : UIView
//------ 发送文本 -----//
@property (nonatomic,copy) void (^InputTextViewBlock)(NSString *text);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

@property (nonatomic, strong) UITextView *textView;

@end
