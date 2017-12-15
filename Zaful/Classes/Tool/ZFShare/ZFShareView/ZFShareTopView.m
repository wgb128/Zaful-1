//
//  ZFShareTopView.m
//  HyPopMenuView
//
//  Created by TsangFa on 7/8/17.
//  Copyright © 2017年 Zaful. All rights reserved.
//

#import "ZFShareTopView.h"

#define kW [UIScreen mainScreen].bounds.size.width
#define kScale      kW / 375.0
static CGFloat kCornerRadius = 8.0f;

@interface ZFShareTopView ()
@property (nonatomic, strong) YYLightView   *topImageView;
@property (nonatomic, strong) YYLabel       *titleLabel;
@end

@implementation ZFShareTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(255)/255.0 green:(255)/255.0 blue:(255)/255.0 alpha:1.0];
        self.layer.shadowColor = [UIColor colorWithRed:(153)/255.0 green:(153)/255.0 blue:(153)/255.0 alpha:1.0].CGColor;
        self.layer.shadowRadius = 20.0f;
        self.layer.shadowOffset = CGSizeMake(0,5);
        self.layer.shadowOpacity = 0.5;

        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat kTopViewW = 255 * kScale;
    CGFloat kTopViewH = 340 * kScale;
    CGFloat kTopViewY = 60  * kScale;
    CGFloat kTopViewX = (kW - kTopViewW) * 0.5;
    [self setFrame:CGRectMake(kTopViewX, kTopViewY, kTopViewW, kTopViewH)];
    
    [self cutCornerRadiuWithRect:self.bounds view:self rectCorners:UIRectCornerAllCorners];
    
    CGRect topImageViewRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds));
    self.topImageView.frame = topImageViewRect;
    [self cutCornerRadiuWithRect:topImageViewRect view:self.topImageView rectCorners:UIRectCornerTopLeft | UIRectCornerTopRight];

    CGFloat kTitleLabelX = 16 * kScale;
    CGFloat kTitleLabelY = CGRectGetMaxY(self.topImageView.frame) + 20;
    CGFloat kTitleLabelW = CGRectGetWidth(self.bounds) - 32;
    CGFloat kTitleLabelH = 45 * kScale;
    self.titleLabel.frame = CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelW, kTitleLabelH);
}

- (void)initSubViews {
    [self addSubview:self.topImageView];
    [self addSubview:self.titleLabel];
}

- (void)cutCornerRadiuWithRect:(CGRect)rect view:(UIView *)targetView rectCorners:(UIRectCorner)rectCorners{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorners cornerRadii:CGSizeMake(kCornerRadius, kCornerRadius)];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = rect;
    shapelayer.path = bezierPath.CGPath;
    targetView.layer.mask = shapelayer;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    [self.topImageView.layer removeAnimationForKey:@"contents"];
    
    [self.topImageView.layer yy_setImageWithURL:[NSURL URLWithString:imageName]
                                   processorKey:NSStringFromClass([self class])
                                    placeholder:nil
                                        options:YYWebImageOptionAvoidSetImage
                                     completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                         if (image && stage == YYWebImageStageFinished) {
                                             int width = image.size.width;
                                             int height = image.size.height;
                                             CGFloat scale = (height / width) / (self.topImageView.size.height / self.topImageView.size.width);
                                             if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                                 self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
                                                 self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                             } else { // 高图只保留顶部
                                                 self.topImageView.contentMode = UIViewContentModeScaleToFill;
                                                 self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
                                             }
                                             self.topImageView.image = image;
                                             if (from != YYWebImageFromMemoryCacheFast) {
                                                 CATransition *transition = [CATransition animation];
                                                 transition.duration = 0.3;
                                                 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                                 transition.type = kCATransitionFade;
                                                 [self.topImageView.layer addAnimation:transition forKey:@"contents"];
                                             }
                                         }
                                     }];
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

#pragma mark - Getter
- (YYLightView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[YYLightView alloc] initWithFrame:CGRectZero];
        _topImageView.clipsToBounds = YES;
    }
    return _topImageView;
}

- (YYLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithRed:(51)/255.0 green:(51)/255.0 blue:(51)/255.0 alpha:1.0];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 32;
    }
    return _titleLabel;
}

@end
