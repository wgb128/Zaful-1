//
//  GoodsPageViewController.h
//  Zaful
//
//  Created by TsangFa on 16/11/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "WMPageController.h"

typedef void(^DoneBlock)(NSMutableArray *selectArray);

@interface GoodsPageViewController : WMPageController

@property (nonatomic,copy) DoneBlock doneBlock;

@end
