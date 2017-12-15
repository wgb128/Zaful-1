//
//  DropDownMenu.h
//  ListPageViewController
//
//  Created by TsangFa on 2/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseCompletionHandler)(NSInteger tapIndex,BOOL isSelect);

@interface CategoryDropDownMenu : UIView

@property (nonatomic, strong) NSArray<NSString *>     *titles;

@property (nonatomic, copy) ChooseCompletionHandler   chooseCompletionHandler;

@property (nonatomic, assign) BOOL                    isDropAnimation;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (void)animateIndicatorWithIndex:(NSInteger)index;

/**
 * 重置箭头
 *
 */
- (void)restoreIndicator:(NSInteger)index ;

@end
