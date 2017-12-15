//
//  ZFPaymentView.m
//  Yoshop
//
//  Created by zhaowei on 16/6/23.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "ZFPaymentView.h"
#import "UIButton+EnlargeEdge.h"

#define TAG_ALERT_GOBACK    77777
#define TAG_BUTTON_ACTION   77778
#define TAG_CONTAINER       77779

@interface ZFPaymentView () <UIAlertViewDelegate, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,assign) PaymentStatus status;
@property (nonatomic,strong) UIView *container;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation ZFPaymentView

#pragma mark - Life Cycle
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"loading" context:nil];
    [self.webView removeObserver:self forKeyPath:@"title" context:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        [self initViewWithFrame:frame];
    }
    return self;
}

#pragma mark - UI
- (void)initViewWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.container = [[UIView alloc] initWithFrame:CGRectZero];
    self.container.backgroundColor = [UIColor whiteColor];
    self.container.layer.cornerRadius = 5;
    self.container.clipsToBounds = YES;
    self.container.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.container.layer.borderWidth = 1;
    self.container.tag = TAG_CONTAINER;
    [self addSubview:self.container];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    // 添加进入条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = ZFCOLOR(254, 105, 2, 1.0);
    [self.container addSubview:self.progressView];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.container);
        make.height.mas_equalTo(@3);
    }];
    
    self.webView = [WKWebView new];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    //隐藏滚动条
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    //修改颜色
    [self.container addSubview:self.webView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.container).with.insets(UIEdgeInsetsMake(3, 0, 0, 0));
    }];

    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setEnlargeEdge:40];
    self.closeBtn.backgroundColor = ZFCOLOR(254, 105, 2, 1.0);
    self.closeBtn.backgroundColor = [UIColor clearColor];
    [self.closeBtn setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.closeBtn];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.container.mas_leading).offset(5);
        make.width.height.mas_equalTo(@25);
        make.top.mas_equalTo(self.container.mas_top).offset(10);
    }];

    if (!isFormalhost){
        
        UILabel *lblname = [UILabel new];
        lblname.tag = 0;
        lblname.textColor = [UIColor redColor];
        lblname.font = [UIFont systemFontOfSize:14.0];
        lblname.text = @"用户名（点击复制）：sammydress123@qq.com";
        lblname.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tapGesture1.numberOfTapsRequired = 1;
        [lblname addGestureRecognizer:tapGesture1];
        
        [self addSubview:lblname];
        [lblname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.closeBtn.mas_trailing).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(self.mas_top).offset(10);
        }];
        
        UILabel *lblpass = [UILabel new];
        lblpass.tag = 1;
        lblpass.textColor = [UIColor redColor];
        lblpass.font = [UIFont systemFontOfSize:14.0];
        lblpass.text = @"密码（点击复制）：long870125";
        lblpass.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        tapGesture2.numberOfTapsRequired = 1;
        [lblpass addGestureRecognizer:tapGesture2];
        
        [self addSubview:lblpass];
        [lblpass mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.closeBtn.mas_trailing).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.height.mas_equalTo(@20);
            make.top.mas_equalTo(lblname.mas_bottom);
        }];
        
        
    }

    // 添加KVO监听
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}

/**
 双击复制用户名和密码
 
 @param label 双击的label
 */
-(void)tapClick:(UIGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    if (label.tag == 0) {
        [UIPasteboard generalPasteboard].string = @"sammydress123@qq.com";
    } else if (label.tag == 1) {
        [UIPasteboard generalPasteboard].string = @"long870125";
    }
    
     [MBProgressHUD showMessage:[NSString stringWithFormat:@"%@复制成功",[UIPasteboard generalPasteboard].string]];
}

- (void)close {
    self.status = PaymentStatusCancel;
    [self dismiss];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow).with.insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
    
    CGFloat duration = 0.3;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1), @(1.05), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"bouce"];
}

