
//
//  ZFCartPriceOptionView.m
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartPriceOptionView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCartListResultModel.h"
#import "ZFCartGoodsListModel.h"
#import "ZFCartGoodsModel.h"
#import "BigClickAreaButton.h"

@interface ZFCartPriceOptionView () <ZFInitViewProtocol>

@property (nonatomic, strong) UIView                *lineView;
@property (nonatomic, strong) BigClickAreaButton    *selectAllButton;
@property (nonatomic, strong) UILabel               *selectInfoLabel;
@property (nonatomic, strong) UILabel               *totolPriceLabel;
@property (nonatomic, strong) UILabel               *discountPriceLabel;

@end

@implementation ZFCartPriceOptionView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods 
- (void)selectAllButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.cartSelctAllGoodsCompletionHandler) {
        [self.selectAllButton.layer addAnimation:[self createSelectAllOptionAnimation] forKey:@"kSelectAllAnimationIndentifier"];
        self.cartSelctAllGoodsCompletionHandler(sender.selected);
    }
}

#pragma mark - private methods
- (CAKeyframeAnimation *)createSelectAllOptionAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1.0), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.8), @(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.lineView];
    [self addSubview:self.selectAllButton];
    [self addSubview:self.selectInfoLabel];
    [self addSubview:self.totolPriceLabel];
    [self addSubview:self.discountPriceLabel];
    
}

- (void)zfAutoLayoutView {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(12);
        make.top.mas_equalTo(self.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.selectInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.selectAllButton.mas_centerY);
        make.leading.mas_equalTo(self.selectAllButton.mas_trailing).offset(12);
        make.width.mas_equalTo(SCREEN_WIDTH / 2.0);
    }];
    
    [self.totolPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.height.mas_equalTo(24);
    }];
    
    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.totolPriceLabel);
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(self.totolPriceLabel.mas_bottom);
    }];
    
}

#pragma mark - setter
- (void)setModel:(ZFCartListResultModel *)model {
    _model = model;
    NSString *totalAmount = [NSString stringWithFormat:@"%@ %@", ZFLocalizedString(@"Bag_Total", nil), [ExchangeManager transforPrice:_model.totalAmount isRightToLeft:[SystemConfigUtils isRightToLeftShow]]];
    NSMutableAttributedString *totolAttrString = [[NSMutableAttributedString alloc] initWithString:totalAmount attributes:@{NSForegroundColorAttributeName: ZFCOLOR(183, 96, 42, 1.f), NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    [totolAttrString setAttributes:@{NSForegroundColorAttributeName: ZFCOLOR(51, 51, 51, 1.f), NSFontAttributeName: [UIFont boldSystemFontOfSize:16]} range:NSMakeRange(0, ZFLocalizedString(@"Bag_Total", nil).length)];
    self.totolPriceLabel.attributedText = totolAttrString;
    
    __block BOOL isAllSelect = YES;
    __block NSInteger selectItems = 0;
    [_model.goodsBlockList enumerateObjectsUsingBlock:^(ZFCartGoodsListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.goodsModuleType integerValue] == ZFCartListBlocksTypeUnavailable) {
            *stop = YES;
            return ;
        }
        [obj.cartList enumerateObjectsUsingBlock:^(ZFCartGoodsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.is_selected == NO) {
                isAllSelect = NO;
            } else {
                selectItems += obj.buy_number;
            }
        }];
    }];
    if (isAllSelect) {
        self.selectInfoLabel.text = ZFLocalizedString(@"CartSelectAllItemsTips", nil);
    } else {
        if (selectItems <= 0) {
            self.selectInfoLabel.text = ZFLocalizedString(@"CartSelectAllTips", nil);
        } else {
            self.selectInfoLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"CartSelectItemsTips", nil), selectItems];
        }
        
    }
    self.selectAllButton.selected = (_model.goodsBlockList && (_model.goodsBlockList.count > 0) && isAllSelect);
    
    if ([_model.discountAmount floatValue] > 0.00) {
        self.discountPriceLabel.hidden = NO;
        self.discountPriceLabel.text = [NSString stringWithFormat:@"%@ %@", ZFLocalizedString(@"Bag_Discount_Tips", nil), [ExchangeManager transforPrice:_model.discountAmount isRightToLeft:[SystemConfigUtils isRightToLeftShow]]];
        [self.totolPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(1);
            make.height.mas_equalTo(24);
        }];
    } else {
        [self.totolPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.height.mas_equalTo(24);
        }];
        self.discountPriceLabel.hidden = YES;
    }
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.f);
    }
    return _lineView;
}

- (BigClickAreaButton *)selectAllButton {
    if (!_selectAllButton) {
        _selectAllButton = [BigClickAreaButton buttonWithType:UIButtonTypeCustom];
        _selectAllButton.clickAreaRadious = 45;
        [_selectAllButton setImage:[UIImage imageNamed:@"default_no"] forState:UIControlStateNormal];
        [_selectAllButton setImage:[UIImage imageNamed:@"default_ok"] forState:UIControlStateSelected];
        [_selectAllButton addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

- (UILabel *)selectInfoLabel {
    if (!_selectInfoLabel) {
        _selectInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectInfoLabel.textColor = ZFCOLOR(51, 51, 51, 1.f);
        _selectInfoLabel.numberOfLines = 2;
        _selectInfoLabel.font = [UIFont systemFontOfSize:14];
        _selectInfoLabel.text = ZFLocalizedString(@"CartSelectAllTips", nil);
    }
    return _selectInfoLabel;
}

- (UILabel *)totolPriceLabel {
    if (!_totolPriceLabel) {
        _totolPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totolPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totolPriceLabel;
}

- (UILabel *)discountPriceLabel {
    if (!_discountPriceLabel) {
        _discountPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _discountPriceLabel.textColor = ZFCOLOR(153, 153, 153, 1.f);
        _discountPriceLabel.font = [UIFont systemFontOfSize:12];
        _discountPriceLabel.textAlignment = NSTextAlignmentRight;
        _discountPriceLabel.hidden = YES;
    }
    return _discountPriceLabel;
}

@end
