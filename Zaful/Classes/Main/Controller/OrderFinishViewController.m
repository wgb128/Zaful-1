//
//  YSOrderFinishViewController.m
//  Yoshop
//
//  Created by 7F-shigm on 16/6/24.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "OrderFinishViewController.h"
#import "ZFAnalytics.h"
#import "FilterManager.h"

@interface OrderFinishViewController ()

@end

@implementation OrderFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // 统计数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self eventLog];
    });
}

#pragma mark - UI
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    YYAnimatedImageView *img = [[YYAnimatedImageView alloc] init];
    img.image = [UIImage imageNamed:@"order_success"];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_4X_3_5) {
            make.top.mas_equalTo(self.view.mas_top).offset(60);
        }else{
            make.top.mas_equalTo(self.view.mas_top).offset(80);
        }
        make.width.equalTo(@140);
        make.height.equalTo(@90);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *tipLab1 = [[UILabel alloc] init];
    tipLab1.font = self.isVerifcation ? [UIFont systemFontOfSize:17] : [UIFont systemFontOfSize:13];;
    tipLab1.textColor = self.isVerifcation ? ZFCOLOR(15, 15, 15, 1.0) : ZFCOLOR(178, 178, 178, 1.0);
    tipLab1.textAlignment = NSTextAlignmentCenter;
    tipLab1.numberOfLines = 0;
    tipLab1.text = self.isVerifcation ? [NSString stringWithFormat:ZFLocalizedString(@"OrderFinishViewController_tipLab1",nil),self.orderSn] : ZFLocalizedString(@"OrderFinish_VC_TipLabel_One",nil);
    [self.view addSubview:tipLab1];
    [tipLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(42);
        make.leading.offset(12);
        make.trailing.offset(-12);
    }];
    
    UILabel *tipLab2 = [[UILabel alloc] init];
    tipLab2.font = self.isVerifcation ? [UIFont systemFontOfSize:17] : [UIFont systemFontOfSize:13];;
    tipLab2.textColor = self.isVerifcation ? ZFCOLOR(15, 15, 15, 1.0) : ZFCOLOR(178, 178, 178, 1.0);
    tipLab2.textAlignment = NSTextAlignmentCenter;
    tipLab2.numberOfLines = 0;
    tipLab2.text = self.isVerifcation ? ZFLocalizedString(@"OrderFinishViewController_tipLab2", nil) : ZFLocalizedString(@"OrderFinish_VC_TipLabel_Two",nil);
    [self.view addSubview:tipLab2];
    [tipLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab1.mas_bottom).offset(12);
        make.leading.offset(12);
        make.trailing.offset(-12);
    }];
    
    UILabel *tipLab3 = [[UILabel alloc] init];
    tipLab3.font = self.isVerifcation ? [UIFont systemFontOfSize:17] : [UIFont systemFontOfSize:13];
    tipLab3.textColor = self.isVerifcation ? ZFCOLOR(15, 15, 15, 1.0) : ZFCOLOR(178, 178, 178, 1.0);
    tipLab3.textAlignment = NSTextAlignmentCenter;
    tipLab3.numberOfLines = 0;
    
    if (self.isVerifcation) {
        tipLab3.text =  [NSString stringWithFormat:ZFLocalizedString(@"OrderFinishViewController_tipLab3", nil),self.paymentAccount];
    }else{
        tipLab3.text =  ZFLocalizedString(@"OrderFinish_VC_TipLabel_Three",nil);
    }
    
    [self.view addSubview:tipLab3];
    [tipLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab2.mas_bottom).offset(12);
        make.leading.offset(12);
        make.trailing.offset(-12);
    }];
    
    UILabel *orderSnLab = [[UILabel alloc] init];
    orderSnLab.textAlignment = NSTextAlignmentCenter;
    orderSnLab.numberOfLines = 0;
    orderSnLab.font = self.isVerifcation ? [UIFont systemFontOfSize:15] : [UIFont systemFontOfSize:17];
    orderSnLab.textColor = self.isVerifcation ? ZFCOLOR(178, 178, 178, 1.0) : ZFCOLOR(15, 15, 15, 1.0);
    orderSnLab.text = self.isVerifcation ? ZFLocalizedString(@"OrderFinishViewController_tipLab4", nil) : _orderSn;
    [self.view addSubview:orderSnLab];
    [orderSnLab mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.isVerifcation) {
            make.top.mas_equalTo(tipLab3.mas_bottom).offset(44);
        }else{
            make.top.mas_equalTo(tipLab3.mas_bottom).offset(12);
        }
        make.leading.offset(33);
        make.trailing.offset(-33);
    }];
#pragma mark - 下单成功
    UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [accountBtn setTitle:ZFLocalizedString(@"OrderFinish_VC_Account_Button",nil) forState:UIControlStateNormal];
    [accountBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    accountBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
    accountBtn.layer.cornerRadius = 4;
    accountBtn.clipsToBounds = YES;
    accountBtn.tag = 1234;
    
    [accountBtn addTarget:self action:@selector(jumpToAccoutOrHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountBtn];
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (SCREEN_WIDTH == 320) {
            make.top.mas_equalTo(orderSnLab.mas_bottom).offset(25);
            make.leading.mas_equalTo(self.view.mas_leading).offset(40);
            make.trailing.mas_equalTo(self.view.mas_trailing).offset(-40);
        }else{
            make.top.mas_equalTo(orderSnLab.mas_bottom).offset(55);
            make.leading.offset(67);
            make.trailing.offset(-67);
        }
        make.height.equalTo(@40);
    }];
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [homeBtn setTitle:ZFLocalizedString(@"OrderFinish_VC_Home_Button",nil) forState:UIControlStateNormal];
    [homeBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    homeBtn.backgroundColor = ZFCOLOR(202, 202, 202, 1.0);
    homeBtn.layer.cornerRadius = 4;
    homeBtn.clipsToBounds = YES;
    [homeBtn addTarget:self action:@selector(jumpToAccoutOrHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeBtn];
    [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountBtn.mas_bottom).offset(20);
        make.size.equalTo(accountBtn);
        make.centerX.equalTo(accountBtn);
    }];
}

- (void)jumpToAccoutOrHome:(UIButton *)sender
{
    /**
     *  把从购物车到订单页面的所有页面pop掉.
     */
    __block BOOL isAccount = sender.tag == 1234 ? YES : NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.toAccountOrHomeblock) {
        self.toAccountOrHomeblock(isAccount);
    }
}

#pragma mark - 统计
- (void)eventLog
{
    // 谷歌统计
    [ZFAnalytics screenViewQuantityWithScreenName:@"PaySuccess"];

}

@end
