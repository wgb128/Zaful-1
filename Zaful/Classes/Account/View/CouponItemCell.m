//
//  CouponItemCell.m
//  Zaful
//
//  Created by zhaowei on 2017/6/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CouponItemCell.h"
#import "CouponItemModel.h"
#import "ZFInitViewProtocol.h"

@interface CouponItemCell () <ZFInitViewProtocol> {
}

@property (nonatomic, strong) UIImageView   *contentImageView;
@property (nonatomic, strong) UILabel       *codeLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *expiresLabel;
@property (nonatomic, strong) UIButton      *userItBtn;
@property (nonatomic, strong) UIButton      *tagBtn;
@property (nonatomic, strong) UIImageView   *tagImageView;

@end

@implementation CouponItemCell

#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - interface methods
+ (CouponItemCell *)couponItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CouponItemCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.userItBtn];
    [self.contentImageView addSubview:self.codeLabel];
    [self.contentImageView addSubview:self.dateLabel];
    [self.contentImageView addSubview:self.expiresLabel];
    [self.contentImageView addSubview:self.tagBtn];
    [self.contentImageView addSubview:self.tagImageView];
}

- (void)zfAutoLayoutView {
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(0.0f);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(15.0f);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-15.0f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.userItBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_top).offset(20.0f);
        make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-15.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(32.0f);
    }];
    self.userItBtn.layer.cornerRadius  = 16.0;
    self.userItBtn.layer.masksToBounds = YES;

    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_top).offset(20.0);
        make.leading.mas_equalTo(self.contentImageView.mas_leading).offset(20.0);
        make.trailing.mas_equalTo(self.userItBtn.mas_leading).offset(15.0f);
    }];

    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeLabel.mas_bottom).offset(5.0f);
        make.leading.mas_equalTo(self.codeLabel.mas_leading);
        make.trailing.mas_equalTo(self.codeLabel.mas_trailing);
    }];

    [self.expiresLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(15.0f);
        make.leading.mas_equalTo(self.codeLabel.mas_leading);
        make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-20.0f);
        make.bottom.mas_equalTo(self.contentImageView.mas_bottom).offset(-10.0f);
    }];
    
    [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-10.0f);
        make.height.mas_equalTo(32.0f);
        make.width.mas_equalTo(32.0f);
        make.top.mas_equalTo(self.expiresLabel.mas_top).offset(-5.0f);
    }];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(65.0f);
        if ([SystemConfigUtils isRightToLeftShow]) {
            make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(0.0f);
        } else {
            make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-5.0f);
        }
        make.bottom.mas_equalTo(self.contentImageView.mas_bottom).offset(-1.0f);
    }];
}

#pragma mark - event
- (void)userItAction {
    if (self.userItActionHandle) {
        self.userItActionHandle();
    }
}

- (void)tagBtnAction {
    if (self.tagBtnActionHandle) {
        self.tagBtnActionHandle();
        self.tagBtn.selected = !self.tagBtn.selected;
        if (self.tagBtn.isSelected) {
            [self showAll];
        } else {
            [self hiddenAll];
        }
    }
}

- (void)showAll {
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI);
        [self.tagBtn.imageView setTransform:transform];
    }];
}

- (void)hiddenAll {
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = CGAffineTransformIdentity;
        [self.tagBtn.imageView setTransform:transform];
    }];
}

#pragma mark - setter
-(void)setCouponModel:(CouponItemModel *)couponModel {
    _couponModel = couponModel;
    self.codeLabel.text      = couponModel.preferential_head;
    self.dateLabel.text      = couponModel.exp_time;
    
    UIImage *contentImage       = [UIImage imageNamed:@"coupon_bg"];
    contentImage = [contentImage resizableImageWithCapInsets:UIEdgeInsetsMake(65.0f, 20.0f, 80.0f, -5.0f) resizingMode:UIImageResizingModeStretch];
    self.contentImageView.image = contentImage;
    
    NSMutableString *youHuiString = [[NSMutableString alloc] initWithString:couponModel.youhui];
    NSArray *youhuiArray = [youHuiString componentsSeparatedByString:@","];
    if (couponModel.isShowAll && youhuiArray.count > 1) {
        [youHuiString replaceOccurrencesOfString:@"," withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, youHuiString.length)];
        self.expiresLabel.text   = youHuiString;
        [self showAll];
    } else {
        self.expiresLabel.text   = couponModel.preferential_first;
        [self hiddenAll];
    }
    
    self.tagImageView.hidden    = NO;
    self.tagBtn.hidden          = YES;
    self.userItBtn.hidden       = YES;
    self.codeLabel.textColor    = ZFCOLOR(153, 153, 153, 1.0);
    self.dateLabel.textColor    = ZFCOLOR(179, 179, 179, 1.0);
    self.expiresLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
    switch (self.couponType) {
        case CouponUsed: {
            self.tagImageView.image  = [UIImage imageNamed:ZFLocalizedString(@"mine_coupon_used_imagename", nil)];
            break;
        }
        case CouponExpired: {
            self.tagImageView.image  = [UIImage imageNamed:ZFLocalizedString(@"mine_coupon_expired_imagename", nil)];
            break;
        }
        case CouponUnused: {
            self.tagBtn.hidden       = youhuiArray.count < 2;
            self.tagImageView.hidden = YES;
            self.userItBtn.hidden    = NO;
            self.codeLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
            self.dateLabel.textColor = couponModel.is_72_expiring ? ZFCOLOR(255, 168, 0, 1.0) : ZFCOLOR(51, 51, 51, 1.0);
            break;
        }
        default:
            break;
    }
}


#pragma mark - getter
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView                        = [[UIImageView alloc] init];
        _contentImageView.backgroundColor        = [UIColor clearColor];
        _contentImageView.userInteractionEnabled = YES;
    }
    return _contentImageView;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _codeLabel.font = [UIFont boldSystemFontOfSize:14.0];
    }
    return _codeLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = ZFCOLOR(179, 179, 179, 1.0);   // 高亮 ZFCOLOR(255, 168, 0, 1.0)
        _dateLabel.font = [UIFont systemFontOfSize:11.0];
    }
    return _dateLabel;
}

- (UIButton *)userItBtn {
    if (!_userItBtn) {
        _userItBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _userItBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _userItBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_userItBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _userItBtn.backgroundColor = ZFCOLOR(255, 168, 0, 1.0);
        [_userItBtn setTitle:ZFLocalizedString(@"My_Coupon_UserIt", nil) forState:UIControlStateNormal];
        [_userItBtn addTarget:self action:@selector(userItAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userItBtn;
}

- (UIButton *)tagBtn {
    if (!_tagBtn) {
        _tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tagBtn.backgroundColor = [UIColor clearColor];
        _tagBtn.hidden = YES;
        [_tagBtn setImage:[UIImage imageNamed:@"mine_coupon_arrow"] forState:UIControlStateNormal];
        [_tagBtn addTarget:self action:@selector(tagBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tagBtn;
}

- (UILabel *)expiresLabel {
    if (!_expiresLabel) {
        _expiresLabel = [[UILabel alloc] init];
        _expiresLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _expiresLabel.font = [UIFont systemFontOfSize:11.0];
        _expiresLabel.numberOfLines = 0;
    }
    return _expiresLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.backgroundColor = [UIColor clearColor];
    }
    return _tagImageView;
}

@end
