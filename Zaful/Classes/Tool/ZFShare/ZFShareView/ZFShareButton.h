//
//  ZFShareButton.h
//  Zaful
//
//  Created by Tsang_Fa on 2017/8/4.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZFShareButtonTransitionTypeCircle, // 格瓦拉转场效果
    ZFShareButtonTransitionTypeWave    // 波纹效果
} ZFShareButtonTransitionType;

@class ZFShareButton;
typedef void (^CompletionAnimation)(ZFShareButton *_Nonnull);

@interface ZFShareButton : UIButton<CAAnimationDelegate>

@property (nonatomic, nonnull, copy) CompletionAnimation  completionAnimation;

@property (nonatomic, assign) ZFShareButtonTransitionType transitionType;

@property (nonatomic, assign) CGRect                      titleRect;

@property (nonatomic, assign) CGRect                      imageRect;

+ (instancetype __nonnull)buttonWithImage:(NSString *__nonnull)image
                                    Title:(NSString *__nonnull)title
                           TransitionType:(ZFShareButtonTransitionType)type;

- (void)selectdAnimation;
- (void)cancelAnimation;



@end
