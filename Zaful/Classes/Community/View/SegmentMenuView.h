//
//  SegmentMenuView.h
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentMenuView;

@protocol SegmentMenuViewDelegate <NSObject>

@optional
//当按钮点击时通知代理
- (void)selectView:(SegmentMenuView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

- (void)selectView:(SegmentMenuView *)selectView didChangeSelectedView:(NSInteger)to;

@end

@interface SegmentMenuView : UIView

@property(nonatomic, weak) id <SegmentMenuViewDelegate> delegate;
- (instancetype)initWithTitles:(NSArray<NSString *> *)titles;

- (instancetype)initWithImage:(NSArray<UIImage *> *)images;
//提供给外部一个可以滑动底部line的方法
- (void)lineToIndex:(NSInteger)index;
@end
