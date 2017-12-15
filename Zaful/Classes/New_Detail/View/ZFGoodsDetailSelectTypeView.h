//
//  ZFGoodsDetailSelectTypeView.h
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

typedef void(^GoodsDetailSelectTypeCloseCompletionHandler)(void);
typedef void(^GoodsDetailSelectNumberChangeCompletionHandler)(NSInteger number);
typedef void(^GoodsDetailSelectHideAnimationCompletionHandler)(void);
typedef void(^GoodsDetailSelectTypeCompletionHandler)(NSString *goodsId);
typedef void(^GoodsDetailSelectSizeGuideCompletionHandler)(void);

@interface ZFGoodsDetailSelectTypeView : UIView

@property (nonatomic, strong) GoodsDetailModel          *model;
@property (nonatomic, assign) NSInteger                 chooseNumebr;

@property (nonatomic, copy) GoodsDetailSelectTypeCloseCompletionHandler     goodsDetailSelectTypeCloseCompletionHandler;
@property (nonatomic, copy) GoodsDetailSelectNumberChangeCompletionHandler  goodsDetailSelectNumberChangeCompletionHandler;
@property (nonatomic, copy) GoodsDetailSelectHideAnimationCompletionHandler goodsDetailSelectHideAnimationCompletionHandler;
@property (nonatomic, copy) GoodsDetailSelectTypeCompletionHandler          goodsDetailSelectTypeCompletionHandler;
@property (nonatomic, copy) GoodsDetailSelectSizeGuideCompletionHandler     goodsDetailSelectSizeGuideCompletionHandler;

- (void)openSelectTypeView;

- (void)hideSelectTypeView;

@end
