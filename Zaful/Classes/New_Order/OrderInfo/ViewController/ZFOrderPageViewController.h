//
//  ZFOrderPageViewController.h
//  Zaful
//
//  Created by TsangFa on 13/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "WMPageController.h"
@class  ZFOrderCheckInfoModel;

@interface ZFOrderPageViewController : WMPageController

@property (nonatomic, strong) NSArray<ZFOrderCheckInfoModel *>       *pages;

@end
