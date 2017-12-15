//
//  ZFCommunityAccountSelectView.m
//  Zaful
//
//  Created by liuxi on 2017/8/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityAccountSelectView.h"
#import "ZFInitViewProtocol.h"



@interface ZFCommunityAccountSelectView () <ZFInitViewProtocol>
@property (nonatomic, strong) UIButton              *showButton;
@property (nonatomic, strong) UIButton              *outfitsButton;
@property (nonatomic, strong) UIButton              *likeButton;
@property (nonatomic, strong) UIView                *selectLineView;
@end

@implementation ZFCommunityAccountSelectView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - action methods
- (void)communityAccountSelectButtonAction:(UIButton *)sender {
    if (self.currentType == sender.tag) {
        return ;
    }
    
    if (self.communityAccountSelectCompletionHandler) {
        self.communityAccountSelectCompletionHandler(sender.tag);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR_WHITE;
    [self addSubview:self.showButton];
    [self addSubview:self.outfitsButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.selectLineView];
}

- (void)zfAutoLayoutView {
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.outfitsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.leading.mas_equalTo(self.showButton.mas_trailing);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.mas_equalTo(self);
        make.leading.mas_equalTo(self.outfitsButton.mas_trailing);
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
    }];
    
    [self.selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(self.showButton.mas_centerX);
    }];

}

#pragma mark - setter
- (void)setCurrentType:(ZFCommunityAccountSelectType)currentType {
    self.outfitsButton.selected = NO;
    self.likeButton.selected = NO;
    self.showButton.selected = NO;
    _currentType = currentType;
    UIButton *selectButton;
    //根据选中，改变按钮样式， 以及选中下划线位置。
    switch (_currentType) {
        case ZFCommunityAccountSelectTypeOutfits:
            self.outfitsButton.selected = YES;
            selectButton = self.outfitsButton;
            break;
            
        case ZFCommunityAccountSelectTypeShow:
            self.showButton.selected = YES;
            selectButton = self.showButton;
            break;
            
        case ZFCommunityAccountSelectTypeLike:
            self.likeButton.selected = YES;
            selectButton = self.likeButton;
            break;
    }
    
    [self.selectLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH / 3.0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(2);
        make.centerX.mas_equalTo(selectButton.mas_centerX);
    }];

}

#pragma mark - getter
- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Shows",nil) forState:UIControlStateNormal];
        [_showButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Shows",nil) forState:UIControlStateSelected];
        [_showButton setTitleColor:ZFCOLOR(244, 140, 0, 1.f) forState:UIControlStateSelected];
        [_showButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _showButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _showButton.tag = ZFCommunityAccountSelectTypeShow;
        _showButton.selected = YES;
        [_showButton addTarget:self action:@selector(communityAccountSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (UIButton *)outfitsButton {
    if (!_outfitsButton) {
        _outfitsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outfitsButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Outfits",nil) forState:UIControlStateNormal];
        [_outfitsButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Outfits",nil) forState:UIControlStateSelected];
        [_outfitsButton setTitleColor:ZFCOLOR(244, 140, 0, 1.f) forState:UIControlStateSelected];
        [_outfitsButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _outfitsButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _outfitsButton.tag = ZFCommunityAccountSelectTypeOutfits;
        [_outfitsButton addTarget:self action:@selector(communityAccountSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outfitsButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Likes",nil) forState:UIControlStateNormal];
        [_likeButton setTitle:ZFLocalizedString(@"MyStylePage_SubVC_Likes",nil) forState:UIControlStateSelected];
        [_likeButton setTitleColor:ZFCOLOR(244, 140, 0, 1.f) forState:UIControlStateSelected];
        [_likeButton setTitleColor:ZFCOLOR(153, 153, 153, 1.f) forState:UIControlStateNormal];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _likeButton.tag = ZFCommunityAccountSelectTypeLike;
        [_likeButton addTarget:self action:@selector(communityAccountSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeButton;
}

- (UIView *)selectLineView {
    if (!_selectLineView) {
        _selectLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectLineView.backgroundColor = ZFCOLOR(244, 140, 0, 1.f);
    }
    return _selectLineView;
}

@end
