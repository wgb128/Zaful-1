//
//  UIView+ZFEmptyView.m
//  WZHLibrary
//
//  Created by QianHan on 2017/5/12.
//  Copyright © 2017年 karl.luo. All rights reserved.
//

#import "UIView+ZFBlankView.h"
#import <objc/runtime.h>

NSUInteger const kSubViewTag = UINT_MAX - 100;
CGFloat const vspace         = 15.0f;           // 纵向间距
CGFloat const hspace         = 10.0f;           // 横向间距
CGFloat const kOffsety       = 100.0;
NSString const *kNetBlankViewIsNext         = @"kNetBlankViewIsNext";      // 是否不是由于网络问题第一次造成的空白页
NSString const *kRequestBlankViewIsNext     = @"kRequestBlankViewIsNext";  // 是否不是由于code != 0第一次造成的空白页
NSString const *ZFBlankViewBackgroudViewKey = @"kBackgroudViewKey";

static NSString *const kbuttonAction = @"buttonAction";

@interface UIView ()

@end

@implementation UIView (ZFBlankView)

- (void)zf_showBlankViewWithImage:(UIImage *)image
              description:(NSString *)description
             buttonTitles:(NSArray *)titles
                   action:(void (^)(NSInteger index))action {
    
    [self zf_dismissBlankView];
    if (image == nil
        && description == nil
        && [titles count] == 0) {
        
        return;
    }
    
    UIView *backgroundView = [self zf_backgroundView];
    [self addSubview:backgroundView];
    [self bringSubviewToFront:backgroundView];
    
    CGFloat offsetY = kOffsety;
    
    // 空图标
    CGFloat imageHeight = [self addEmptyImageViewWithOffsetY:offsetY image:image];
    offsetY             = image == nil ? offsetY : offsetY + imageHeight + vspace;
    
    // 内容描述
    CGFloat descriptionHeight = [self addDescriptionLabelWithOffsetY:offsetY
                                                         description:description];
    offsetY = [description length] <= 0 ? offsetY : offsetY + descriptionHeight + vspace;
    
    CGFloat dValue = 0.0;
    
    if (titles.count == 0) {
        
        dValue = (backgroundView.frame.size.height - offsetY) / 2 - kOffsety;
        [self reframeWithDValue:dValue];
        return;
    }
    
    // 操作按钮
    CGFloat maxWidth     = 0.0;
    CGFloat buttonHeight = 0.0;
    for (NSInteger i = 0; i < titles.count; i++) {
        
        CGSize buttonSize = [self addOperatorButtonWithOffsetY:offsetY
                                                         title:titles[i]
                                                           tag:kSubViewTag + i];
        maxWidth = maxWidth > buttonSize.width ? maxWidth : buttonSize.width;
        buttonHeight = buttonSize.height;
    }
    
    offsetY = offsetY + buttonHeight;
    dValue  = (backgroundView.frame.size.height - offsetY) * 2 / 5 - kOffsety;
    [self reframeOperateButtonWithWidth:maxWidth count:titles.count];
    [self reframeWithDValue:dValue];
    
    if (action) {
        [self zf_setButtonAction:action];
    }
}

- (void)zf_dismissBlankView {
    
    UIView *backgroundView = [self zf_backgroundView];
    [backgroundView removeFromSuperview];
    for (UIView *subView in backgroundView.subviews) {
        
        [subView removeFromSuperview];
    }
}

- (void)zf_showNetworkBlankViewWithAction:(void (^)(NSInteger))action {
    
    NSString *blankDescription;
    NSString *actionTitle;
    BOOL isNextTip = (BOOL)objc_getAssociatedObject(self, (__bridge const void *)kNetBlankViewIsNext);
    if (!isNextTip) {
        blankDescription = ZFLocalizedString(@"Global_NO_NET_404", nil);
        actionTitle      = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel", nil);
        isNextTip = YES;
        objc_setAssociatedObject(self, (__bridge const void *)kNetBlankViewIsNext, [NSNumber numberWithBool:isNextTip], OBJC_ASSOCIATION_ASSIGN);
    } else {
        blankDescription = ZFLocalizedString(@"Global_NO_NET_404", nil);
        actionTitle      = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel", nil);
    }
    
    [self zf_showBlankViewWithImage:[UIImage imageNamed:@"network_404"]
                         description:blankDescription
                        buttonTitles:@[actionTitle]
                              action:action];
}

- (void)zf_showRequestBlankViewWithAction:(void (^)(NSInteger))action {
    
    NSString *blankDescription;
    NSString *actionTitle;

    BOOL isNextTip = (BOOL)objc_getAssociatedObject(self, (__bridge const void *)kRequestBlankViewIsNext);
    if (!isNextTip) {
        blankDescription = ZFLocalizedString(@"EmptyCustomViewManager_titleLabel", nil);
        actionTitle      = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel", nil);
        isNextTip = YES;
        objc_setAssociatedObject(self, (__bridge const void *)kRequestBlankViewIsNext, [NSNumber numberWithBool:isNextTip], OBJC_ASSOCIATION_ASSIGN);
    } else {
        blankDescription = ZFLocalizedString(@"EmptyCustomViewManager_titleLabel", nil);
        actionTitle      = ZFLocalizedString(@"Base_VC_ShowAgain_TitleLabel", nil);
    }
    [self zf_showBlankViewWithImage:[UIImage imageNamed:@"network_404"]
                         description:blankDescription
                        buttonTitles:@[actionTitle]
                              action:action];
}

