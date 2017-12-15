//
//  ZFCitySelectViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCitySelectViewController.h"
#import "ZFInitViewProtocol.h"

@interface ZFCitySelectViewController () <ZFInitViewProtocol>

@end

@implementation ZFCitySelectViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
}

- (void)zfAutoLayoutView {
    
}

#pragma mark - getter

@end
