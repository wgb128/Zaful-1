//
//  ZFSizeSelectSizeHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/11/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

typedef void(^SizeSelectGuideJumpCompletionHandler)(void);

@interface ZFSizeSelectSizeHeaderView : UICollectionReusableView

@property (nonatomic, strong) GoodsDetailModel                          *model;

@property (nonatomic, copy) SizeSelectGuideJumpCompletionHandler        sizeSelectGuideJumpCompletionHandler;
@end
