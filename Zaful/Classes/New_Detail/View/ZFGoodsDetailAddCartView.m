//
//  ZFGoodsDetailAddCartView.m
//  Zaful
//
//  Created by liuxi on 2017/11/20.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFGoodsDetailAddCartView.h"
#import "ZFInitViewProtocol.h"
#import "JSBadgeView.h"
#import "UIView+GBGesture.h"

@interface ZFGoodsDetailAddCartView() <ZFInitViewProtocol>
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIButton          *cartButton;
@property (nonatomic, strong) UIButton          *addCartButton;
@property (nonatomic, strong) JSBadgeView       *badgeView;
@end

@implementation ZFGoodsDetailAddCartView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self changeCartNumberInfo];
    }
    return self;
}

#pragma mark - interface methods
- (void)changeCartNumberInfo {
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCollectionBadgeKey];
    NSString * numberIndex = @"";
    if ([badgeNum integerValue] == 0) {
        self.badgeView.badgeText = nil;
        return;
    }
    if ([badgeNum integerValue]>99) {
        numberIndex = @"99+";
    } else {
        numberIndex = [NSString stringWithFormat:@"%ld",(long)[badgeNum integerValue]];
    }
    self.badgeView.badgeText = numberIndex;
}

#pragma mark - action methods
- (void)cartButtonAction:(UIButton *)sender {
    if (self.cartButtonCompletionHandler) {
        self.cartButtonCompletionHandler();
    }
}

- (void)addCartButtonAction:(UIButton *)sender {
    if (self.addCartButtonCompletionHandler) {
        self.addCartButtonCompletionHandler();
    }
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cartButton];
    [self addSubview:self.addCartButton];
    [self addSubview:self.lineView];
}

- (void)zfAutoLayoutView {
    
    
    [self.cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(120);
    }];
    
    [self.addCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(self.cartButton.mas_trailing);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - setter
- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    if (![_model.is_on_sale boolValue] || self.model.goods_number <= 0) {
        //下架，没有货
        self.addCartButton.backgroundColor = ZFCOLOR(135, 135, 135, 1.f);
        self.addCartButton.enabled = NO;
    } else {
        self.addCartButton.backgroundColor = ZFCOLOR_BLACK;
        self.addCartButton.enabled = YES;
    }
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1);
    }
    return _lineView;
}

- (UIButton *)cartButton {
    if (!_cartButton) {
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cartButton setImage:[UIImage imageNamed:@"shopping_bag"] forState:UIControlStateNormal];
        [_cartButton addTarget:self action:@selector(cartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartButton;
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc]initWithParentView:self.cartButton alignment:JSBadgeViewAlignmentCenter];
        _badgeView.badgePositionAdjustment = [SystemConfigUtils isRightToLeftShow] ? CGPointMake(-10, -10) : CGPointMake(10, -10);
        _badgeView.badgeBackgroundColor = BADGE_BACKGROUNDCOLOR;
        _badgeView.userInteractionEnabled = YES;
        @weakify(self);
        [_badgeView addTapGestureWithComplete:^(UIView * _Nonnull view) {
            @strongify(self);
            [self cartButtonAction:nil];
        }];
    }
    return _badgeView;
}

- (UIButton *)addCartButton {
    if (!_addCartButton) {
        _addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addCartButton.backgroundColor = ZFCOLOR_BLACK;
        [_addCartButton setTitle:ZFLocalizedString(@"Detail_Product_AddToBag", nil) forState:UIControlStateNormal];
        [_addCartButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateNormal];
        [_addCartButton setTitle:ZFLocalizedString(@"Detail_Product_OutOfStock", nil) forState:UIControlStateDisabled];
        [_addCartButton setTitleColor:ZFCOLOR_WHITE forState:UIControlStateDisabled];
        [_addCartButton addTarget:self action:@selector(addCartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCartButton;
}
@end