- (void)operatorAction:(UIButton *)button {
    
    void (^buttonAction)(NSInteger index) = [self zf_buttonAction];
    if (buttonAction) {
        
        [self zf_dismissBlankView];
        NSInteger index = button.tag - kSubViewTag;
        buttonAction(index);
    }
}

- (UIView *)zf_backgroundView {
    
    UIView *backgroundView = (UIView *)objc_getAssociatedObject(self,
                                                                (__bridge const void *)ZFBlankViewBackgroudViewKey);
    
    if (!backgroundView) {
        
        backgroundView                  = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor  = ZFCOLOR_WHITE;
        objc_setAssociatedObject(self,
                                 (__bridge const void *)ZFBlankViewBackgroudViewKey,
                                 backgroundView,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return backgroundView;
}

// 图片
- (CGFloat)addEmptyImageViewWithOffsetY:(CGFloat)offsetY
                                  image:(UIImage *)image {
    
    UIView *backgroundView = [self zf_backgroundView];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame        = CGRectMake((backgroundView.frame.size.width - image.size.width) / 2,
                                        offsetY,
                                        image.size.width,
                                        image.size.height);
    [backgroundView addSubview:imageView];
    
    return imageView.frame.size.height;
}

// 描述内容
- (CGFloat)addDescriptionLabelWithOffsetY:(CGFloat)offsetY
                              description:(NSString *)description {
    
    UIView *backgroundView = [self zf_backgroundView];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize descriptSize = [description boundingRectWithSize:CGSizeMake((backgroundView.frame.size.width - hspace) / 2,
                                                                       MAXFLOAT)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: font}
                                                    context:nil].size;
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.frame    = CGRectMake(hspace,
                                           offsetY,
                                           backgroundView.frame.size.width - hspace * 2 ,
                                           descriptSize.height);
    descriptionLabel.font          = font;
    descriptionLabel.textColor     = ZFCOLOR(153, 153, 153, 1.0f);
    descriptionLabel.text          = description;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.numberOfLines = 0;
    [backgroundView addSubview:descriptionLabel];
    
    return descriptionLabel.frame.size.height;
}

// 添加操作
- (CGSize)addOperatorButtonWithOffsetY:(CGFloat)offsetY
                               title:(NSString *)title
                                    tag:(NSInteger)tag {
    
    UIView *backgroundView = [self zf_backgroundView];
    UIFont *font       = [UIFont systemFontOfSize:14.0];
    UIColor *tintColor = [UIColor whiteColor];   // 从这里修改颜色
    CGSize titleSize   = [title sizeWithAttributes:@{NSFontAttributeName: font}];
    
    UIButton *button   = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame       = CGRectMake(0.0, offsetY, titleSize.width + hspace * 4.0f, 45.0f);
    button.tag         = tag;
    [button setTitleColor:tintColor forState:UIControlStateNormal];
    button.titleLabel.font     = font;
    button.backgroundColor     = ZFCOLOR_BLACK;
    button.layer.cornerRadius  = 4.0f;
    button.layer.masksToBounds = YES;
    [button addTarget:self
               action:@selector(operatorAction:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [backgroundView addSubview:button];
    
    return button.frame.size;
}

- (void)reframeOperateButtonWithWidth:(CGFloat)width count:(NSInteger)count {
    
    CGFloat totalWidth = 0.0;
    CGFloat offsetX    = 0.0;
    if (count > 1) {
        
        totalWidth = width * count + (count - 1) * hspace;
    } else {
        
        totalWidth = width * count;
    }
    
    UIView *backgroundView = [self zf_backgroundView];
    offsetX = (backgroundView.frame.size.width - totalWidth) / 2;
    for (UIView *subView in backgroundView.subviews) {
        
        if (subView.tag >= kSubViewTag) {
            
            NSInteger buttonIndex = subView.tag - kSubViewTag;
            CGFloat x             = offsetX + buttonIndex * (width + hspace);
            subView.frame         = CGRectMake(x,
                                               subView.frame.origin.y,
                                               width,
                                               subView.frame.size.height);
        }
    }
}

- (void)reframeWithDValue:(CGFloat)dValue {
    
    UIView *backgroundView = [self zf_backgroundView];
    for (UIView *subView in backgroundView.subviews) {
        subView.frame = CGRectMake(subView.frame.origin.x,
                                   subView.frame.origin.y + dValue,
                                   subView.frame.size.width,
                                   subView.frame.size.height);
    }
}

- (void (^)(NSInteger index))zf_buttonAction {
    
    void (^buttonAction)(NSInteger index) = (void (^)(NSInteger index))objc_getAssociatedObject(self,
                                                                                                (__bridge const void *)kbuttonAction);
    if (!buttonAction) {
        
        return nil;
    }
    
    return buttonAction;
}

- (void)zf_setButtonAction:(void (^)(NSInteger index))action {
    
    if (action) {
        
        objc_setAssociatedObject(self,
                                 (__bridge const void *)kbuttonAction,
                                 action,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

@end
