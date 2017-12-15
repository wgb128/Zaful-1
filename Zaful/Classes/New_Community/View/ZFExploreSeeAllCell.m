

//
//  ZFExploreSeeAllCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFExploreSeeAllCell.h"
#import "ZFInitViewProtocol.h"

@interface ZFExploreSeeAllCell () <ZFInitViewProtocol>
@property (nonatomic, strong) UIButton          *seeAllButton;
@end

@implementation ZFExploreSeeAllCell
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
- (void)seeAllButtonAction:(UIButton *)sender {
    if (self.exploreSeeAllCompletionHandler) {
        self.exploreSeeAllCompletionHandler();
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.seeAllButton];
}

- (void)zfAutoLayoutView {
    [self.seeAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(90);
    }];
}

#pragma mark - getter
- (UIButton *)seeAllButton {
    if (!_seeAllButton) {
        _seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeAllButton addTarget:self action:@selector(seeAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _seeAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_seeAllButton setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [_seeAllButton setTitle:ZFLocalizedString(@"SeeAllCell_SeeAll",nil) forState:UIControlStateNormal];
        _seeAllButton.backgroundColor = ZFCOLOR(246, 246, 246, 1.0);
    }
    return _seeAllButton;
}
@end
