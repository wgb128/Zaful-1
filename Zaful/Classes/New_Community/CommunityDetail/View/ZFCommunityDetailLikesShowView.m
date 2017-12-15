//
//  ZFCommunityDetailLikesShowView.m
//  Zaful
//
//  Created by liuxi on 2017/8/9.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailLikesShowView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityDetailLikesShowView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, strong) UILabel       *likesLabel;
@end

@implementation ZFCommunityDetailLikesShowView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.containerView];
    [self addSubview:self.likesLabel];
}

- (void)zfAutoLayoutView {
    
}

#pragma mark - getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = ZFCOLOR_WHITE;
    }
    return _containerView;
}

- (UILabel *)likesLabel {
    if (!_likesLabel) {
        _likesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _likesLabel.textAlignment = ![SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    }
    return _likesLabel;
}

@end
