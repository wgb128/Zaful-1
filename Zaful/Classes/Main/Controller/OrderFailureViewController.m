//
//  OrderFailureViewController.m
//  Zaful
//
//  Created by DBP on 16/12/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "OrderFailureViewController.h"

@interface OrderFailureViewController ()

@end

@implementation OrderFailureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // 统计数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self eventLog];
    });
}

#pragma mark - UI
- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    YYAnimatedImageView *img = [[YYAnimatedImageView alloc] init];
    img.image = [UIImage imageNamed:@"payFailure"];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(160 *DSCREEN_HEIGHT_SCALE);
        
        make.width.equalTo(@140);
        make.height.equalTo(@90);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.font = [UIFont systemFontOfSize:17.0];
    tipLab.textColor = ZFCOLOR(15, 15, 15, 1.0);
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.text = ZFLocalizedString(@"OrderFailure_VC_Tip",nil);
    [self.view addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(img.mas_bottom).offset(16);
        make.leading.offset(12);
        make.trailing.offset(-12);
    }];
    
    UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [accountBtn setTitle:ZFLocalizedString(@"OrderFailure_VC_Account_Button",nil) forState:UIControlStateNormal];
    [accountBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
    accountBtn.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
    accountBtn.layer.cornerRadius = 4;
    accountBtn.clipsToBounds = YES;
    accountBtn.tag = 1234;
    
    [accountBtn addTarget:self action:@selector(jumpToAccoutOrHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountBtn];
    [accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLab.mas_bottom).offset(60 *DSCREEN_HEIGHT_SCALE);
        make.leading.offset(64 *DSCREEN_WIDTH_SCALE);
        make.trailing.offset(-64 *DSCREEN_WIDTH_SCALE);
        make.height.equalTo(@40);
    }];
    
}

- (void)jumpToAccoutOrHome:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.orderFailureBlock) {
        self.orderFailureBlock();
    }
}

#pragma mark - 统计
- (void)eventLog
{
    // 谷歌统计
    [ZFAnalytics screenViewQuantityWithScreenName:@"Payment Failure"];
}



@end

