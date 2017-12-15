//
//  CategoryRefineToolBar.m
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryRefineToolBar.h"

@interface CategoryRefineToolBar ()
@property (nonatomic, strong) UIButton      *clearButton;
@property (nonatomic, strong) UIButton      *applyButton;
@end

@implementation CategoryRefineToolBar
#pragma mark - Init Method
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubViews];
        [self autoLayoutSubViews];
    }
    return self;
}

#pragma mark - Initialize
- (void)configureSubViews {
    self.backgroundColor = ZFCOLOR(255, 255, 255, 1.f);
    [self addSubview:self.clearButton];
    [self addSubview:self.applyButton];
}

- (void)autoLayoutSubViews {
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.mas_equalTo(self);
        make.width.mas_equalTo((KScreenWidth - 75) / 2);
    }];
    
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(self.clearButton.mas_trailing);
    }];
}

#pragma mark - Target Action
- (void)clearButtonAction:(UIButton *)sender {
    if (self.clearButtonActionCompletionHandle) {
        self.clearButtonActionCompletionHandle();
    }
}

- (void)applyButtonAction:(UIButton *)sender {
    if (self.applyButtonActionCompletionHandle) {
        self.applyButtonActionCompletionHandle();
    }
}

#pragma mark - getter
- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setTitle:ZFLocalizedString(@"GoodsRefine_VC_Clear", nil) forState:UIControlStateNormal];
        _clearButton.backgroundColor = ZFCOLOR(102, 102, 102, 1.f);
        [_clearButton setTitleColor:ZFCOLOR(255, 255, 255, 1.f) forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIButton *)applyButton {
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyButton setTitle:ZFLocalizedString(@"Category_APPLY", nil) forState:UIControlStateNormal];
        _applyButton.backgroundColor = ZFCOLOR(51, 51, 51, 1.f);
        [_applyButton setTitleColor:ZFCOLOR(255, 255, 255, 1.f) forState:UIControlStateNormal];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_applyButton addTarget:self action:@selector(applyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _applyButton;
}


@end
