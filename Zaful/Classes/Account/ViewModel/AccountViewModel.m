//
//  AccountViewModel.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AccountViewModel.h"

#import "AccountCell.h"

#import "AccountHeaderView.h"

#import "AccountFooterView.h"

#import "EditProfileViewController.h"

#import "MyOrdersListViewController.h"

#import "AddressListViewController.h"

#import "MyCouponViewController.h"

#import "MyPointsViewController.h"

#import "CurrencyViewController.h"

#import "ChangePasswordViewController.h"

#import "CartViewController.h"

#import "HelpViewController.h"

#import "SettingViewController.h"

typedef NS_ENUM(NSInteger , AccountTypeOne) {
    AccountTypeOrders,
    AccountTypeDRewards,
};

typedef NS_ENUM(NSInteger , AccountTypeTwo) {
    AccountTypeCoupon,
    AccountTypeAddress,
};

typedef NS_ENUM(NSInteger , AccountTypeThree) {
    AccountTypePassword,
    AccountTypeCurrency,
};

typedef NS_ENUM(NSInteger , AccountTypeFour) {
    AccountTypeSettings,
    AccountTypeHelp,
};


@interface AccountViewModel () <AccountHeaderViewDelegate>

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *imgArray;

@end

@implementation AccountViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleArray =  @[
                                @[ZFLocalizedString(@"Account_Cell_Orders",nil),ZFLocalizedString(@"Account_Cell_Points",nil)
                                  ],
                                @[ZFLocalizedString(@"Account_Cell_Coupon",nil),ZFLocalizedString(@"Account_Cell_Address",nil)
                                  ],
                                @[ZFLocalizedString(@"Account_Cell_Password",nil),ZFLocalizedString(@"Account_Cell_Currency",nil)
                                  ],
                                @[ZFLocalizedString(@"Account_Cell_Setting",nil),ZFLocalizedString(@"Account_Cell_Help",nil)
                                  ]
                                ];
        self.imgArray =  @[
                            @[@"orders",@"dRewards"],
                            @[@"coupon",@"address",@"share",@"reviews"],
                            @[@"password",@"currency"],
                            @[@"aboutUs",@"contactUs"]
                            ];
    }
    return self;
}

//点击填写个人资料的回调
-(void)accountHeaderViewEditBtnClick:(AccountHeaderView *)view
{
    EditProfileViewController *profileVC = [[EditProfileViewController alloc] init];
    [self.controller.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case AccountTypeOrders:
            {
                MyOrdersListViewController *myOrderVC = [[MyOrdersListViewController alloc] init];
                [self.controller.navigationController pushViewController:myOrderVC animated:YES];
                break;
            }
            case AccountTypeDRewards:
            {
                MyPointsViewController *myPointsVC = [[MyPointsViewController alloc] init];
                [self.controller.navigationController pushViewController:myPointsVC animated:YES];
                break;
            }
           
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case AccountTypeCoupon:
            {
                MyCouponViewController *couponVC = [[MyCouponViewController alloc] init];
                [self.controller.navigationController pushViewController:couponVC animated:YES];
                break;
            }
            case AccountTypeAddress:
            {
                AddressListViewController *addressVC = [[AddressListViewController alloc] init];
                [self.controller.navigationController pushViewController:addressVC animated:YES];
                break;
            }
        }
    }else if (indexPath.section == 2){
        switch (indexPath.row) {
            case AccountTypePassword:
            {
                ChangePasswordViewController *vc = [ChangePasswordViewController new];
                [self.controller.navigationController pushViewController:vc animated:YES];
                break;
            }
            case AccountTypeCurrency:
            {
                CurrencyViewController *currencyVC = [[CurrencyViewController alloc] init];
                [self.controller.navigationController pushViewController:currencyVC animated:YES];
                
                break;
            }
        }
    }else if (indexPath.section == 3){
        
        switch (indexPath.row) {
            case AccountTypeSettings:
            {
                SettingViewController * setvc = [[SettingViewController alloc]init];
                
                setvc.hidesBottomBarWhenPushed = YES;
                
                [self.controller.navigationController pushViewController:setvc animated:YES];
                
                break;
            }
            case AccountTypeHelp:
            {
                HelpViewController * help = [[HelpViewController alloc]init];
                
                help.hidesBottomBarWhenPushed = YES;
                
                [self.controller.navigationController pushViewController:help animated:YES];
                
                break;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.001;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountCell *cell = [AccountCell cellWithTableView:tableView andIndexPath:indexPath];
    
    cell.nameLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
    cell.imgView.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

@end
