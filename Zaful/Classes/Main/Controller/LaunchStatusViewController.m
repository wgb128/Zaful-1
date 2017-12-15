//
//  LaunchStatusViewController.m
//  Zaful
//
//  Created by zhaowei on 2017/1/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "LaunchStatusViewController.h"

@interface LaunchStatusViewController ()
@property (nonatomic,strong) YYAnimatedImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *reloadBtn;
@end

@implementation LaunchStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ZFCOLOR(245,245,245, 1.0);
    
    self.imageView = [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"wifi"]];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(180 * DSCREEN_WIDTH_SCALE);
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = ZFLocalizedString(@"LaunchStatusViewController_Tip",nil);
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(12);
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
    }];
    
    
    self.reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reloadBtn.backgroundColor = [UIColor blackColor];
    self.reloadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.reloadBtn setTitle:ZFLocalizedString(@"LaunchStatusViewController_Retry",nil) forState:UIControlStateNormal];
    self.reloadBtn.layer.cornerRadius = 2;
    [self.reloadBtn addTarget:self action:@selector(reloadEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.reloadBtn];
    [self.reloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(28 * DSCREEN_WIDTH_SCALE);
        make.centerX.mas_equalTo(self.imageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(144, 44));
    }];
}

- (void)reloadEvent:(id)sender {
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

@end
