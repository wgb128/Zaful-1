//
//  ZFTabBarController.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/21.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "ZFTabBarController.h"
#import "ZFNavigationController.h"
#import "HomeViewController.h"
#import "ZFCollectionViewController.h"

#import "CategoryParentViewController.h"

#import "AccountViewController.h"
#import "ZFCommunityViewController.h"
#import "ZFHomePageViewController.h"

//社区POST功能使用
#import "TZImagePickerController.h"
#import "PostViewController.h"
#import "PostPhotosManager.h"
#import "ZFLoginViewController.h"

@interface ZFTabBarController () <UITabBarControllerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) YYAnimatedImageView *itemView;
@property (nonatomic,strong) ZFCommunityViewController *communityController;
@property (nonatomic,assign) NSInteger indexFlag;

@end

@implementation ZFTabBarController

+ (void)initialize {
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupControllers];
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    _itemView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"post_message"]];
    //    _itemView.frame = CGRectMake(SCREEN_WIDTH / 5 * 2, 5, SCREEN_WIDTH / 5, 49);
    _itemView.frame = CGRectMake(self.view.centerX-30, 1.5, 60, 46);
    /**
     *  为tabbar顶部添加一条线
     */
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[ZFCOLOR(209, 209, 209, 1.0) CGColor]];
    solidShapeLayer.lineWidth = .1f ;
    CGPathMoveToPoint(solidShapePath, NULL, 0, 0);
    CGPathAddLineToPoint(solidShapePath, NULL, SCREEN_WIDTH,0);
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [self.tabBar.layer addSublayer:solidShapeLayer];
}

- (void)setupControllers
{
    // 1.首页（频道版）
    ZFHomePageViewController *homeViewController = [[ZFHomePageViewController alloc] init];
    [self setupChildViewController:homeViewController title:ZFLocalizedString(@"Tabbar_Home",nil) imageName:@"home" selectedImageName:@"home_hover"];
    
    // 2.分类
    CategoryParentViewController *newCategory = [[CategoryParentViewController alloc] init];
    [self setupChildViewController:newCategory title:ZFLocalizedString(@"Tabbar_Categories",nil) imageName:@"Categories" selectedImageName:@"Categories_hover"];
    
    // 3.社区
    ZFCommunityViewController *community = [[ZFCommunityViewController alloc] init];
    [self setupChildViewController:community title:ZFLocalizedString(@"Tabbar_Z-Me",nil) imageName:@"post" selectedImageName:@"post_hover"];
    self.communityController = community;
    
    // 4.收藏
    ZFCollectionViewController *collection = [[ZFCollectionViewController alloc] init];
    [self setupChildViewController:collection title:ZFLocalizedString(@"Tabbar_Wishlist",nil) imageName:@"Wishlist" selectedImageName:@"wishlist_hover"];
    
    // 5.账户
    AccountViewController *account = [[AccountViewController alloc] init];
    [self setupChildViewController:account title:ZFLocalizedString(@"Tabbar_Account",nil) imageName:@"Account" selectedImageName:@"Account_hover"];
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    [childVc.tabBarItem setImageInsets:UIEdgeInsetsMake(-3, 0, 3, 0)];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    // 2.包装一个导航控制器
    ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:childVc];

    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    NSInteger index = [self.tabBar.items indexOfObject:item];
    
    if (self.indexFlag != index) {
        [self animationWithIndex:index];
    }
    
}
// 动画
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.08;
    pulse.repeatCount= 1;
    pulse.autoreverses = YES;
    pulse.fromValue = [NSNumber numberWithFloat:0.7];
    pulse.toValue = [NSNumber numberWithFloat:1.3];
    //这里的操作主要让tabar上自定义的view也进行缩放效果和tabbar其他按钮保持一致动画
    if (index  == 2) {
        [[_itemView layer] addAnimation:pulse forKey:nil];
    } else {
        [[tabbarbuttonArray[index] layer] addAnimation:pulse forKey:nil];
    }
    self.indexFlag = index;
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UINavigationController *)viewController {
    
    
    _lastNavController = (ZFNavigationController *)viewController;
    
    if ([viewController.topViewController isKindOfClass:HomeViewController.class]
        || [viewController.topViewController isKindOfClass:ZFHomePageViewController.class]) {
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bottom Bar" actionName:@"Click_bottom tabbar_Home" label:@"Side Bar - Home"];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bottom Tabbar_Home" itemName:@"home" ContentType:@"Bottom-Tabbar" itemCategory:@"tabbar"];
    } else if ([viewController.topViewController isKindOfClass:CategoryParentViewController.class]) {
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bottom Bar" actionName:@"Click_bottom tabbar_Categories" label:@"Side Bar - Categories"];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bottom Tabbar_Categories" itemName:@"Categories" ContentType:@"Bottom-Tabbar" itemCategory:@"tabbar"];
    } else if ([viewController.topViewController isKindOfClass:ZFCommunityViewController.class]) {
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bottom Bar" actionName:@"Click_bottom tabbar_Z-Me" label:@"Side Bar - Community"];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bottom Tabbar_Z-Me" itemName:@"Z-Me" ContentType:@"Bottom-Tabbar" itemCategory:@"tabbar"];
    } else if ([viewController.topViewController isKindOfClass:ZFCollectionViewController.class]) {
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bottom Bar" actionName:@"Click_bottom tabbar_Favorites" label:@"Side Bar - Wishlist"];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bottom Tabbar_Favorites" itemName:@"Favorites" ContentType:@"Bottom-Tabbar" itemCategory:@"tabbar"];
    } else if ([viewController.topViewController isKindOfClass:AccountViewController.class]) {
        // 谷歌统计
        [ZFAnalytics clickButtonWithCategory:@"Bottom Bar" actionName:@"Click_bottom tabbar_Account" label:@"Side Bar - Account"];
        
        [ZFFireBaseAnalytics selectContentWithItemId:@"Click_Bottom Tabbar_Account" itemName:@"Account" ContentType:@"Bottom-Tabbar" itemCategory:@"tabbar"];
    }
    
    
    if (![AccountManager sharedManager].isSignIn && [viewController.topViewController isKindOfClass:AccountViewController.class]) {
        
        ZFLoginViewController *signVC = [[ZFLoginViewController alloc] init];
        
        @weakify(self)
        signVC.successBlock = ^(){
            @strongify(self)
            
            self.selectedViewController = _lastNavController;
            
            [_itemView removeFromSuperview];
        };
        
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    } else if ([viewController.topViewController isKindOfClass:ZFCommunityViewController.class]) {
        
        if ([[self.selectedViewController valueForKey:@"topViewController"] isKindOfClass:ZFCommunityViewController.class]) {
            if ([AccountManager sharedManager].isSignIn) {
                [self pushImagePickerController];
            } else {
                ZFLoginViewController *signVC = [ZFLoginViewController new];
                @weakify(self)
                signVC.successBlock = ^{
                    @strongify(self)
                    [self pushImagePickerController];
                };
                
                __block NSInteger i  = tabBarController.selectedIndex;
                signVC.cancelSignBlock = ^(){
                    @strongify(self)
                    self.selectedIndex = i;
                };
                
                ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
            return NO;
        } else {
            [self.tabBar addSubview:_itemView];
            return YES;
        }
    }
    [_itemView removeFromSuperview];
    return YES;
}

