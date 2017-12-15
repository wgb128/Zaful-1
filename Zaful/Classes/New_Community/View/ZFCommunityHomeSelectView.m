
//
//  ZFCommunityHomeSelectView.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityHomeSelectView.h"
#import "ZFInitViewProtocol.h"

@interface ZFCommunityHomeSelectView () <ZFInitViewProtocol>

@property (nonatomic, strong) UIButton              *outfitsButton;
@property (nonatomic, strong) UIButton              *exploreButton;
@property (nonatomic, strong) UIButton              *favesButton;
@property (nonatomic, strong) UIView                *selectUnderLineView;
@end

@implementation ZFCommunityHomeSelectView

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        self.currentType = ZFCommunityHomeSelectTypeExplore;
    }
    return self;
}

#pragma mark - action methods
- (void)communityHomeSelectButtonAction:(UIButton *)sender {
    
    if (sender.tag == ZFCommunityHomeSelectTypeFaves && ![AccountManager sharedManager].isSignIn) {
        if (self.communityLoginTipsCompletionHandler) {
            self.communityLoginTipsCompletionHandler();
            return ;
        }
    }
    
    if (self.currentType == sender.tag) {
        return ;
    }
    //self.currentType = sender.tag;
    
    if (self.communityHomeSelectCompletionHandler) {
        //此处传值需要用self.currentType 替代_currentType, 后者容易导致内存泄漏崩溃。
        self.communityHomeSelectCompletionHandler(sender.tag);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.exploreButton];
    [self addSubview:self.outfitsButton];
    [self addSubview:self.favesButton];
    [self addSubview:self.selectUnderLineView];
}

- (void)zfAutoLayoutView {
    [self.exploreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.outfitsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(self.exploreButton.mas_trailing);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.favesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(self.outfitsButton.mas_trailing);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.selectUnderLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(32);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(self.exploreButton.mas_centerX);
    }];
}

#pragma mark - setter
- (void)setCurrentType:(ZFCommunityHomeSelectType)currentType {

    self.outfitsButton.selected = NO;
    self.exploreButton.selected = NO;
    self.favesButton.selected = NO;
    _currentType = currentType;
    //根据选中，改变按钮样式， 以及选中下划线位置。
    switch (_currentType) {
        case ZFCommunityHomeSelectTypeOutfits: {
            self.outfitsButton.selected = YES;
            [self.selectUnderLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(32);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.height.mas_equalTo(2);
                make.centerX.mas_equalTo(self.outfitsButton.mas_centerX);
            }];
        }
            break;
            
        case ZFCommunityHomeSelectTypeExplore: {
            self.exploreButton.selected = YES;
            [self.selectUnderLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(32);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.height.mas_equalTo(2);
                make.centerX.mas_equalTo(self.exploreButton.mas_centerX);
            }];
        }
            break;
            
        case ZFCommunityHomeSelectTypeFaves: {
            self.favesButton.selected = YES;
            [self.selectUnderLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(32);
                make.bottom.mas_equalTo(self.mas_bottom);
                make.height.mas_equalTo(2);
                make.centerX.mas_equalTo(self.favesButton.mas_centerX);
            }];
        }
            break;
    }
    
}
#pragma mark - getter
- (UIButton *)outfitsButton {
    if (!_outfitsButton) {
        _outfitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outfitsButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Outfits", nil) forState:UIControlStateNormal];
        [_outfitsButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Outfits", nil) forState:UIControlStateSelected];
        [_outfitsButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateSelected];
        [_outfitsButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _outfitsButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _outfitsButton.tag = ZFCommunityHomeSelectTypeOutfits;
        [_outfitsButton addTarget:self action:@selector(communityHomeSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outfitsButton;
}

- (UIButton *)exploreButton {
    if (!_exploreButton) {
        _exploreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exploreButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Explore", nil) forState:UIControlStateNormal];
        [_exploreButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Explore", nil) forState:UIControlStateSelected];
        [_exploreButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateSelected];
        [_exploreButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _exploreButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _exploreButton.tag = ZFCommunityHomeSelectTypeExplore;
        _exploreButton.selected = YES;
        [_exploreButton addTarget:self action:@selector(communityHomeSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exploreButton;
}

- (UIButton *)favesButton {
    if (!_favesButton) {
        _favesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favesButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Faves", nil) forState:UIControlStateNormal];
        [_favesButton setTitle:ZFLocalizedString(@"Community_Tab_Title_Faves", nil) forState:UIControlStateSelected];
        [_favesButton setTitleColor:ZFCOLOR(51, 51, 51, 1.f) forState:UIControlStateSelected];
        [_favesButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _favesButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _favesButton.tag = ZFCommunityHomeSelectTypeFaves;
        [_favesButton addTarget:self action:@selector(communityHomeSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favesButton;
}

- (UIView *)selectUnderLineView {
    if (!_selectUnderLineView) {
        _selectUnderLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectUnderLineView.backgroundColor = ZFCOLOR(0, 0, 0, 1.f);
    }
    return _selectUnderLineView;
}

@end
