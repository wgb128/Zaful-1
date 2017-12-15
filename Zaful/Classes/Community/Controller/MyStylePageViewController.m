//
//  MyStylePageViewController.m
//  Yoshop
//
//  Created by huangxieyue on 16/9/19.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "MyStylePageViewController.h"

/*HeaderView*/
#import "StyleHeaderView.h"

/*Shows控制器*/
#import "ShowsViewController.h"

/*Likes控制器*/
#import "LikesViewController.h"

/*关注列表控制器*/
#import "FollowViewController.h"

//当前ViewController的ViewModel
#import "MyStylePageViewModel.h"

//模型数据
#import "UserInfoModel.h"
#import "ZFWebViewViewController.h"
#import "StyleLikesModel.h"

#import "FriendsViewController.h"
#import "WMPanGestureRecognizer.h"
#import "ZFLoginViewController.h"

static CGFloat const kWMHeaderViewHeight = 152;
static CGFloat const kNavigationBarHeight = 0;

@interface MyStylePageViewController ()

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) StyleHeaderView *topView;

@property (nonatomic, strong) MyStylePageViewModel *viewModel;

@property (nonatomic, strong) WMPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation MyStylePageViewController
{
    YYAnimatedImageView *navBarHairlineImageView;
}

/*========================================分割线======================================*/

- (NSArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = @[ZFLocalizedString(@"MyStylePage_SubVC_Shows",nil), ZFLocalizedString(@"MyStylePage_SubVC_Likes",nil)];
    }
    return _categoryArray;
}

- (MyStylePageViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [MyStylePageViewModel new];
    }
    return _viewModel;
}

/*========================================分割线======================================*/

#pragma mark - 请求数据
- (void)requesData {
    @weakify(self)
    [self.viewModel requestNetwork:self.userid completion:^(id obj) {
        @strongify(self)
        if (obj) {
            self.topView.userInfoModel = obj;

        }
    } failure:^(id obj) {
        
    }];
}

/*========================================分割线======================================*/

- (instancetype)init {
    if (self = [super init]) {
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 16;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuItemWidth = SCREEN_WIDTH / self.categoryArray.count;
//        self.menuHeight = 44;
//        self.menuBGColor = [UIColor whiteColor];
        self.progressColor = ZFCOLOR(51, 51, 51, 1);
        self.titleColorSelected = ZFCOLOR(51, 51, 51, 1);
        self.titleColorNormal = ZFCOLOR(102, 102, 102, 102);
        self.viewTop = kNavigationBarHeight + kWMHeaderViewHeight;
    }
    return self;
}

