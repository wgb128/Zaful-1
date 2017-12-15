//
//  ZFCommunityDetailReviewHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailReviewsHeaderView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityDetailReviewsHeaderView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UILabel           *reviewLabel;
@end

@implementation ZFCommunityDetailReviewsHeaderView
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
    [self addSubview:self.lineView];
    [self addSubview:self.reviewLabel];
}

- (void)zfAutoLayoutView {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(3, 16));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading);
    }];
    
    [self.reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).mas_offset(10);
    }];
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR_BLACK;
    }
    return _lineView;
}

- (UILabel *)reviewLabel {
    if (!_reviewLabel) {
        _reviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _reviewLabel.text = ZFLocalizedString(@"TopicDetailView_Reviews",nil);
        _reviewLabel.font = [UIFont systemFontOfSize:18];
        _reviewLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);

    }
    return _reviewLabel;
}

@end
