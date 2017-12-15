//
//  ZFTrackingInfoViewController.h
//  Zaful
//
//  Created by Tsang_Fa on 2017/9/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "WMPageController.h"

@class ZFTrackingPackageModel;

@interface ZFTrackingInfoViewController : WMPageController

@property (nonatomic, strong) NSArray<ZFTrackingPackageModel *>       *packages;


@end
