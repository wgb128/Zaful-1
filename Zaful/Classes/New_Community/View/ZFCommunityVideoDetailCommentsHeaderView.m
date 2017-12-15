
//
//  ZFCommunityVideoDetailCommentsHeaderView.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailCommentsHeaderView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityVideoDetailCommentsHeaderView () <ZFInitViewProtocol>

@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UILabel           *commentsLabel;

@end

@implementation ZFCommunityVideoDetailCommentsHeaderView
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.commentsLabel];
}

- (void)zfAutoLayoutView {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-10);
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

- (UILabel *)commentsLabel {
    if (!_commentsLabel) {
        _commentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentsLabel.textColor = ZFCOLOR_BLACK;
        _commentsLabel.font = [UIFont systemFontOfSize:16];
    }
    return _commentsLabel;
}
@end
