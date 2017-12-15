//
//  ZFWebViewViewController.m
//  Zaful
//
//  Created by TsangFa on 16/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFWebViewViewController.h"
#import <WebKit/WebKit.h>
#import "JumpModel.h"
#import "JumpManager.h"
#import "ZFLoginViewController.h"

@interface ZFWebViewViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong)  WKWebView                   *webView;
@property (nonatomic, strong)  UIProgressView              *progressView;
@property (nonatomic, strong)  NSMutableDictionary         *params;
@end

@implementation ZFWebViewViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [[AccountManager sharedManager] clearWebCookie];
    [self configureWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - Private method
- (void)configureWebView {
    [self initNavigationItem];
    [self initWKWebView];
    [self initProgressView];
    [self observerKeypath];
}

- (void)initNavigationItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
}

- (void)initWKWebView {
    WKWebViewConfiguration *configuration          = [[WKWebViewConfiguration alloc] init];
//    WKUserContentController* userContentController = WKUserContentController.new;
//    NSString * cookieStr                           = [NSString stringWithFormat:@"document.cookie ='token=%@';", TOKEN];
//    WKUserScript * cookieScript                    = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    [userContentController addUserScript:cookieScript];
//    configuration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    if (preRelease) {
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                         NSHTTPCookieName:@"staging",
                                                                         NSHTTPCookieValue:@"true",
                                                                         NSHTTPCookieDomain:@".zaful.com",
                                                                         NSHTTPCookiePath:@"/",
                                                                         }];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[cookie] forURL:[NSURL URLWithString:self.link_url] mainDocumentURL:nil];
        
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.link_url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
        
        [request addValue:@"staging=true;" forHTTPHeaderField:@"Cookie"];
        [self.webView loadRequest:request];
    }else{
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.link_url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
        [self.webView loadRequest:request];
    }
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
}

- (void)initProgressView {
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    self.progressView.progressTintColor = ZFCOLOR(253, 216, 53, 1.0);
    [self.view addSubview:self.progressView];
}

- (void)observerKeypath {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    }
}

- (void)parseURLParams:(NSURL *)url {
    if (![url.scheme isEqualToString:@"zaful"] && ![url.scheme isEqualToString:@"webaction"]) {
        return;
    }
    [self.params removeAllObjects];
    if (url.query) {
        NSArray *arr = [url.query componentsSeparatedByString:@"&"];
        for (NSString *str in arr) {
            if ([str rangeOfString:@"="].location != NSNotFound) {
                NSString *key = [str componentsSeparatedByString:@"="][0];
                NSString *value;
                if ([key isEqualToString:@"url"]) {
                    value = [str substringFromIndex:4] ;
                }else{
                    value = [str componentsSeparatedByString:@"="][1];
                }
                [self.params setObject:value forKey:key];
            }
        }
        ZFLog(@"\n================================ 参数 =======================================\n👉: %@", self.params);
    }
}

- (void)deeplinkHandle {
    JumpModel *jumpModel = [[JumpModel alloc] init];
    jumpModel.actionType = [NSStringUtils isEmptyString:_params[@"actiontype"]] ? JumpDefalutActionType : [_params[@"actiontype"] integerValue];
    jumpModel.url        = NullFilter(_params[@"url"]);
    jumpModel.name       = NullFilter(_params[@"name"]);
    [JumpManager doJumpActionTarget:self withJumpModel:jumpModel];
}

- (void)jsLoginHandle {
    if ([NullFilter(_params[@"isAlert"]) isEqualToString:@"1"]) {
        if ([[AccountManager sharedManager] isSignIn]) {
            [self registerLoginFunction];
        }else{
            ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
            @weakify(self)
            loginVC.successBlock = ^{
                @strongify(self)
                [self registerLoginFunction];
            };
            [self.navigationController presentViewController:loginVC animated:YES completion:nil];
        }
    }
}

- (void)registerLoginFunction { // webAction://login?callback=appUserInfo()&isAlert=1   把用户登录信息传给前端  1 弹出  0 不弹
    NSString *functionName;
    NSRange range = [NullFilter(_params[@"callback"]) rangeOfString:@"()" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        functionName = [NullFilter(_params[@"callback"]) substringToIndex:range.location];
    }
    NSString  *jsFunction = [NSString stringWithFormat:@"%@('%@','%@','%@')", functionName, USERID,TOKEN,NullFilter(_params[@"redirect"])];
    [self.webView evaluateJavaScript:jsFunction completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
}

- (void)registerCurrencyFunction { //  webaction://currency?callback=getIosCurrencyInfo()  给前端传递当前货币符号
    NSString *functionName;
    NSRange range = [NullFilter(_params[@"callback"]) rangeOfString:@"()" options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        functionName = [NullFilter(_params[@"callback"]) substringToIndex:range.location];
    }
    NSString *jsFunction = [NSString stringWithFormat:@"%@('%@')", functionName, [ExchangeManager localCurrencyName]];
    [self.webView evaluateJavaScript:jsFunction completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        
    }];
}


#pragma mark - Target action
- (void)goBackAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSDictionary *cookieDict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookiesArray];
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    [self parseURLParams:url];
    ZFLog(@"\n================================ 链接地址 =======================================\n👉URL👈: %@ \n %@", url, cookieDict);
    
    if ([scheme isEqualToString:@"zaful"]) {
        [self deeplinkHandle];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if ([scheme isEqualToString:@"webaction"]) {
        if ([url.host isEqualToString:@"currency"]) {
            [self registerCurrencyFunction];
        }else if ([url.host isEqualToString:@"login"]){
            [self jsLoginHandle];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self.view.window.rootViewController presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - Getter
- (NSMutableDictionary *)params {
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return  _params;
}

@end
