//
//  ZFCategoryCODGuideView.m
//  Zaful
//
//  Created by QianHan on 2017/10/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCategoryCODGuideView.h"

@interface ZFCategoryCODGuideView ()

@property (nonatomic, copy) NSArray *areas;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *okButton;

@end

@implementation ZFCategoryCODGuideView

- (instancetype)initWithGuideAreas:(NSArray<NSValue *> *)areas {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        self.areas = areas;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //背景色
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    
    CGFloat radius = 8.0f;
    for (NSValue *rectValue in self.areas) {
        CGRect clearRect = [rectValue CGRectValue];
        CGContextMoveToPoint(ctx, clearRect.origin.x, clearRect.origin.y);
        CGContextAddArcToPoint(ctx,
                               clearRect.origin.x + clearRect.size.width,
                               clearRect.origin.y,
                               clearRect.origin.x + clearRect.size.width,
                               clearRect.origin.y + clearRect.size.height,
                               radius);
        CGContextAddArcToPoint(ctx,
                               clearRect.origin.x + clearRect.size.width,
                               clearRect.origin.y + clearRect.size.height,
                               clearRect.origin.x,
                               clearRect.origin.y + clearRect.size.height,
                               radius);
        CGContextAddArcToPoint(ctx,
                               clearRect.origin.x,
                               clearRect.origin.y + clearRect.size.height,
                               clearRect.origin.x,
                               clearRect.origin.y,
                               radius);
        CGContextAddArcToPoint(ctx,
                               clearRect.origin.x,
                               clearRect.origin.y,
                               clearRect.origin.x + clearRect.size.width,
                               clearRect.origin.y,
                               radius);
    }
    CGContextFillPath(ctx);
}

- (void)show {
    [self removeFromSuperview];
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.arrowImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.okButton];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)okAction {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter/setter
- (UIImageView *)arrowImageView {
    
    if (!_arrowImageView) {
        UIImage *image = [UIImage imageNamed:@"categroy_sort_guide_arrow"];
        NSValue *lastValue = [self.areas lastObject];
        CGRect lastArea = [lastValue CGRectValue];
        _arrowImageView = [[UIImageView alloc] initWithImage:image];
        _arrowImageView.frame = CGRectMake(20.0f,
                                           lastArea.origin.y + lastArea.size.height + 15.0f,
                                           image.size.width,
                                           image.size.height);
        _arrowImageView.backgroundColor = [UIColor clearColor];
    }
    return _arrowImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.frame = CGRectMake(20.0f,
                                     self.arrowImageView.y + self.arrowImageView.height + 15.0f,
                                     self.width - 40.0f,
                                     20.0f);
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor       = [UIColor whiteColor];
        _tipLabel.font            = [UIFont boldSystemFontOfSize:14.0f];
        _tipLabel.textAlignment   = NSTextAlignmentRight;
        _tipLabel.numberOfLines   = 0;
        _tipLabel.text            = ZFLocalizedString(@"GoodsSortViewController_COD_Guide_Tip", nil);
        [_tipLabel sizeToFit];
    }
    return _tipLabel;
}

- (UIButton *)okButton {
    
    if (!_okButton) {
        
        CGFloat width   = 100.0f;
        CGFloat height  = 44.0f;
        CGFloat offsetX = (self.width - width) / 2;
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _okButton.frame = CGRectMake(offsetX, self.tipLabel.y + self.tipLabel.height + 20.0f, width, height);
        _okButton.layer.borderWidth = 1.5f;
        _okButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _okButton.backgroundColor   = [UIColor clearColor];
        _okButton.titleLabel.font   = [UIFont boldSystemFontOfSize:18.0f];
        [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okButton setTitle:ZFLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okButton;
}


@end