- (ZFNavigationController*)navigationControllerWithMoudle:(TabBarIndex)moudle {
    if (self.viewControllers.count > moudle) {
        ZFNavigationController *nav = [self.viewControllers objectAtIndex:moudle];
        return nav;
    }else{
        return nil;
    }
}

- (void)setModel:(TabBarIndex)model
{
    if (self.selectedIndex == model) {
        return;
    }else{
        if([self tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:model]]) {
            self.selectedIndex = model;
        }
    }
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
//    if ([SystemConfigUtils isCanRightToLeftShow]) {
//        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_arrow_left"]];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_arrow_left"]];
//    }
    TZImagePickerController *customImagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    customImagePickerController.isSelectOriginalPhoto = YES;
    // 1.设置目前已经选中的图片数组
    customImagePickerController.selectedAssets = [PostPhotosManager sharedManager].selectedAssets; // 目前已经选中的图片数组
    
    customImagePickerController.allowTakePicture = YES; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    customImagePickerController.allowPickingVideo = NO;
    customImagePickerController.allowPickingImage = YES;
    customImagePickerController.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    customImagePickerController.sortAscendingByModificationDate = NO;
    
    customImagePickerController.minImagesCount = 1;
    customImagePickerController.maxImagesCount = 6;
    
    [self presentViewController:customImagePickerController animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    [self isAR];
    [PostPhotosManager sharedManager].selectedPhotos = [NSMutableArray arrayWithArray:photos];
    [PostPhotosManager sharedManager].selectedAssets = [NSMutableArray arrayWithArray:assets];
    [PostPhotosManager sharedManager].isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    PostViewController *postVC = [[PostViewController alloc] init];
    postVC.selectedPhotos = [PostPhotosManager sharedManager].selectedPhotos;
    postVC.selectedAssets = [PostPhotosManager sharedManager].selectedAssets;
    if ([picker isKindOfClass:[TZImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:postVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self isAR];
}

- (void) isAR {
    if ([SystemConfigUtils isCanRightToLeftShow]) {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
//        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
//        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
    }
}

@end
