//
//  ZFHomePageMenuListView.m
//  Zaful
//
//  Created by QianHan on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFHomePageMenuListView.h"

@interface ZFHomePageMenuListView () {
    
    NSArray *_itemDatas;
    CGFloat _mainHeight;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) NSMutableArray *itemButtonArray;
@property (nonatomic, strong) CALayer *separetorLayer;

@end

@implementation ZFHomePageMenuListView

- (instancetype)initWithMenuTitles:(NSArray *)menuTitles selectedIndex:(NSInteger)selectedIndex {
    if (self = [super init]) {
        _itemDatas     = menuTitles;
        _selectedIndex = selectedIndex;
        self.itemButtonArray = [[NSMutableArray alloc] initWithCapacity:_itemDatas.count];
        [self setupView];
        [self addGesture];
    }
    return self;
}

- (void)setupView {
    [self.backgroundView addSubview:self.mainView];
    
    CGFloat space      = 20.0f;
    CGFloat offsetY    = 6.0f;
    CGFloat offsetX    = space;
    CGFloat itemHeight = 32.0f;
    CGFloat itemWidth  = (self.mainView.width - 40.0 - 5.0 * 3) / 4;
    UIFont *font       = [UIFont systemFontOfSize:14.0f];
    
    [self.itemButtonArray removeAllObjects];
    for (NSInteger i = 0; i < _itemDatas.count; i++) {
        
        NSString *menuTitle = _itemDatas[i];
        CGFloat nextOffsetX = offsetX + itemWidth + 5.0f;
        if (i % 4 == 0
            && i != 0) {
            offsetY     = offsetY + itemHeight + 12.0f;
            offsetX     = space;
            nextOffsetX = offsetX + itemWidth + 5.0f;
        }
        
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.frame     = CGRectMake(offsetX, offsetY, itemWidth, itemHeight);
        item.backgroundColor    = [UIColor clearColor];
        item.titleLabel.font    = font;
        item.layer.borderWidth  = 1.0f;
        item.tag = i;
        [item setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [item setTitleColor:ZFCOLOR(183, 96, 42, 1.0) forState:UIControlStateSelected];
        [item setTitle:menuTitle forState:UIControlStateNormal];
        [item addTarget:self action:@selector(menuItemSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mainView addSubview:item];
        [self.itemButtonArray addObject:item];
        offsetX = nextOffsetX;
        _mainHeight = offsetY + itemHeight + 26.0f;
        if (i == _selectedIndex) {
            [self didSelectedWithIndex:i];
        } else {
            [self deSelectWithIndex:i];
        }
    }

    self.separetorLayer                 = [[CALayer alloc] init];
    self.separetorLayer.frame           = CGRectMake(0.0, _mainHeight - 1.0f, self.mainView.width, 1.0f);
    self.separetorLayer.backgroundColor = ZFCOLOR(221.0, 221.0, 221.0, 1.0).CGColor;
    [self.mainView.layer addSublayer:self.separetorLayer];
}

- (void)addGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(tapHidden)];
    [self.backgroundView addGestureRecognizer:tapGesture];
}

- (void)showWithOffsetY:(CGFloat)offsetY {
    self.backgroundView.y      = offsetY;
    self.backgroundView.height = KScreenHeight - offsetY;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        self.mainView.height = _mainHeight;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        self.mainView.height = 0.0f;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
}

- (void)didSelectedWithIndex:(NSInteger)index {
    UIButton *btn = [self.itemButtonArray objectAtIndex:index];
    btn.selected  = YES;
    btn.layer.borderColor = ZFCOLOR(183, 96, 42, 1.0).CGColor;
}

- (void)deSelectWithIndex:(NSInteger)index {
    UIButton *btn = [self.itemButtonArray objectAtIndex:index];
    btn.selected  = NO;
    btn.layer.borderColor = ZFCOLOR(221.0, 221.0, 221.0, 1.0).CGColor;
}

#pragma mark - event
- (void)menuItemSelectedAction:(UIButton *)btn {
    if (btn.tag == _selectedIndex) {
        return;
    }

    self.selectedIndex = btn.tag;
    btn.selected       = !btn.selected;
    [self hidden];
    if (self.selectedMenuIndex) {
        self.selectedMenuIndex(btn.tag);
    }
}

- (void)tapHidden {
    if (self.tabHiddenHandle) {
        self.tabHiddenHandle();
    }
}

#pragma mark - getter/setter
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth, KScreenWidth)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        _backgroundView.clipsToBounds   = YES;
    }
    return _backgroundView;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.backgroundView.width, 0.0)];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.clipsToBounds   = YES;
    }
    return _mainView;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    [self deSelectWithIndex:_selectedIndex];
    _selectedIndex        = selectedIndex;
    [self didSelectedWithIndex:selectedIndex];
}

@end
