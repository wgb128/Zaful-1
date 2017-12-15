//
//  ZFMyCouponTableViewCell.m
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFMyCouponTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFMyCouponModel.h"
#import "ZFCouponTipView.h"

@interface ZFMyCouponTableViewCell() <ZFInitViewProtocol> {
    ZFMyCouponModel *_couponModel;
}

@property (nonatomic, strong) UIImageView   *contentImageView;
@property (nonatomic, strong) UILabel       *codeLabel;
@property (nonatomic, strong) UILabel       *dateLabel;
@property (nonatomic, strong) UILabel       *expiresLabel;
@property (nonatomic, strong) UIImageView   *selectedImageView;
@property (nonatomic, strong) UIButton      *tagBtn;
@property (nonatomic, strong) UIButton      *tipButton;
@property (nonatomic, strong) ZFCouponTipView *tipView;
@property (nonatomic, strong) UILabel       *tipLabel;

@end

@implementation ZFMyCouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

+ (ZFMyCouponTableViewCell *)couponItemCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[ZFMyCouponTableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)configWithModel:(ZFMyCouponModel *)model {
    _couponModel = model;
    self.codeLabel.text = model.preferential_head;
    self.dateLabel.text = model.exp_time;
    self.expiresLabel.text = model.preferential_first;
    
    UIImage *contentImage = [UIImage imageNamed:@"coupon_bg"];
    contentImage = [contentImage resizableImageWithCapInsets:UIEdgeInsetsMake(65.0f, 20.0f, 80.0f, -5.0f) resizingMode:UIImageResizingModeStretch];
    self.contentImageView.image = contentImage;
    
    NSMutableString *youHuiString = [[NSMutableString alloc] initWithString:model.preferential_all];
    NSArray *youhuiArray = [youHuiString componentsSeparatedByString:@","];
    if (model.isShowAll && youhuiArray.count > 1) {
        [youHuiString replaceOccurrencesOfString:@"," withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, youHuiString.length)];
        self.expiresLabel.text   = youHuiString;
        [self showAll];
    } else {
        self.expiresLabel.text   = model.preferential_first;
        [self hiddenAll];
    }
    
    switch (self.couponType) {
        case CouponAvailable: {
            self.tagBtn.hidden            = youhuiArray.count < 2;
            self.codeLabel.textColor      = ZFCOLOR(51, 51, 51, 1.0);
            self.expiresLabel.textColor   = ZFCOLOR(51, 51, 51, 1.0);
            self.tipButton.hidden         = YES;
            self.selectedImageView.hidden = !model.isSelected;
            break;
        }
            
        case CouponDisabled: {
            self.tagBtn.hidden            = youhuiArray.count < 2;
            self.codeLabel.textColor      = ZFCOLOR(153, 153, 153, 1.0);
            self.expiresLabel.textColor   = ZFCOLOR(153, 153, 153, 1.0);
            self.tipButton.hidden         = NO;
            self.selectedImageView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

#pragma mark - ZFInitViewProtoclo
- (void)zfInitView {
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView addSubview:self.codeLabel];
    [self.contentImageView addSubview:self.dateLabel];
    [self.contentImageView addSubview:self.expiresLabel];
    [self.contentImageView addSubview:self.selectedImageView];
    [self.contentImageView addSubview:self.tagBtn];
    [self.contentImageView addSubview:self.tipButton];
    [self.contentImageView addSubview:self.tipView];
    [self.tipView addSubview:self.tipLabel];
}

- (void)zfAutoLayoutView {
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(0.0f);
        make.leading.mas_equalTo(self.contentView.mas_leading).offset(15.0f);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-15.0f);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(- 15.0f);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_top).offset(20.0);
        make.leading.mas_equalTo(self.contentImageView.mas_leading).offset(20.0);
        make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-20.0f);
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
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentImageView.mas_top).offset(1.0f);
        if ([SystemConfigUtils isRightToLeftShow]) {
            make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(0.0f);
        } else {
            make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-5.0f);
        }
        make.width.height.mas_equalTo(41.0f);
    }];
    
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeLabel.mas_top);
        make.trailing.mas_equalTo(self.contentImageView.mas_trailing).offset(-20.0f);
        make.width.height.mas_equalTo(35.0f);
    }];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.tipButton.mas_leading).offset(-5.0f);
        make.width.mas_lessThanOrEqualTo(self.contentImageView.mas_width).offset(- 70.0f * SCREEN_WIDTH_SCALE);
        make.width.mas_greaterThanOrEqualTo(44.0f);
        make.centerY.mas_equalTo(self.tipButton.mas_centerY);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipView.mas_top).offset(10.0f);
        make.leading.mas_equalTo(self.tipView.mas_leading).offset(10.0f);
        make.trailing.mas_equalTo(self.tipView.mas_trailing).offset(-15.0f);
        make.bottom.mas_equalTo(self.tipView.mas_bottom).offset(-10.0f);
    }];
}

#pragma mark - event
- (void)tipButtonAction {
    if (_couponModel.pcode_msg.length > 0) {
        self.tipButton.selected = !self.tipButton.selected;
        self.tipView.hidden = !self.tipButton.isSelected;
        self.tipLabel.text = _couponModel.pcode_msg;
        [self.tipView setNeedsDisplay];
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

#pragma mark - setter/getter
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView                 = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor clearColor];
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

- (UILabel *)expiresLabel {
    if (!_expiresLabel) {
        _expiresLabel = [[UILabel alloc] init];
        _expiresLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
        _expiresLabel.font = [UIFont systemFontOfSize:11.0];
        _expiresLabel.numberOfLines = 0;
    }
    return _expiresLabel;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.backgroundColor = [UIColor clearColor];
        NSString *imageName =  [SystemConfigUtils isRightToLeftShow] ? @"order_coupon_choosed_ar" :  @"order_coupon_choosed";
        _selectedImageView.image = [UIImage imageNamed:imageName];
    }
    return _selectedImageView;
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

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipButton setImage:[UIImage imageNamed:@"order_coupon_tip"] forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(tipButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

- (ZFCouponTipView *)tipView {
    if (!_tipView) {
        _tipView = [[ZFCouponTipView alloc] init];
        _tipView.hidden = YES;
    }
    return _tipView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel               = [[UILabel alloc] init];
        _tipLabel.textColor     = [UIColor whiteColor];
        _tipLabel.font          = [UIFont systemFontOfSize:14.0];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

@end
