//
//  ZFCommunityTopicDetailViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/5.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityTopicDetailViewController.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityTopicDetailViewController () <ZFInitViewProtocol>

@end

@implementation ZFCommunityTopicDetailViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
}

- (void)zfAutoLayoutView {
    
}

#pragma mark - getter

@end
