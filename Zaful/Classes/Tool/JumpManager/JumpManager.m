//
//  JumpManager.m
//  Zaful
//
//  Created by DBP on 16/10/25.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "JumpManager.h"
#import "JumpModel.h"
#import "ZFGoodsDetailViewController.h"
#import "ZFWebViewViewController.h"
#import "SearchResultViewController.h"

#import "ZFCommunityViewController.h"
#import "ZFCommunityAccountViewController.h"
#import "CommunityDetailViewController.h"

#import "TopicViewController.h"
#import "MessagesViewController.h"
#import "CouponViewController.h"
#import "AccountViewController.h"
#import "MyOrdersListViewController.h"
#import "OrderDetailViewController.h"
#import "ZFCartViewController.h"
#import "VideoViewController.h"

#import "CategoryVirtualViewController.h"
#import "CategoryListPageViewController.h"
#import "CategoryDataManager.h"
#import "ZFLoginViewController.h"

#import "NSArray+SafeAccess.h"

@implementation JumpManager

+ (void)doJumpActionTarget:(id)target withJumpModel:(JumpModel *)jumpModel
{
    JumpActionType actionType    = jumpModel.actionType;
    NSString *url                = jumpModel.url;
    NSString *name               = jumpModel.name;
    
    UIViewController *targetVC   = target;
    switch (actionType) {
        case JumpDefalutActionType:
        {
            ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
            [tabbar setModel:TabBarIndexHome];
            ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexHome];
            if (nav) {
                if (nav.viewControllers.count>1) {
                    [nav popToRootViewControllerAnimated:NO];
                }
            }
        }
            break;
        case JumpHomeChannelActionType:
        {
            ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
            [tabbar setModel:TabBarIndexHome];
        }
            break;
        case JumpCategoryActionType:
        {
            CategoryListPageViewController *listPageVC = [[CategoryListPageViewController alloc] init];
            CategoryNewModel *model = [[CategoryNewModel alloc] init];
            model.cat_id = url;
            model.cat_name = name;
            NSArray<CategoryNewModel *> *childs = [[CategoryDataManager shareManager] querySubCategoryDataWithParentID:model.cat_id];
            if (childs.count > 0) {
                model.is_child = @"1";
            }
            listPageVC.model = model;

            [targetVC.navigationController pushViewController:listPageVC animated:YES];
        }
            break;
        case JumpGoodDetailActionType:
        {
            ZFGoodsDetailViewController *goodsDetailVC = [[ZFGoodsDetailViewController alloc] init];
            goodsDetailVC.goodsId = url;
            [targetVC.navigationController pushViewController:goodsDetailVC animated:YES];
        }
            break;
        case JumpSearchActionType:
        {
            SearchResultViewController *searchResultVC = [[SearchResultViewController alloc] init];
            searchResultVC.searchString = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            searchResultVC.title = name;
            [targetVC.navigationController pushViewController:searchResultVC animated:YES];
        }
            break;
        case JumpInsertH5ActionType:
        {
            // 加载H5
            if ([NSStringUtils isBlankString:url]) {
                return;
            }
            ZFWebViewViewController *webVC = [[ZFWebViewViewController alloc] init];
            webVC.link_url = url;
            [targetVC.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case JumpBuyShowActionType:
        {
            //社区
            NSArray *communityInfo = [url componentsSeparatedByString:@","];
            NSInteger communityStyle = [communityInfo integerWithIndex:0];
            switch (communityStyle) {
                case 0:
                {   // 社区首页 
                    ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
                    [tabbar setModel:TabBarIndexCommunity];
                }
                    break;
                case 1:  // 个人主页
                {
                    NSString  *communityID = [communityInfo stringWithIndex:1];
                    if ([NSStringUtils isBlankString:communityID]) return;
                    ZFCommunityAccountViewController *styleVC = [ZFCommunityAccountViewController new];
                    styleVC.userId = communityID;
                    styleVC.isDeeplink = YES;
                    [targetVC.navigationController pushViewController:styleVC animated:YES];
                }
                    break;
                case 2:  // 评论详情
                {
                    NSString  *communityID = [communityInfo stringWithIndex:1];
                    NSString  *userId = [communityInfo stringWithIndex:2];
                    if ([NSStringUtils isBlankString:communityID]) return;
                    CommunityDetailViewController *detailVC = [[CommunityDetailViewController alloc] initWithReviewId:communityID userId:userId];
                    [targetVC.navigationController pushViewController:detailVC animated:YES];
                }
                    break;
                case 3:  // 话题详情
                {
                    NSString  *topicId = [communityInfo stringWithIndex:1];
                    if ([NSStringUtils isBlankString:topicId]) return;
                    TopicViewController *topicVC = [[TopicViewController alloc] init];
                    topicVC.topicId = topicId;
                    [targetVC.navigationController pushViewController:topicVC animated:YES];
                }
                    break;
                case 4:  // 视频详情
                {
                    NSString  *videoId = [communityInfo stringWithIndex:1];
                    if ([NSStringUtils isBlankString:videoId]) return;
                    VideoViewController *videoVC = [[VideoViewController alloc] init];
                    videoVC.videoId = videoId;
                    [targetVC.navigationController pushViewController:videoVC animated:YES];
                }
                    break;
            }
        }
            break;
        case JumpExternalLinkActionType:
        {
            [SHAREDAPP openURL:[NSURL URLWithString:URLENCODING(url)]];
        }
            break;
        case JumpMessageActionType:
        {
            //社区
            ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
            [tabbar setModel:TabBarIndexCommunity];
            ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexCommunity];
            if (nav) {
                if (nav.viewControllers.count>1) {
                    [nav popToRootViewControllerAnimated:NO];
                }
                ZFCommunityViewController *communityVC = nav.viewControllers[0];
                MessagesViewController *messageVC = [[MessagesViewController alloc]init];
                [communityVC.navigationController pushViewController:messageVC animated:YES];
            }
        }
            break;
        case JumpCouponActionType:
        {
            if ([AccountManager sharedManager].isSignIn) {
                CouponViewController *couponVC = [[CouponViewController alloc] init];
                [targetVC.navigationController pushViewController:couponVC animated:YES];
            } else {
                ZFLoginViewController *signVC = [[ZFLoginViewController alloc] init];
                @weakify(targetVC)
                signVC.successBlock = ^(){
                    @strongify(targetVC)
                    CouponViewController *couponVC = [[CouponViewController alloc] init];
                    [targetVC.navigationController pushViewController:couponVC animated:YES];
                };
                ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                [targetVC presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
        case JumpOrderListActionType:
        {
            if ([AccountManager sharedManager].isSignIn) {
                ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
                [tabbar setModel:TabBarIndexAccount];
                ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexAccount];
                if (nav) {
                    if (nav.viewControllers.count>1) {
                        [nav popToRootViewControllerAnimated:NO];
                    }
                    AccountViewController *accountVC = nav.viewControllers[0];
                    MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
                    [accountVC.navigationController pushViewController:orderListVC animated:YES];
                }
                
            } else {
                ZFLoginViewController *signVC = [[ZFLoginViewController alloc] init];
                signVC.successBlock = ^(){
                    ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
                    [tabbar setModel:TabBarIndexAccount];
                    ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexAccount];
                    if (nav) {
                        if (nav.viewControllers.count>1) {
                            [nav popToRootViewControllerAnimated:NO];
                        }
                        AccountViewController *accountVC = nav.viewControllers[0];
                        MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
                        [accountVC.navigationController pushViewController:orderListVC animated:YES];
                    }
                };
                ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                [targetVC presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
        case JumpOrderDetailActionType:
        {
            
            if ([AccountManager sharedManager].isSignIn) {
                ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
                [tabbar setModel:TabBarIndexAccount];
                ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexAccount];
                if (nav) {
                    if (nav.viewControllers.count>1) {
                        [nav popToRootViewControllerAnimated:NO];
                    }
                    AccountViewController *accountVC = nav.viewControllers[0];
                    MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
                    [accountVC.navigationController pushViewController:orderListVC animated:NO];
                    
                    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
                    orderDetailVC.orderId = url;
                    [orderListVC.navigationController pushViewController:orderDetailVC animated:YES];
                }
                
            } else {
                ZFLoginViewController *signVC = [[ZFLoginViewController alloc] init];
                signVC.successBlock = ^(){
                    ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
                    [tabbar setModel:TabBarIndexAccount];
                    ZFNavigationController *nav = [tabbar navigationControllerWithMoudle:TabBarIndexAccount];
                    if (nav) {
                        if (nav.viewControllers.count>1) {
                            [nav popToRootViewControllerAnimated:NO];
                        }
                        AccountViewController *accountVC = nav.viewControllers[0];
                        MyOrdersListViewController *orderListVC = [[MyOrdersListViewController alloc] init];
                        [accountVC.navigationController pushViewController:orderListVC animated:NO];
                        
                        OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
                        orderDetailVC.orderId = url;
                        [orderListVC.navigationController pushViewController:orderDetailVC animated:YES];
                    }
                };
                ZFNavigationController *nav = [[ZFNavigationController alloc] initWithRootViewController:signVC];
                [targetVC presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
        case JumpCartActionType:
        {
            ZFCartViewController *cartVC = [[ZFCartViewController alloc] init];
            [targetVC.navigationController pushViewController:cartVC animated:YES];
        }
            break;
        case JumpCollectionActionType:
        {
            ZFTabBarController *tabbar = (ZFTabBarController *)targetVC.tabBarController;
            [tabbar setModel:TabBarIndexDesigners];
        }
            break;
        case JumpVirtualCategoryActionType:
        {
            CategoryVirtualViewController *listPageVC = [[CategoryVirtualViewController alloc] init];
            listPageVC.virtualType = url;
            listPageVC.virtualTitle = name;
            [targetVC.navigationController pushViewController:listPageVC animated:YES];
        }
        default:
            break;
    }
}

@end
