//
//  ZFHomeFloatingView.m
//  Zaful
//
//  Created by QianHan on 2017/10/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomeFloatingView.h"
#import "BannerModel.h"

@interface ZFHomeFloatingView () {
    BannerModel *_floatModel;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation ZFHomeFloatingView

- (instancetype)initWithModel:(BannerModel *)floatModel {
    if (self = [super init]) {
        [self setupView];
        _floatModel = floatModel;
    }
    return self;
}

- (void)setupView {
    [self.backgroundView addSubview:self.imageView];
    [self.backgroundView addSubview:self.closeButton];
}

- (void)tunrToInfoAction {
    [self.backgroundView removeFromSuperview];
    if (self.tapActionHandle) {
        self.tapActionHandle();
    }
}

- (void)closeAtion {
    [self.backgroundView removeFromSuperview];
}

- (void)show {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_floatModel.image]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            CGFloat height = image.size.height * DSCREEN_WIDTH_SCALE;
            CGFloat width  = image.size.width * DSCREEN_WIDTH_SCALE;
            self.imageView.frame = CGRectMake((self.backgroundView.width - width) / 2, 0.0, width, height);
            self.imageView.y = (self.backgroundView.height - (self.imageView.height + 20.0 + self.closeButton.height
                                                              )) / 2;
//            self.closeButton.y = self.imageView.y + self.imageView.height + 20.0f;
//            self.closeButton.x = (self.backgroundView.width - self.closeButton.width) / 2;
            if ([SystemConfigUtils isRightToLeftShow]) {
                self.closeButton.x = 15.0f;
                self.closeButton.y = self.imageView.y - 15.0f - self.closeButton.height;
            } else {
                self.closeButton.x = self.backgroundView.width - 15.0f - self.closeButton.width;
                self.closeButton.y = self.imageView.y - 15.0f - self.closeButton.height;
            }
            
            [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
            [UIView animateWithDuration:0.25 animations:^{
                self.backgroundView.alpha = 1.0;
            }];
        });
    });
}

#pragma mark - getter/setter
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundView.alpha = 0.0;
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    }
    return _backgroundView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [tapGesture addTarget:self action:@selector(tunrToInfoAction)];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor clearColor];
        _closeButton.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"home_suspension_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAtion) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
