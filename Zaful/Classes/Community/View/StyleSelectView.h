//
//  StyleSelectView.h
//  Yoshop
//
//  Created by zhaowei on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StyleSelectView;

@protocol StyleSelectViewDelegate <NSObject>

@optional
//当按钮点击时通知代理
- (void)selectView:(StyleSelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

- (void)selectView:(StyleSelectView *)selectView didChangeSelectedView:(NSInteger)to;

@end

@interface StyleSelectView : UIView

/** 用来确定是否显示评论列表的 默认是NO，只显示俩个button, 如果是YES就显示3个button */
@property(nonatomic, assign) BOOL isShowComment;

@property(nonatomic, weak) id <StyleSelectViewDelegate> delegate;

+ (instancetype)selectViewWithisShowComment:(BOOL)isShowComment;

//提供给外部一个可以滑动底部line的方法
- (void)lineToIndex:(NSInteger)index;

@end