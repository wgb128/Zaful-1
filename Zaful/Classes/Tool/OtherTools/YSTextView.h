//
//  YSTextView.h
//  post
//
//  Created by TsangFa on 16/7/5.
//  Copyright © 2016年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy  ) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor  *placeholderColor;
/** 占位文字大小 */
@property (nonatomic, strong) UIFont   *placeholderFont;
/** 占位文字位置 */
@property (nonatomic,assign ) CGPoint  placeholderPoint;

@end
