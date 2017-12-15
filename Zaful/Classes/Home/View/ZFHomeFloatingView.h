//
//  ZFHomeFloatingView.h
//  Zaful
//
//  Created by QianHan on 2017/10/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHomeFloatingViewShowNotice  @"kHomeFloatingViewShowNotice"

@class BannerModel;
@interface ZFHomeFloatingView : NSObject

@property (nonatomic, copy) void(^tapActionHandle)();
- (instancetype)initWithModel:(BannerModel *)floatModel;
- (void)show;

@end
