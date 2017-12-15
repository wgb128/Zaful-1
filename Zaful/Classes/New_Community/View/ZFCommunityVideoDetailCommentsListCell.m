//
//  ZFCommunityVideoDetailCommentsListCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailCommentsListCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityVideoDetailCommentsListCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIImageView       *avatorImageView;
@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *commentsLabel;
@property (nonatomic, strong) UIView            *lineView;
@end

@implementation ZFCommunityVideoDetailCommentsListCell
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
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.commentsLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(10);
        make.leading.mas_equalTo(self.contentView.mas_leading).mas_offset(10);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.avatorImageView.mas_trailing).mas_offset(8);
        make.centerY.mas_equalTo(self.avatorImageView.mas_centerY);
    }];
    
    [self.commentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).mas_offset(-10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.trailing.mas_equalTo(self.contentView);
        make.leading.mas_equalTo(self.nameLabel.mas_leading);
    }];
}

#pragma mark - setter


#pragma mark - getter
- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatorImageView.contentMode = UIViewContentModeScaleToFill;
        _avatorImageView.clipsToBounds = YES;
        _avatorImageView.userInteractionEnabled = YES;
        _avatorImageView.layer.cornerRadius = 20.0;
    }
    return _avatorImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _nameLabel;
}

- (UILabel *)commentsLabel {
    if (!_commentsLabel) {
        _commentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentsLabel.userInteractionEnabled = YES;
        _commentsLabel.numberOfLines = 0;
        _commentsLabel.font = [UIFont systemFontOfSize:12];
        _commentsLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
    }
    return _commentsLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    }
    return _lineView;
}
@end
