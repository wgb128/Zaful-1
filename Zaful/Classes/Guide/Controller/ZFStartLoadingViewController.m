//
//  ZFStartLoadingViewController.m
//  Zaful
//
//  Created by liuxi on 2017/11/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFStartLoadingViewController.h"
#import "ZFInitViewProtocol.h"
#import "UIView+GBGesture.h"

@interface ZFStartLoadingViewController () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView       *loadImageView;
@property (nonatomic, strong) UIButton          *skipButton;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation ZFStartLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - action methods
- (void)skipButtonAction:(UIButton *)sender {
    dispatch_source_cancel(self.timer);
    if (self.startLoadingSkipCompletionHandler) {
        self.startLoadingSkipCompletionHandler();
    }
}

#pragma mark - private methods
- (void)openTimeCountToRefreshView {
    __block NSInteger time = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.startLoadingSkipCompletionHandler) {
                    self.startLoadingSkipCompletionHandler();
                }
            });
        }else{
            NSInteger seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.skipButton setTitle:[NSString stringWithFormat:@"%@ %lu", ZFLocalizedString(@"StartLoad_Skip_Tips", nil), seconds] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.loadImageView];
    [self.view addSubview:self.skipButton];
}

- (void)zfAutoLayoutView {
    [self.loadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(48);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-24);
        make.size.mas_equalTo(CGSizeMake(68, 28));
    }];
    self.skipButton.layer.cornerRadius = 14;
}

#pragma mark - setter
- (void)setLoadUrl:(NSString *)loadUrl {
    _loadUrl = loadUrl;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kStartLoadingImageInfo];
    self.loadImageView.image = [UIImage imageWithData:data];
    [self openTimeCountToRefreshView];

}

#pragma mark - getter
- (UIImageView *)loadImageView {
    if (!_loadImageView) {
        _loadImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _loadImageView.userInteractionEnabled = YES;
        @weakify(self);
        [_loadImageView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            if (self.startLoadingJumpBannerCompletionHandler) {
                dispatch_source_cancel(self.timer);
                self.startLoadingJumpBannerCompletionHandler();
            }
        }];
    }
    return _loadImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.layer.borderColor = [UIColor blackColor].CGColor;
        _skipButton.layer.borderWidth = 1.f;
        [_skipButton setTitle:[NSString stringWithFormat:@"%@ 3", ZFLocalizedString(@"StartLoad_Skip_Tips", nil)] forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

@end
