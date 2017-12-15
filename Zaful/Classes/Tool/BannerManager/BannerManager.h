//
//  BannerManager.h
//  Zaful
//
//  Created by TsangFa on 16/10/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BannerModel;

@interface BannerManager : NSObject

+ (void)doBannerActionTarget:(id)target withBannerModel:(BannerModel *)bannerModel;

@end
