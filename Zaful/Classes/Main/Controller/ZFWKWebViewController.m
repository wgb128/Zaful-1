//
//  ZFWKWebViewController.m
//  Zaful
//
//  Created by DBP on 16/10/25.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFWKWebViewController.h"
#import <WebKit/WebKit.h>

NSString *const ScriptMessageHandlerName = @"webViewApp";

@interface ZFWKWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,weak) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ZFWKWebViewController

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
}
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadURL:self.url];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 注册 JS 方法
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:ScriptMessageHandlerName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 记得移除 JS 方法
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:ScriptMessageHandlerName];
}

#pragma mark  加载webView数据请求
-(void)loadURL:(NSString *)urlString{
    NSURL *webUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:webUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60];
    [self.webView loadRequest:request];
}

#pragma mark  Present cancel Methods
// 当Present的时候，返回
- (void)dismissAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MakeUI
- (void)initView {
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [UIColor whiteColor];
    //隐藏滚动条
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.allowsBackForwardNavigationGestures = true;
    //修改颜色
    //    webView.scrollView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    //加载数据为空时的代理
    webView.scrollView.emptyDataSetSource = self;
    webView.scrollView.emptyDataSetDelegate = self;
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.webView = webView;
    
    [self.webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    
    // 添加进入条
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor = ZFCOLOR(253, 216, 53, 1.0);
    self.progressView.frame = self.view.bounds;
    [self.view addSubview:self.progressView];
    
    if (self.isPresentVC) {
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
        [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(8, -5, 0, 0)];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        ZFLog(@"progress: %f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!self.webView.loading || self.webView.estimatedProgress == 1.0) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
        //        NSString *js = @"callJsAlert()";
        //        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //            NSLog(@"response: %@ error: %@", response, error);
        //            NSLog(@"call js alert by native");
        //        }];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.alpha = 0;
            self.progressView.progress = 0;
        }];
    }else{
        self.progressView.alpha = 1;
    }
}

#pragma mark - WKScriptMessageHandlerDelegate
//实现js调用iOS的handle委托
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //接受传过来的消息从而决定app调用的方法
    NSDictionary *dict = message.body;
    NSString *method = [dict objectForKey:@"method"];
    if ([method isEqualToString:@"hello"]) {
        [self hello:[dict objectForKey:@"param1"]];
    }else if ([method isEqualToString:@"Call JS"]){
        [self callJS];
    }else if ([method isEqualToString:@"Call JS Msg"]){
        [self callJSMsg:[dict objectForKey:@"param1"]];
    }
}

//直接调用js
//webView.evaluateJavaScript("hi()", completionHandler: nil)
//调用js带参数
//webView.evaluateJavaScript("hello('liuyanwei')", completionHandler: nil)
//调用js获取返回值
//webView.evaluateJavaScript("getName()") { (any,error) -> Void in
//    NSLog("%@", any as! String)
//}
- (void)hello:(NSString *)param{
    [self showAlert:param Title:@"js Call iOS"];
}

- (void)callJS{
    [self.webView evaluateJavaScript:@"iOSCallJSNO()" completionHandler:nil];
}

- (void)callJSMsg:(NSString *)msg{
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"iOSCallJS('%@')",msg] completionHandler:nil];
}
#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation { // 类似UIWebView的 -webViewDidStartLoad:
    ZFLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    ZFLog(@"didCommitNavigation");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { // 类似 UIWebView 的 －webViewDidFinishLoad:
    ZFLog(@"didFinishNavigation");
    //[self resetControl];
//    if (webView.title.length > 0) {
//        self.title = webView.title;
//    }
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    ZFLog(@"didFailProvisionalNavigation");
}


// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    self.progressView.alpha = 1.0;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    // 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
    ZFLog(@"4.%@",navigationAction.request);
    //    NSString *url = [navigationAction.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    NSString *url = navigationAction.request.URL.absoluteString;
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    ZFLog(@"didReceiveServerRedirectForProvisionalNavigation");
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *internal))completionHandler {
//    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling,internal);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

#pragma mark - WKUIDelegate
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    // 接口的作用是打开新窗口委托
//    //[self createNewWebViewWithURL:webView.URL.absoluteString config:Web];
//    
//    return self.webView;
//}

//1.创建一个新的WebVeiw
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sure"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}

//  js 里面的alert实现，如果不实现，网页的alert函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sure"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    completionHandler(@"Client Not handler");
    
}

#pragma mark - Prviate Method
- (void)showAlert:(NSString *)content Title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:content
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sure"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                      }]];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

@end