- (YYAnimatedImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:YYAnimatedImageView.class] && view.bounds.size.height <= 1.0) {
        return (YYAnimatedImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        YYAnimatedImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

/*========================================分割线======================================*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"MyStylePage_VC_Title",nil);
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];//隐藏导航栏分割线

    /*关注通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHeaderData:) name:kLikeStatusChangeNotification object:nil];
    //接收登录状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginChangeValue:) name:kLoginNotification object:nil];

    [self initView];
    [self requesData];
    
    if ([self.userid isEqualToString:USERID]) {
        [self initNavRightBtn];
    }
    self.panGesture = [[WMPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnView:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavagationBarTranslucent];
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.menuView.transform = CGAffineTransformMakeRotation(M_PI);
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetNav];
}

- (void)panOnView:(WMPanGestureRecognizer *)recognizer {
    CGPoint currentPoint = [recognizer locationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.lastPoint = currentPoint;
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat targetPoint = velocity.y < 0 ? kNavigationBarHeight : kNavigationBarHeight + kWMHeaderViewHeight;
        NSTimeInterval duration = fabs((targetPoint - self.viewTop) / velocity.y);
        
        if (fabs(velocity.y) * 1.0 > fabs(targetPoint - self.viewTop)) {
            NSLog(@"velocity: %lf", velocity.y);
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.viewTop = targetPoint;
            } completion:nil];
            
            return;
        }
        
    }
    CGFloat yChange = currentPoint.y - self.lastPoint.y;
    self.viewTop += yChange;
    self.lastPoint = currentPoint;
}

// MARK: ChangeViewFrame (Animatable)
- (void)setViewTop:(CGFloat)viewTop {
    
    _viewTop = viewTop;
    
    if (_viewTop <= kNavigationBarHeight) {
        _viewTop = kNavigationBarHeight;
    }
    
    if (_viewTop > kWMHeaderViewHeight + kNavigationBarHeight) {
        _viewTop = kWMHeaderViewHeight + kNavigationBarHeight;
    }
    
//    self.viewFrame = CGRectMake(0, _viewTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - _viewTop -20);
}

-(void)setNavagationBarTranslucent
{
    navBarHairlineImageView.hidden = YES;
    NSString *navArrowName = @"back_w_left";
    
    if ([SystemConfigUtils isRightToLeftShow]) {
        navArrowName = @"back_w_right";
    }
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:navArrowName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:navArrowName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBarTintColor:ZFCOLOR(255, 168, 0, 1)];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeZero;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor whiteColor],NSForegroundColorAttributeName,
                          [UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,
                          shadow,NSShadowAttributeName,
                          shadow,NSShadowAttributeName,
                          nil];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)resetNav
{
    navBarHairlineImageView.hidden = NO;
    [self.navigationController.navigationBar setBackIndicatorImage:[[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeZero;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor blackColor],NSForegroundColorAttributeName,
                          [UIFont boldSystemFontOfSize:18.0],NSFontAttributeName,
                          shadow,NSShadowAttributeName,
                          shadow,NSShadowAttributeName,
                          nil];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

#pragma mark 直接点击返回
-(void)popToSuperView
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*========================================分割线======================================*/

#pragma mark - 初始化界面
- (void) initView {
    /*My Style顶部个人信息*/
    self.topView = [[StyleHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWMHeaderViewHeight)];
    
    @weakify(self)
    self.topView.followingTouchBlock = ^(UserInfoModel *userInfoModel){
        @strongify(self)
        FollowViewController *followVC = [FollowViewController new];
        followVC.userId = self.userid;
        followVC.userListType = ZFUserListTypeFollowing;
        [self.navigationController pushViewController:followVC animated:YES];
    };
    
    self.topView.followersTouchBlock= ^(UserInfoModel *userInfoModel){
        @strongify(self)
        FollowViewController *followVC = [FollowViewController new];
        followVC.userId = self.userid;
        followVC.userListType = ZFUserListTypeFollowed;
        [self.navigationController pushViewController:followVC animated:YES];
    };
    
    self.topView.followTouchBlock = ^(UserInfoModel *userInfoModel){
        @strongify(self)
        if ([AccountManager sharedManager].isSignIn) {
            [self followWithUserInfoModel:userInfoModel];
        }else
        {
            ZFLoginViewController *signVC = [ZFLoginViewController new];
            @weakify(self)
            signVC.successBlock = ^{
                @strongify(self)
                [self followWithUserInfoModel:userInfoModel];
            };
            ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
            [self.navigationController  presentViewController:nav animated:YES completion:^{
            }];
        }
        
    };
    
    self.topView.beLikedTouchBlock = ^(UserInfoModel *userInfoModel){
        // 暂时不需要跳转
    };
    
//    [self.view addSubview:self.topView];
    [self.view insertSubview:self.topView atIndex:0];
}

- (void)followWithUserInfoModel:(UserInfoModel *)userInfoModel
{
    if (userInfoModel.isFollow) {
        @weakify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:ZFLocalizedString(@"MyStylePage_Unfollow_Tip",nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *unfollow = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:ZFLocalizedString(@"MyStylePage_Unfollow",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self)
            // 关注/取消关注
            [self.viewModel requestFollowNetwork:userInfoModel completion:^(id obj) {
                
            } failure:^(id obj) {
                
            }];
        }];
        
        [alert addAction:cancel];
        [alert addAction:unfollow];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        // 关注/取消关注
        [self.viewModel requestFollowNetwork:userInfoModel completion:^(id obj) {
            
        } failure:^(id obj) {
            
        }];
    }
}

- (void)initNavRightBtn
{
    UIImage *howImage = [UIImage imageNamed:@"style_how"];
    UIButton *howBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    howBtn.frame = CGRectMake(0, 0, howImage.size.width, howImage.size.height);
    [howBtn setImage:howImage forState:UIControlStateNormal];
    [howBtn setImage:howImage forState:UIControlStateHighlighted];
    [howBtn addTarget:self action:@selector(jumpToCommunityDescription) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *howItem = [[UIBarButtonItem alloc] initWithCustomView:howBtn];
    
    
    UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame = CGRectMake(0, 0, MIN_PIXEL, 25);
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithCustomView:emptyBtn];
    
    
    UIImage *friendImage = [UIImage imageNamed:@"follow_top"];
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    friendBtn.frame = CGRectMake(0, 0, friendImage.size.width, friendImage.size.height);
    [friendBtn setImage:friendImage forState:UIControlStateNormal];
    [friendBtn setImage:friendImage forState:UIControlStateHighlighted];
    [friendBtn addTarget:self action:@selector(jumpToAddFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *friendItem = [[UIBarButtonItem alloc] initWithCustomView:friendBtn];
    
    self.navigationItem.rightBarButtonItems = @[howItem,emptyItem,friendItem];
}

- (void)jumpToCommunityDescription {
    ZFWebViewViewController *webViewVC = [[ZFWebViewViewController alloc] init];
    webViewVC.link_url = [NSString stringWithFormat:@"%@?lang=%@",CommunityIntroURL, [ZFLocalizationString shareLocalizable].nomarLocalizable];
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)jumpToAddFriend
{
    FriendsViewController *friendVC = [[FriendsViewController alloc] init];
    [self.navigationController pushViewController:friendVC animated:YES];
}

/*========================================分割线======================================*/

#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.categoryArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        return [[ShowsViewController alloc] initUserId:self.userid];
    }else {
        return [[LikesViewController alloc] initUserId:self.userid];
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.categoryArray[index];
}

/*========================================分割线======================================*/

#pragma mark - Notification
- (void)followStatusChangeValue:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];

    // 头部信息刷新
    UserInfoModel *userInfoModel = self.topView.userInfoModel;
    if ([USERID isEqualToString: self.userid])  // mystyle  只改变Following
    {
        if (isFollow) {
            userInfoModel.followingCount += 1;
        }else{
            userInfoModel.followingCount -= 1;
        }
    }
    else  // UserStyle  只改变Followers
    {
        if ([self.userid isEqualToString:followedUserId])
        {
            if (isFollow) {
                userInfoModel.followersCount += 1;
            }else{
                userInfoModel.followersCount -= 1;
            }
            userInfoModel.isFollow = isFollow;
        }
    }
    self.topView.userInfoModel = userInfoModel;
}

- (void)reloadHeaderData:(NSNotification *)noti
{
    // 评论相关用户头部点攒数改变
    StyleLikesModel *reviewsModel = noti.object;
    if ([reviewsModel.userId isEqualToString:self.userid]) {
        if (reviewsModel.isLiked) {
            self.topView.userInfoModel.likeCount = self.topView.userInfoModel.likeCount+1;
        }else{
            self.topView.userInfoModel.likeCount = self.topView.userInfoModel.likeCount-1;
        }
        self.topView.userInfoModel = self.topView.userInfoModel;
    }
}

#pragma mark - 接收登录通知
- (void)loginChangeValue:(NSNotification *)nofi {
    [self requesData];
}

/*========================================分割线======================================*/
@end
