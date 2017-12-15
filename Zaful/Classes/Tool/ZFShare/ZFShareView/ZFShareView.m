//
//  ZFShareView.m
//  HyPopMenuView
//
//  Created by TsangFa on 5/8/17.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import "ZFShareView.h"
#import "ZFShareButton.h"
#import "UIColor+ImageGetColor.h"
#import <pop/POP.h>

#define kW [UIScreen mainScreen].bounds.size.width
#define kH [UIScreen mainScreen].bounds.size.height

static CGFloat KCloseButtonWidth = 16.0f;
static CGFloat KBottomViewHeight = 189.0f;
static CGFloat kImageWidth       = 48.0f;
static CGFloat kTitleHeight      = 20.0f;
static CGFloat kButtonHeight     = 93.0f;
static CGFloat kImageViewY       = 11.5f;
static CGFloat kTitleY           = 63.5f;

@interface ZFShareView ()
@property (nonatomic, strong) UIVisualEffectView   *blurView;    // 模糊视图
@property (nonatomic, strong) UIView               *bottomView;  // 底部视图
@property (nonatomic, strong) CALayer              *line;
@property (nonatomic, strong) UIButton             *closeButton;
@property (nonatomic, assign) BOOL                 isOpen;
@end

@implementation ZFShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:[UIScreen mainScreen].bounds];
        self.backgroundColor = [UIColor colorWithRed:(221)/255.0 green:(221)/255.0 blue:221/255.0 alpha:0.8];
        _popMenuSpeed = 8.0f;
        
        ZFShareButton *facebookButton = [ZFShareButton buttonWithImage:@"Facebook" Title:@"FaceBook" TransitionType:ZFShareButtonTransitionTypeCircle];
        ZFShareButton *messengerButton = [ZFShareButton buttonWithImage:@"Messenger" Title:@"Messenger" TransitionType:ZFShareButtonTransitionTypeCircle];
        ZFShareButton *copyButton = [ZFShareButton buttonWithImage:@"Link" Title:@"Copy Link" TransitionType:ZFShareButtonTransitionTypeWave];
        
        _dataSource = @[facebookButton,messengerButton,copyButton];
    }
    return self;
}

- (void)open {
    self.hidden = NO;
    [self initSubViews];
    [self showBackgroundAnimation];
}

- (void)initSubViews {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window)
        window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    
    _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _blurView.frame = self.bounds;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [_blurView addGestureRecognizer:tap];
    [self addSubview:_blurView];
    
    if (_topView) {
        [_blurView.contentView addSubview:_topView];
    }
    
    [[UIButton appearance] setExclusiveTouch:true];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kH - KBottomViewHeight, kW, KBottomViewHeight)];
    _bottomView.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(255)/255.0 blue:(255)/255.0 alpha:1.0];
    [_blurView.contentView addSubview:_bottomView];
    
    _line = [CALayer layer];
    _line.frame = CGRectMake(0, kH - 48, kW, 0.5);
    _line.backgroundColor = [UIColor colorWithRed:(221)/255.0 green:(221)/255.0 blue:(221)/255.0 alpha:1.0].CGColor;
    [_blurView.contentView.layer addSublayer:_line];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.adjustsImageWhenHighlighted = NO;
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [_closeButton addTarget:self  action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.frame = CGRectMake((kW - KCloseButtonWidth)/2, kH - KCloseButtonWidth * 2, KCloseButtonWidth, KCloseButtonWidth);
    [_blurView.contentView addSubview:_closeButton];
}

- (void)showBackgroundAnimation {
    _topView.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        _blurView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _topView.alpha = 1.0f;
        _closeButton.transform = CGAffineTransformMakeRotation((M_PI / 2));
    }];
    
    [self showSpringAnimation];
}

- (void)showSpringAnimation {
    [_dataSource enumerateObjectsUsingBlock:^(ZFShareButton *button, NSUInteger idx, BOOL* _Nonnull stop) {
        [button removeFromSuperview];
        button.alpha = 0.0f;
        button.imageRect = [self adjustImageRect];
        button.titleRect = [self adjustTitleRect];
        [_blurView.contentView addSubview:button];
        
        double dy = idx * 0.035f;
        CFTimeInterval delay = dy + CACurrentMediaTime();
        
        CGRect toRect = [self getFrameAtIndex:idx];
        CGRect fromRect = CGRectMake(CGRectGetMinX(toRect),
                                     CGRectGetMinY(toRect) + (kH - CGRectGetMinY(toRect)),
                                     toRect.size.width,
                                     toRect.size.height);
        
        [self startViscousAnimationFormValue:fromRect
                                     ToValue:toRect
                                       Delay:delay
                                      Object:button
                                 HideDisplay:false];
        
        [button addTarget:self action:@selector(selectedItemAnimation:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)selectedItemAnimation:(ZFShareButton*)sender {
    self.closeButton.alpha = 0.1f;
    self.closeButton.transform = CGAffineTransformMakeRotation(0);
    __weak ZFShareView* weakView = self;
    for (ZFShareButton *button in _dataSource) {
        if (sender != button) {
            [button cancelAnimation];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [sender selectdAnimation];
    });
    NSUInteger idx = [_dataSource indexOfObject:sender];
    sender.completionAnimation = ^(ZFShareButton *button){
        if ([weakView.delegate respondsToSelector:@selector(zfShsreView:didSelectItemAtIndex:)]) {
            [weakView.delegate zfShsreView:nil didSelectItemAtIndex:idx];
        }
        [weakView close];
    };
}

- (void)dismiss {
    [self disappearPopMenuViewAnimate];
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.transform = CGAffineTransformMakeRotation(0);
        [_closeButton setAlpha:0.1f];
    }];
    double d = (_dataSource.count * 0.04) + 0.3;
    [UIView animateKeyframesWithDuration:0.4 delay:d options:0 animations:^{
        _topView.alpha = 0;
        _blurView.effect = nil;
    }completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.hidden = YES;
                [_blurView removeFromSuperview];
                _isOpen = false;
                [self removeFromSuperview];
            }];
        }
    }];
}

