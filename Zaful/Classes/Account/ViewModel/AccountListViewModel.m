//
//  AccountListViewModel.m
//  Zaful
//
//  Created by DBP on 17/3/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "AccountListViewModel.h"
#import "EditProfileViewController.h"

@implementation AccountListViewModel

//点击填写个人资料的回调
-(void)accountHeaderViewEditBtnClick:(AccountHeaderView *)view
{
    EditProfileViewController *profileVC = [[EditProfileViewController alloc] init];
    [self.controller.navigationController pushViewController:profileVC animated:YES];
}


@end
