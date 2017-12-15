//
//  ZFOrderAmountDetailCell.m
//  Zaful
//
//  Created by TsangFa on 21/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFOrderAmountDetailCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFOrderAmountDetailModel.h"

@interface ZFOrderAmountDetailCell ()<ZFInitViewProtocol>
@property (nonatomic, strong) UILabel   *amountNameLabel;
@property (nonatomic, strong) UILabel   *amountValueLabel;
@end

@implementation ZFOrderAmountDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.amountNameLabel.text = nil;
    self.amountValueLabel.text = nil;
    self.amountValueLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    self.amountValueLabel.font = [UIFont systemFontOfSize:14];
}

#pragma mark - Public method
+ (NSString *)queryReuseIdentifier {
    return NSStringFromClass([self class]);
}

#pragma mark - Setter
-(void)setModel:(ZFOrderAmountDetailModel *)model {
    _model = model;
    
    self.amountNameLabel.text = model.name;
    self.amountValueLabel.text = model.value;
    if ([model.name isEqualToString:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_PromotionCodeSaving",nil)] ||
        [model.name isEqualToString:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_RewardsSaving",nil)]) {
        self.amountValueLabel.textColor = ZFCOLOR(183, 96, 42, 1);
    }
    
    if ([model.name isEqualToString:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_TotalPayable",nil)] ||
        [model.name isEqualToString:ZFLocalizedString(@"CartOrderInfo_TotalPrice_Cell_GrandTotal",nil)]) {
        self.amountValueLabel.font = [UIFont boldSystemFontOfSize:14];
    }
}

#pragma mark - ZFInitViewProtocol
- (void)zfInitView {
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.contentView.backgroundColor = ZFCOLOR(255, 255, 255, 1);
    [self.contentView addSubview:self.amountNameLabel];
    [self.contentView addSubview:self.amountValueLabel];
}

- (void)zfAutoLayoutView {
    [self.amountNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(12);
        make.bottom.mas_equalTo(self.contentView).offset(-12);
        make.leading.mas_equalTo(self.contentView).offset(12);
    }];
    
    [self.amountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.amountNameLabel);
        make.trailing.mas_equalTo(self.contentView.mas_trailing).offset(-12);
    }];
}

#pragma mark - Getter
- (UILabel *)amountNameLabel {
    if (!_amountNameLabel) {
        _amountNameLabel = [[UILabel alloc] init];
        _amountNameLabel.font = [UIFont systemFontOfSize:14];
        _amountNameLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _amountNameLabel;
}

- (UILabel *)amountValueLabel {
    if (!_amountValueLabel) {
        _amountValueLabel = [[UILabel alloc] init];
        _amountValueLabel.font = [UIFont systemFontOfSize:14];
        _amountValueLabel.textColor = ZFCOLOR(51, 51, 51, 1);
    }
    return _amountValueLabel;
}



@end
