//
//  CategorySelectView.h
//  ListPageViewController
//
//  Created by TsangFa on 8/6/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCompletionHandler)(NSInteger tag, SelectViewDataType type);

typedef void(^SelectSubCellHandler)(CategoryNewModel *model, SelectViewDataType type);

typedef void(^MaskTapCompletionHandler)(NSInteger index);

typedef void(^SelectAnimationStopCompletionHandler)(void);

@interface CategorySelectView : UIView

@property (nonatomic, strong) NSArray<NSString *>   *sortArray;

@property (nonatomic, strong) NSArray   *categoryArray;

@property (nonatomic, copy) NSString   *currentSortType;

@property (nonatomic, copy) NSString   *currentCategory;

@property (nonatomic, assign) BOOL   isPriceList;

@property (nonatomic, assign) SelectViewDataType   dataType;

@property (nonatomic, copy) SelectCompletionHandler   selectCompletionHandler;

@property (nonatomic, copy) SelectSubCellHandler      selectSubCellHandler;

@property (nonatomic, copy) MaskTapCompletionHandler  maskTapCompletionHandler;

@property (nonatomic, copy) SelectAnimationStopCompletionHandler selectAnimationStopCompletionHandler;

- (void)showCompletion:(void (^)())completion;

- (void)dismiss;
@end
