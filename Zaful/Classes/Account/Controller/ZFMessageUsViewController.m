//
//  ZFMessageUsViewController.m
//  Zaful
//
//  Created by QianHan on 2017/11/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFMessageUsViewController.h"
#import <WebKit/WebKit.h>

@interface ZFMessageUsViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZFMessageUsViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"Account_Cell_Message_Us", nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self setupView];
    [self addObserverKeypath];
}

- (void)setupView {
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self initNavigationItem];
}

- (void)initNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

#pragma mark - kvo
- (void)addObserverKeypath {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - event
- (void)backAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    if (!navigationAction.targetFrame.isMainFrame
        && navigationAction.request != nil) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    }
    
    if (navigationAction.request != nil) {
        NSURL *url = navigationAction.request.URL;
        NSString *scheme = [url scheme];
        if ([scheme isEqualToString:@"fb-messenger-public"]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    [self.progressView setProgress:0 animated:NO];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0 animated:NO];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
    [self.progressView setProgress:0 animated:NO];
}

#pragma marke - getter/setter
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask   = UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor    = [UIColor clearColor];
        _webView.UIDelegate         = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator   = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        
        NSURL *URL = [NSURL URLWithString:@"https://m.me/916028728426822?ref=ios"];
        NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
        [_webView loadRequest:requestURL];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.width, 2.0)];
        _progressView.trackTintColor    = [UIColor clearColor];
        _progressView.progressTintColor = ZFCOLOR(253, 216, 53, 1.0);
        _progressView.progress = 0.0;
    }
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
