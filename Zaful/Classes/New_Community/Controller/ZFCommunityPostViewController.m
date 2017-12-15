

//
//  ZFCommunityPostViewController.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityPostViewController.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityPostViewController () <ZFInitViewProtocol>

@end

@implementation ZFCommunityPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
}

- (void)zfAutoLayoutView {
    
}

#pragma mark - getter



@end
