//
//  CartInfoShippingView.m
//  OrderInfoTest
//
//  Created by zhaowei on 2017/3/1.
//  Copyright © 2017年 share. All rights reserved.
//

#import "CartInfoShippingView.h"
#import "FilterManager.h"

@interface CartInfoShippingView ()
@property (nonatomic, strong) RadioButton *radioButton;

@property (nonatomic, strong) UILabel *introLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *percentLabel;
@end

@implementation CartInfoShippingView


- (void)setModel:(ShippingListModel *)model {
    
    _model = model;
    self.introLabel.text = [NSString stringWithFormat:@"%@(%@)",model.ship_name,model.ship_desc];;
    
    self.percentLabel.text = [NSString stringWithFormat:@"(%@%% %@)",model.ship_save,ZFLocalizedString(@"CartOrderInfo_ShippingMethodSubCell_Cell_OFF",nil)];
    [self.radioButton setChecked:[model.default_select boolValue]];
    
    if ([FilterManager tempCOD] && ![NSStringUtils isEmptyString:[FilterManager tempCurrency]]) {
        self.amountLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:model.ship_price currency:[FilterManager tempCurrency]]];
    }else{
        self.amountLabel.text = [NSString stringWithFormat:@"%@",[ExchangeManager transforPrice:model.ship_price]];
    }

}

- (instancetype)initWithFrame:(CGRect)frame index:(NSUInteger)index  {
    if (self = [super initWithFrame:frame]) {
        
        self.radioButton = [[RadioButton alloc] initWithGroupId:@"shipping" index:index normalImage:[UIImage imageNamed:@"order_unchoose"] selectedImage:[UIImage imageNamed:@"order_choose"]];
                
        
        self.radioButton.clickAreaRadious = 40;
        
        [self addSubview:self.radioButton];
        [self.radioButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.leading.mas_equalTo(self.mas_leading).offset(13);
            make.width.height.mas_equalTo(@(20));
        }];
        
        self.introLabel = [[UILabel alloc] init];
        self.introLabel.font = [UIFont systemFontOfSize:14];
        self.introLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
       
        [self addSubview:self.introLabel];
        [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.radioButton.mas_trailing).offset(5);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.top.mas_equalTo(self.mas_top).offset(24);
        }];
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.font = [UIFont systemFontOfSize:14];
        self.amountLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
       
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.introLabel.mas_leading);
            make.top.mas_equalTo(self.introLabel.mas_bottom).offset(8);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        self.percentLabel = [[UILabel alloc] init];
        self.percentLabel.font = [UIFont boldSystemFontOfSize:14];
        self.percentLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
       

        [self addSubview:self.percentLabel];
        [self.percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.amountLabel.mas_trailing).offset(3);
            make.centerY.mas_equalTo(self.amountLabel.mas_centerY);
        }];
        
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceEvent:)]];
    }
    return self;
}

-(void)choiceEvent:(UITapGestureRecognizer *)gestureRecognizer{
    [self.radioButton handleButtonTap:nil];
}

@end
