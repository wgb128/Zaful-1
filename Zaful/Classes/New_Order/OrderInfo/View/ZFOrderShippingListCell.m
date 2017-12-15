//
//  ZFOrderShippingListCell.m
//  Zaful
//
//  Created by TsangFa on 19/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderShippingListCell.h"
#import "ZFInitViewProtocol.h"
#import "FilterManager.h"
#import "ShippingListModel.h"

@interface ZFOrderShippingListCell()<ZFInitViewProtocol>
@property (nonatomic, strong) UIButton              *selectButton;
@property (nonatomic, strong) UILabel               *infoLabel;
@property (nonatomic, strong) UILabel               *amountLabel;
@property (nonatomic, strong) UILabel               *percentLabel;
@end

@implementation ZFOrderShippingListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Setter
- (void)setIsChoose:(BOOL)isChoose {
    _isChoose = isChoose;
    self.selectButton.selected = isChoose;
}

- (void)setShippingListModel:(ShippingListModel *)shippingListModel {
    _shippingListModel = shippingListModel;
     self.infoLabel.text = [NSString stringWithFormat:@"%@(%@)",shippingListModel.ship_name,shippingListModel.ship_desc];
     self.percentLabel.text = [NSString stringWithFormat:@"(%@%% %@)",shippingListModel.ship_save,ZFLocalizedString(@"CartOrderInfo_ShippingMethodSubCell_Cell_OFF",nil)];
    self.amountLabel.text = [FilterManager adapterCodWithAmount:shippingListModel.ship_price andCod:self.isCod];
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.percentLabel];
}

- (void)zfAutoLayoutView {
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(12);
        make.centerY.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.selectButton.mas_trailing).offset(12);
        make.top.equalTo(self.contentView).offset(12);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.infoLabel.mas_leading);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(2);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.amountLabel.mas_trailing).offset(2);
        make.centerY.equalTo(self.amountLabel);
    }];
}


#pragma mark - Getter
- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        _selectButton.userInteractionEnabled = NO;
    }
    return _selectButton;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = ZFCOLOR(153, 153, 153, 1);
    }
    return _infoLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.font = [UIFont systemFontOfSize:14];
        _amountLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _amountLabel;
}

- (UILabel *)percentLabel {
    if (!_percentLabel) {
        _percentLabel = [[UILabel alloc] init];
        _percentLabel.font = [UIFont boldSystemFontOfSize:14];
        _percentLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _percentLabel;
}
@end
