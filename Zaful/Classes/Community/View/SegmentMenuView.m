//
//  SegmentMenuView.m
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SegmentMenuView.h"

@interface SegmentMenuView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArray;
/** 底部滑动的动画条 */
@property (nonatomic, strong) UIView *slideLineView;

@property (nonatomic,strong) UIView *lineView;

//记录当前被选中的按钮
@property (nonatomic, weak) UIButton *nowSelectedBtn;

@end

@implementation SegmentMenuView

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles
{
    if (self = [super init]) {
        self.btnArray = [NSMutableArray array];
        [self buildBtnArrayWithTitles:titles];
        [self setUp];
        [self layoutIfNeeded];
    }
    
    return self;
}

- (instancetype)initWithImage:(NSArray<UIImage *> *)images
{
    if (self = [super init]) {
        self.btnArray = [NSMutableArray array];
        [self buildBtnArrayWithImages:images];
        [self setUp];
        [self layoutIfNeeded];
    }
    
    return self;
}

- (void)buildBtnArrayWithTitles:(NSArray<NSString *> *)titles {
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.btnArray addObject:btn];
        [self addSubview:btn];
    }];
}

- (void)buildBtnArrayWithImages:(NSArray<UIImage *> *)images {
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setImage:obj forState:UIControlStateNormal];
        btn.tag = idx;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.btnArray addObject:btn];
        [self addSubview:btn];
    }];
}

- (void)setUp
{
    //背景色和阴影
    self.backgroundColor = [UIColor whiteColor];
//    self.layer.shadowOpacity = 0.1;
//    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
    [self addSubview:self.lineView];
    
    self.slideLineView = [[UIView alloc] init];
    self.slideLineView.backgroundColor = ZFMAIN_COLOR;
//    self.slideLineView.layer.masksToBounds = YES;
//    self.slideLineView.layer.cornerRadius = 2;
    [self addSubview:self.slideLineView];
}

//设置控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat viewH = self.bounds.size.height;
    CGFloat viewW = self.bounds.size.width;
    CGFloat btnW = viewW / self.btnArray.count;
    CGFloat btnH = viewH;
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx * btnW, 0, btnW, btnH - 3);
    }];
    self.slideLineView.frame = CGRectMake(0, viewH - 3, btnW, 3);
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.slideLineView.frame), SCREEN_WIDTH, 0.5);

}

#pragma mark - 按钮的Action
- (void)btnClick:(UIButton *)sender
{
    if (self.nowSelectedBtn == sender) return;
    
    //通知代理点击
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectedButtonFrom:to:)]) {
        [self.delegate selectView:self didSelectedButtonFrom:self.nowSelectedBtn.tag to:sender.tag];
    }
    
    //给滑动小条做动画
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = sender.frame.origin.x;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];
    
    self.nowSelectedBtn = sender;
}

//有代理时，点击按钮
- (void)setDelegate:(id<SegmentMenuViewDelegate>)delegate
{
    _delegate = delegate;
    
    [self btnClick:self.btnArray.firstObject];
}

- (void)lineToIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
        [self.delegate selectView:self didChangeSelectedView:index];
    }
    self.nowSelectedBtn = self.btnArray[index];
    
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = self.nowSelectedBtn.frame.origin.x;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];
}


@end