- (void)dismiss {
    if (_block) {
        _block(self.status);
    }
    
    
    CGFloat duration = 0.2;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.container.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:^(BOOL finished) {
        self.container.transform = CGAffineTransformMakeScale(1, 1);
    }];

}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
     NSString *containUserTokenUrl = [NSString stringWithFormat:@"%@",_url];
    ZFLog(@"%@",containUserTokenUrl);
    NSURL *webUrl = [NSURL URLWithString:containUserTokenUrl];
    if (webUrl == nil) return;//防止url为空时直接奔溃.
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:webUrl];
    
    if (preRelease) {
        NSHTTPCookie *cookieuser = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                             NSHTTPCookieName:@"staging",
                                                                             NSHTTPCookieValue:@"true",
                                                                             NSHTTPCookieDomain:@".zaful.com",
                                                                             NSHTTPCookiePath:@"/",
                                                                             }];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[cookieuser] forURL:webUrl mainDocumentURL:nil];
        
        NSMutableURLRequest *request1 =[NSMutableURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:300];
        
        [request1 addValue:@"staging=true;" forHTTPHeaderField:@"Cookie"];
    }
    
    [self.webView loadRequest:request];

}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        ZFLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        ZFLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading || self.webView.estimatedProgress == 1.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
            self.progressView.progress = 0;
        }];
    }else{
        self.progressView.alpha = 1;
    }
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_ALERT_GOBACK) {
        if (buttonIndex == 1) {
            [self dismiss];
        }else{
            
        }
    }
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    NSURL *url = navigationAction.request.URL;
    NSString *strUrl = url.absoluteString.lowercaseString;
    ZFLog(@"#####:%@", strUrl);
    self.status = PaymentStatusUnknown;

    if (isFormalhost) {
        ///containString是包含---有路径的链接，hasSuffix针对---跟链接
        if ([strUrl containsString:MY_ACCOUNT_BACK_URL] || [strUrl hasSuffix:RETURN_TO_HOME_BACK_URL] || [strUrl containsString:PAY_SUCCESS] || [strUrl containsString:PAY_EBANX_SUCCESS]) {
            self.status = PaymentStatusDone;
            [self dismiss];
        }
        /**
         *  支付失败
         */
        if ([strUrl containsString:PAY_FAIL1] || [strUrl containsString:PAY_FAIL2]|| [strUrl containsString:PAY_FAIL3]|| [strUrl containsString:PAY_FAIL4]|| [strUrl containsString:PAY_FAIL5]) {
            self.status = PaymentStatusFail;
        }
        
        if ([strUrl containsString:PAYPAL_CANCEL] || [strUrl containsString:PAY_EBANX_CANCEL]) {
            self.status = PaymentStatusCancel;
            [self dismiss];
        }

    }else{
        
        if ([strUrl containsString:MY_ACCOUNT_BACK_DEV_URL] || [strUrl containsString:RETURN_TO_HOME_BACK_DEV_URL] || [strUrl containsString:PAY_DEV_SUCCESS] || [strUrl containsString:PAY_EBANX_DEV_SUCCESS]) {
            self.status = PaymentStatusDone;
            [self dismiss];
        }
        /**
         *  支付失败
         */
        if ([strUrl containsString:PAY_DEV_FAIL1] || [strUrl containsString:PAY_DEV_FAIL2] || [strUrl containsString:PAY_DEV_FAIL3] || [strUrl containsString:PAY_DEV_FAIL4]) {
            self.status = PaymentStatusFail;
        }
        
        if ([strUrl containsString:PAYPAL_CANCEL_DEV] || [strUrl containsString:PAY_EBANX_CANCEL]) {
            self.status = PaymentStatusCancel;
            [self dismiss];
        }
    }
    
    decisionHandler(actionPolicy);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)navigationResponse.response;
        if (response.statusCode != 200) {
        }
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    ZFLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
//1.创建一个新的WebVeiw
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

@end
