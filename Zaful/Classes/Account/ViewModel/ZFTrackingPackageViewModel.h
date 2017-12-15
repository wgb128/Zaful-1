//
//  ZFTrackingPackageViewModel.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFTrackingPackageModel;

@interface ZFTrackingPackageViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) ZFTrackingPackageModel   *model;

@end
