//
//  ZFTrackingInfoViewModel.h
//  Zaful
//
//  Created by Tsang_Fa on 2017/9/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZFTrackingPackageModel;

@interface ZFTrackingInfoViewModel : NSObject

- (void)requestTrackingPackageData:(NSString *)orderID completion:(void (^)(NSArray<ZFTrackingPackageModel *> *array))completion failure:(void (^)(id obj))failure;


@end
