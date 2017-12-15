//
//  RewardPickerView.m
//  Yoshop
//
//  Created by Stone on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "RewardPickerView.h"

@interface RewardPickerView () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation RewardPickerView
{
    int _scrollIndex;
    BOOL _isShow;
    UILabel *_titleLabel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataSource = [NSMutableArray array];
        [self initUI];
        _scrollIndex++;
    }
    return self;
}

- (void)initUI
{
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.3;
    [self addSubview:_backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.top.bottom.offset(0);
    }];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(_backgroundView).offset(0);
    }];
    
    _toolBar = [[UIToolbar alloc] init];
    _toolBar.barTintColor = ZFMAIN_COLOR;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = ZFCOLOR(51, 51, 51, 1.0);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60, 30);
    [leftBtn setTitle:ZFLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:ZFLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:ZFCOLOR(51, 51, 51, 1.0) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelitem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *leftflexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *rightflexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    titleItem.customView = _titleLabel;
    _toolBar.items = @[cancelitem,leftflexItem,titleItem,rightflexItem,commitItem];
    [self addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(_backgroundView).offset(0);
        make.bottom.mas_equalTo(_pickerView.mas_top).offset(0);
        make.height.equalTo(@44);
    }];
}

-(void)cancelBtnClick{
    [self removeFromSuperview];
}

-(void)okBtnClick{
    if ([self.delegate respondsToSelector:@selector(rewardPickerViewFinishPick:andSelectedIndex:)]) {
        [self.delegate rewardPickerViewFinishPick:self andSelectedIndex:_scrollIndex];
        [self removeFromSuperview];
    }
    _scrollIndex = 1;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count < 100 ? self.dataSource.count : 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _scrollIndex = (int)row + 1;
    [self.pickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    UILabel * label = (UILabel *)view;
    if (!label){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        if (self.dataSource.count > 0) {
            label.text = self.dataSource[row];
        }else{
            label.text = nil;
        }
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    return label;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.dataSource removeAllObjects];
    
    for (int i = 0; i < self.items; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%d",i + 1]];
    }
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
}

@end
