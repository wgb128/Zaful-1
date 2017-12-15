//
//  GuideController.m
//  BossBuy
//
//  Created by BB on 15/7/20.
//  Copyright (c) 2015年 fasionspring. All rights reserved.
//

#import "GuideController.h"
#import "ZFLoginViewController.h"


@interface GuideController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray       *scrollViewPages;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger     centerPageIndex;
@property (nonatomic, strong) UIButton      *signUpButton;
@property (nonatomic, strong) UIView        *loginContainerView;
@property (nonatomic, strong) UILabel       *signInTipsLabel;
@property (nonatomic, strong) UIButton      *loginButton;
@end

@implementation GuideController
#pragma mark - init methods
- (id)initWithCoverImageNames:(NSArray *)coverNames {
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames button:(UIButton *)button {
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames {
    self.coverImageNames = coverNames;
}

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    self.pagingScrollView.showsVerticalScrollIndicator = NO;
    self.pagingScrollView.bounces = NO;
    [self.view addSubview:self.pagingScrollView];
    
    [self.pagingScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.height.mas_equalTo(SCREEN_HEIGHT - 130);
    }];
    
    [self.view addSubview:self.signUpButton];
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(24);
        make.trailing.mas_equalTo(self.view.mas_trailing).offset(-24);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.pagingScrollView.mas_bottom).offset(24);
    }];
    
    [self.view addSubview:self.loginContainerView];
    [self.loginContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signUpButton.mas_bottom).offset(16);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-24);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.loginContainerView addSubview:self.signInTipsLabel];
    [self.loginContainerView addSubview:self.loginButton];
    
    [self.signInTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.loginContainerView);
        make.leading.top.bottom.mas_equalTo(self.loginContainerView);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.loginContainerView);
        make.trailing.top.bottom.mas_equalTo(self.loginContainerView);
        make.leading.mas_equalTo(self.signInTipsLabel.mas_trailing);
    }];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
    [self.pageControl setValue:[UIImage imageNamed:@"active"] forKey:@"currentPageImage"];
    [self.pageControl setValue:[UIImage imageNamed:@"normal"] forKey:@"pageImage"];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.hidden = YES;
    [self.view addSubview:self.pageControl];
    
//    if (!self.enterButton) {
//        UIImage * enterImage = [UIImage imageNamed:@"enterImage"];
//        self.enterButton = [UIButton new];
//        [self.enterButton setBackgroundImage:enterImage forState:UIControlStateNormal];
//    }
    
//    [self.enterButton addTarget:self action:@selector(enter:) forControlEvents:UIControlEventTouchUpInside];
//    self.enterButton.frame = [self frameOfEnterButton];
//    self.enterButton.alpha = 0;
//    [self.view addSubview:self.enterButton];
    
    [self reloadPages];
}

- (void)reloadPages {
    self.pageControl.numberOfPages = [[self coverImageNames] count];
    self.pagingScrollView.contentSize = [self contentSizeOfScrollView];
    
    __block CGFloat x = 0;
    [[self scrollViewPages] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        obj.frame = CGRectOffset(obj.frame, x, 0);
        [self.pagingScrollView addSubview:obj];
        
        x += obj.frame.size.width;
    }];
    
    // fix enterButton can not presenting if ScrollView have only one page
    if (self.pageControl.numberOfPages == 1) {
//        self.enterButton.alpha = 1;
        self.pageControl.alpha = 0;
    }
    
    // fix ScrollView can not scrolling if it have only one page
    if (self.pagingScrollView.contentSize.width == self.pagingScrollView.frame.size.width) {
        self.pagingScrollView.contentSize = CGSizeMake(self.pagingScrollView.contentSize.width + 1, self.pagingScrollView.contentSize.height);
    }
}

- (CGRect)frameOfPageControl {
    return CGRectMake(0, self.view.bounds.size.height - 30 * DSCREEN_HEIGHT_SCALE, self.view.bounds.size.width, 5);
}

