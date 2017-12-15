
//
//  ZFAddressEditSetDefaultTableViewCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/31.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressEditSetDefaultTableViewCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressInfoModel.h"

@interface ZFAddressEditSetDefaultTableViewCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIView            *layoutView;
@property (nonatomic, strong) UIButton          *selectButton;
@property (nonatomic, strong) UILabel           *defaulLabel;
@end

@implementation ZFAddressEditSetDefaultTableViewCell
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)selectButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.addressEditSetDefaultCompeltionHandler) {
        self.addressEditSetDefaultCompeltionHandler(sender.selected);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self.contentView addSubview:self.layoutView];
    [self.layoutView addSubview:self.selectButton];
    [self.layoutView addSubview:self.defaulLabel];
}

- (void)zfAutoLayoutView {
    [self.layoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.leading.mas_equalTo(self.layoutView);
    }];
    
    [self.defaulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.mas_equalTo(self.layoutView);
        make.leading.mas_equalTo(self.selectButton.mas_trailing).offset(8);
    }];
}

#pragma mark - setter
- (void)setModel:(ZFAddressInfoModel *)model {
    _model = model;
    self.selectButton.selected = _model.is_default;

}


#pragma mark - getter
- (UIView *)layoutView {
    if (!_layoutView) {
        _layoutView = [[UIView alloc] initWithFrame:CGRectZero];
        _layoutView.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    }
    return _layoutView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UILabel *)defaulLabel {
    if (!_defaulLabel) {
        _defaulLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _defaulLabel.font = [UIFont systemFontOfSize:14];
        _defaulLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _defaulLabel.text = ZFLocalizedString(@"ModifyAddress_Set_Default", nil);
    }
    return _defaulLabel;
}

@end
