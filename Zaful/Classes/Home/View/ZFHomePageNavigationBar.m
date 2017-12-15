//
//  ZFHomePageNavigationBar.m
//  Zaful
//
//  Created by QianHan on 2017/10/11.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageNavigationBar.h"

static CGFloat const kButtonWidth = 44.0f;
static CGFloat const kStatusBarHeight = 0.0f;
static CGFloat const kSpace = 10.0f;
@interface ZFHomePageNavigationBar ()

@property (nonatomic, strong) UIButton            *searchButton;
@property (nonatomic, strong) UIButton            *bagButton;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, strong) CALayer             *separetorLayer;
@property (nonatomic, strong) JSBadgeView         *badgeView;

@property (nonatomic, strong) UIView *hostTagView;

@end

@implementation ZFHomePageNavigationBar

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0.0, 0.0, KScreenWidth, 44.0);
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

#pragma mark - init
- (void)setupView {
    
    [self addSubview:self.searchButton];
    [self addSubview:self.bagButton];
    [self addSubview:self.imageView];
    // 测试或预发布环境才会设置
    if (!isFormalhost || (preRelease && isFormalhost)) {
        [self addGestures];
        [self.imageView addSubview:self.hostTagView];
    }
    
    // 购物车角标
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:self.bagButton alignment:JSBadgeViewAlignmentTopLeft];
        self.badgeView.badgePositionAdjustment = CGPointMake(11.0f, 16.0f);
        self.bagButton.x = kSpace;
        self.searchButton.x = self.width - kSpace - kButtonWidth;
    } else {
        self.badgeView = [[JSBadgeView alloc]initWithParentView:self.bagButton alignment:JSBadgeViewAlignmentTopRight];
        self.badgeView.badgePositionAdjustment = CGPointMake(5.0f, 1.0f);
        self.searchButton.x = kSpace;
        self.bagButton.x = self.width - kSpace - kButtonWidth;
    }
    self.badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
    
    self.separetorLayer = [[CALayer alloc] init];
    self.separetorLayer.frame = CGRectMake(0.0, self.frame.size.height - 1.0f, self.frame.size.width, 1.0);
    self.separetorLayer.backgroundColor = [UIColor colorWithRed:188.0 / 255.0
                                                          green:188.0 / 255.0
                                                           blue:188.0 / 255.0
                                                          alpha:1.0].CGColor;
    [self.layer addSublayer:self.separetorLayer];
}

- (void)addGestures {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(changeLocalHost)];
    [self.imageView addGestureRecognizer:tapGesture];
}

- (void)subViewWithAlpa:(CGFloat)alpha {
    self.searchButton.alpha = alpha;
    self.bagButton.alpha    = alpha;
    self.badgeView.alpha    = alpha;
    self.imageView.alpha    = alpha;
    self.hostTagView.alpha  = alpha;
    self.separetorLayer.backgroundColor = [UIColor colorWithRed:188.0 / 255.0
                                                          green:188.0 / 255.0
                                                           blue:188.0 / 255.0
                                                          alpha:alpha].CGColor;
}

#pragma mark - event
- (void)searchAction {
    
    if (self.searchActionHandle) {
        self.searchActionHandle();
    }
}

- (void)bagAction {
    
    if (self.bagActionHandle) {
        self.bagActionHandle();
    }
}

- (void)changeLocalHost {
    
    if (self.changeLocalHostHandle) {
        self.changeLocalHostHandle();
    }
}

#pragma mark - getter/setter
- (UIButton *)searchButton {
    
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(kSpace, kStatusBarHeight, kButtonWidth, kButtonWidth);
        _searchButton.backgroundColor = [UIColor clearColor];
        [_searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UIButton *)bagButton {
    
    if (!_bagButton) {
        _bagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bagButton.frame = CGRectMake(self.frame.size.width - kSpace - kButtonWidth, kStatusBarHeight, kButtonWidth, kButtonWidth);
        _bagButton.backgroundColor = [UIColor clearColor];
        [_bagButton setImage:[UIImage imageNamed:@"bag"] forState:UIControlStateNormal];
        [_bagButton addTarget:self action:@selector(bagAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bagButton;
}

- (YYAnimatedImageView *)imageView {
    
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"zaful"];
        _imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
        _imageView.center = CGPointMake(self.frame.size.width / 2, kStatusBarHeight + (self.frame.size.height - kStatusBarHeight) / 2);
        _imageView.image  = image;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)hostTagView {
    
    if (!_hostTagView) {
        
        _hostTagView        = [[UIView alloc] init];
        _hostTagView.frame  = CGRectMake(0.0, 0.0, 8.0, 8.0);
        _hostTagView.center = CGPointMake(self.imageView.frame.size.width / 2, self.imageView.frame.size.height / 2);
        _hostTagView.layer.cornerRadius = _hostTagView.frame.size.height / 2;
        
        // 设置对应颜色
        if (!isFormalhost) {  // 测试环境
            _hostTagView.backgroundColor = isTrunkHost ? [UIColor greenColor] : ZFCOLOR(0, 0, 255, 1.0);
        }
        
        if (preRelease && isFormalhost) {  // 预发布环境
            _hostTagView.backgroundColor = [UIColor orangeColor];
        }
    }
    return _hostTagView;
}

- (void)setBagValues {
    
    NSNumber *badgeNum     = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    if ([badgeNum integerValue] > 99) {
        numberIndex = @"99+";
    } else {
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    }
    self.badgeView.badgeText = numberIndex;
}

@end