- (CGRect)frameOfEnterButton {
    CGSize size = self.enterButton.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(115 * DSCREEN_WIDTH_SCALE, 37 * DSCREEN_HEIGHT_SCALE);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height - 32 * DSCREEN_HEIGHT_SCALE, size.width, size.height);
}

#pragma mark - Action
- (void)enter:(id)object {
    self.didSelectedEnter();
}

- (void)loginButtonAction:(UIButton *)sender {
    
    ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];
    loginVC.enterType = ZFLoginEnterTypeLogin;
    @weakify(self);
    loginVC.successBlock = ^{
        @strongify(self);
        if (self.didSelectedEnter) {
            self.didSelectedEnter();
        }
    };
    loginVC.cancelSignBlock = ^{
        @strongify(self)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)signUpButtonAction:(UIButton *)sender {
    ZFLoginViewController *loginVC = [[ZFLoginViewController alloc] init];
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:loginVC];

    loginVC.enterType = ZFLoginEnterTypeSignUp;
    @weakify(self);
    loginVC.successBlock = ^{
        @strongify(self);
        if (self.didSelectedEnter) {
            self.didSelectedEnter();
        }
    };
    loginVC.cancelSignBlock = ^{
        @strongify(self)
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / [self numberOfPagesInPagingScrollView]);
    
    [self pagingScrollViewDidChangePages:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        if (![self hasNext:self.pageControl]) {
            [self enter:nil];
        }
    }
}

#pragma mark - UIScrollView & UIPageControl DataSource
- (BOOL)hasNext:(UIPageControl*)pageControl {
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl {
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (NSInteger)numberOfPagesInPagingScrollView {
    return [[self coverImageNames] count];
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView {
    
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
//            self.enterButton.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
//                self.enterButton.alpha = 1;
            }];
        }
    } else {
        [UIView animateWithDuration:0.4 animations:^{
//            self.enterButton.alpha = 0;
        }];
    }
}

- (BOOL)hasEnterButtonInView:(UIView*)page {
    __block BOOL result = NO;
    [page.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj && obj == self.enterButton) {
            result = YES;
        }
    }];
    return result;
}

- (YYAnimatedImageView *)scrollViewPage:(NSString*)imageName {
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sizeToFit];
    CGSize size = {SCREEN_WIDTH, SCREEN_HEIGHT - 135};
    imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, size.width, size.height);
    return imageView;
}

- (NSArray*)scrollViewPages {
    if ([self numberOfPagesInPagingScrollView] == 0) {
        return nil;
    }
    
    if (_scrollViewPages) {
        return _scrollViewPages;
    }
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    [self.coverImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIImageView *v = [self scrollViewPage:obj];
        [tmpArray addObject:v];
        
    }];
    
    _scrollViewPages = tmpArray;
    
    return _scrollViewPages;
}

- (CGSize)contentSizeOfScrollView {
    UIView *view = [[self scrollViewPages] firstObject];
    return CGSizeMake(view.frame.size.width * self.scrollViewPages.count, view.frame.size.height);
}


#pragma mark - getter
- (UIButton *)signUpButton {
    if (!_signUpButton) {
        _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _signUpButton.backgroundColor = [UIColor blackColor];
        [_signUpButton setTitle:ZFLocalizedString(@"Register_Button", nil) forState:UIControlStateNormal];
        [_signUpButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        _signUpButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_signUpButton addTarget:self action:@selector(signUpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signUpButton;
}

- (UIView *)loginContainerView {
    if (!_loginContainerView) {
        _loginContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _loginContainerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _loginContainerView;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:ZFLocalizedString(@"SignIn_Button", nil) forState:UIControlStateNormal];
        [_loginButton setTitleColor:ZFCOLOR(255, 168, 0, 1.f) forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _loginButton;
}

- (UILabel *)signInTipsLabel {
    if (!_signInTipsLabel) {
        _signInTipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _signInTipsLabel.textColor = [UIColor blackColor];
        _signInTipsLabel.font = [UIFont systemFontOfSize:14];
        _signInTipsLabel.text = ZFLocalizedString(@"Guide_Alter_Tips", nil);
    }
    return _signInTipsLabel;
}

@end
