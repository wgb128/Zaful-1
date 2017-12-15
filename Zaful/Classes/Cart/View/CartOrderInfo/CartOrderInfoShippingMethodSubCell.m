//
//  CartOrderInfoShippingMethodSubView.m
//  Dezzal
//
//  Created by 7FD75 on 16/8/8.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "CartOrderInfoShippingMethodSubCell.h"

@interface CartOrderInfoShippingMethodSubCell ()

@property (nonatomic, strong) UILabel *standardShippingLabel;

@property (nonatomic, strong) UILabel *standardAmountLabel;

@property (nonatomic, strong) UILabel *standardPercentLabel;

@end

@implementation CartOrderInfoShippingMethodSubCell

+ (CartOrderInfoShippingMethodSubCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {
    //注册cell
    [tableView registerClass:[CartOrderInfoShippingMethodSubCell class] forCellReuseIdentifier:ORDERINFO_SHIPPINGMETHOD_IDENTIFIER];
    return [tableView dequeueReusableCellWithIdentifier:ORDERINFO_SHIPPINGMETHOD_IDENTIFIER forIndexPath:indexPath];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViewsContraint];
    }
    return self;
}

-(void)setModel:(ShippingListModel *)model{
    
    _model = model;
    if ([SystemConfigUtils isRightToLeftShow]) {
        self.standardShippingLabel.text = [NSString stringWithFormat:@"(%@)%@",model.ship_desc,model.ship_name];
        self.standardPercentLabel.text = [NSString stringWithFormat:@"(%@ %@%%)",ZFLocalizedString(@"CartOrderInfo_ShippingMethodSubCell_Cell_OFF",nil),model.ship_save];
    } else {
        self.standardShippingLabel.text = [NSString stringWithFormat:@"%@(%@)",model.ship_name,model.ship_desc];
        self.standardPercentLabel.text = [NSString stringWithFormat:@"(%@%% %@)",model.ship_save,ZFLocalizedString(@"CartOrderInfo_ShippingMethodSubCell_Cell_OFF",nil)];
    }
    self.standardAmountLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:model.ship_price]];
    
    
    
    self.standardSelectBtn.selected = model.isSelected;
}

- (void)addSubViewsContraint
{
    [self addSubview:self.standardSelectBtn];
    [self.standardSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(5);
        make.size.equalTo(@33);
        make.height.equalTo(@33);
        make.top.offset(30);
    }];
    
    [self addSubview:self.standardShippingLabel];
    [self.standardShippingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.standardSelectBtn.mas_trailing).offset(5);
        make.top.offset(25);
    }];
    
    [self addSubview:self.standardAmountLabel];
    [self.standardAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.standardShippingLabel);
        make.top.equalTo(self.standardShippingLabel.mas_bottom).offset(5);
        make.bottom.offset(0);
    }];
    
    [self addSubview:self.standardPercentLabel];
    [self.standardPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.standardAmountLabel.mas_trailing).offset(3);
        make.centerY.equalTo(self.standardAmountLabel);
    }];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)selectBtnClick:(UIButton *)sender
{
    if (self.changeSeletedStatusBlock && sender.selected == NO) {
        
        sender.selected = YES;
        
        NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
        
        self.changeSeletedStatusBlock(indexPath);
    }
}

-(UIButton *)standardSelectBtn{
    if (!_standardSelectBtn) {
        _standardSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _standardSelectBtn.backgroundColor = [UIColor clearColor];
        [_standardSelectBtn setImage:[UIImage imageNamed:@"order_unchoose"] forState:UIControlStateNormal];
        [_standardSelectBtn setImage:[UIImage imageNamed:@"order_choose"] forState:UIControlStateSelected];
        [_standardSelectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _standardSelectBtn;
}

-(UILabel *)standardShippingLabel{
    if (!_standardShippingLabel) {
        _standardShippingLabel = [[UILabel alloc] init];
        _standardShippingLabel.font = [UIFont systemFontOfSize:14.0];
        _standardShippingLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    }
    return _standardShippingLabel;
}

-(UILabel *)standardAmountLabel{
    if (!_standardAmountLabel) {
        _standardAmountLabel = [[UILabel alloc] init];
        _standardAmountLabel.font = [UIFont systemFontOfSize:14.0];
        _standardAmountLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
    }
    return _standardAmountLabel;
}

-(UILabel *)standardPercentLabel{
    if (!_standardPercentLabel) {
        _standardPercentLabel = [[UILabel alloc] init];
        _standardPercentLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _standardPercentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    }
    return _standardPercentLabel;
}

@end
