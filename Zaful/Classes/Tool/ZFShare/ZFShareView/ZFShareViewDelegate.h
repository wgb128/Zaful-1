//
//  ZFShareViewDelegate.h
//  HyPopMenuView
//
//  Created by TsangFa on 5/8/17.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZFShareView, ZFShareButton;

@protocol ZFShareViewDelegate <NSObject>

- (void)zfShsreView:(ZFShareView*)shareView didSelectItemAtIndex:(NSUInteger)index;

@end
