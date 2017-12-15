//
//  ZFBannerContentView.h
//  ZFBannerView
//
//  Created by TsangFa on 22/11/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZFBannerContentView;

typedef void(^ZFBannerContentViewBlock)(ZFBannerContentView * sender);

@interface ZFBannerContentView : UIView

@property (nonatomic, copy) ZFBannerContentViewBlock   callBack;

- (void)setUserInteraction:(BOOL)enable;

- (void)setContentIMGWithStr:(NSString *)str;

- (void)setOffsetWithFactor:(float)value; //偏移的百分比

@end

NS_ASSUME_NONNULL_END