- (void)disappearPopMenuViewAnimate {
    [_dataSource enumerateObjectsUsingBlock:^(ZFShareButton *button, NSUInteger idx, BOOL* _Nonnull stop) {
        double d = _dataSource.count * 0.04;
        double dy = d - idx * 0.04;
        CFTimeInterval delay = dy + CACurrentMediaTime();
        CGRect fromRect = [self getFrameAtIndex:idx];
        CGRect toRect = CGRectMake(CGRectGetMinX(fromRect),
                                   CGRectGetMinY(fromRect) + (kH - CGRectGetMinY(fromRect)),
                                   fromRect.size.width,
                                   fromRect.size.height);
        
        [self startViscousAnimationFormValue:fromRect
                                     ToValue:toRect
                                       Delay:delay
                                      Object:button
                                 HideDisplay:true];
    }];
}

- (void)close {
    [UIView animateWithDuration:0.35 delay:0.0 options:0 animations:^{
        _blurView.effect = nil;
        _topView.alpha = 0;
        _bottomView.backgroundColor = [UIColor clearColor];
        _closeButton.transform = CGAffineTransformMakeRotation(0);
        [_closeButton setAlpha:0.1f];
    } completion:^(BOOL finished) {
        [_dataSource enumerateObjectsUsingBlock:^(ZFShareButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
            button.alpha = 0.0;
            [button.layer removeAllAnimations];
            [button setBackgroundColor:[UIColor clearColor]];
            button.layer.cornerRadius = 0;
        }];
        [_blurView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)startViscousAnimationFormValue:(CGRect)fromValue
                               ToValue:(CGRect)toValue
                                 Delay:(CFTimeInterval)delay
                                Object:(UIView*)obj
                           HideDisplay:(BOOL)hideDisplay {
    CGFloat toV, fromV;
    CGFloat springBounciness = 9.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(0.7);
        basicAnimationScale.fromValue = @(1);
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
    }
    else {
        POPSpringAnimation* basicAnimationCenter = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.springSpeed = _popMenuSpeed;
        basicAnimationCenter.springBounciness = springBounciness;
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(1);
        basicAnimationScale.fromValue = @(0.7);
        basicAnimationScale.duration = 0.3f;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [obj.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.1f;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        
        [obj pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [obj pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
    }
}

- (void)setDataSource:(NSArray*)dataSource {
    _dataSource = dataSource;
}

- (CGRect)getFrameAtIndex:(NSUInteger)index {
    NSInteger column = 3;
    CGFloat buttonViewWidth  = CGRectGetWidth(self.frame) / column - 32;
    CGFloat buttonViewHeight = kButtonHeight;
    CGFloat margin = (self.frame.size.width - column * buttonViewWidth) / (column + 1);
    NSInteger colnumIndex = index % column;
    CGFloat buttonViewX = (colnumIndex + 1) * margin + colnumIndex * buttonViewWidth;
    CGFloat buttonViewY = kH - 165;
    CGRect rect = CGRectMake(buttonViewX, buttonViewY, buttonViewWidth, buttonViewHeight);
    return rect;
}

- (CGRect)adjustImageRect {
    CGFloat imageWidth = kImageWidth;
    CGFloat imageX = (kButtonHeight - imageWidth) / 2;
    CGFloat imageHeight = imageWidth;
    CGFloat imageY = kImageViewY;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)adjustTitleRect {
    CGFloat titleX = 0;
    CGFloat titleHeight = kTitleHeight;
    CGFloat titleY =  kTitleY;
    CGFloat titleWidth = kButtonHeight;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

- (BOOL)isOpenMenu {
    return _isOpen;
}

- (void)setTopView:(UIView*)topView {
    if (_topView) {
        [_topView removeFromSuperview];
    }
    _topView = topView;
}

@end
