//
//  RewardPickerView.m
//  DressOnline
//
//  Created by 7FD75 on 16/3/17.
//  Copyright © 2016年 Sammydress. All rights reserved.
//



#define picikerViewHeight     216
#define toolbarHeight        42
#import "MyCouponPickerView.h"
#import "IQKeyboardManagerConstants.h"

@interface MyCouponPickerView () <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *applyButton;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) NSMutableArray *componentArray;

@property (nonatomic, strong) NSMutableArray *codeArray;

@end

@implementation MyCouponPickerView
{
    UILabel     *_titleLabel;
}

-(void)setDataSource:(NSArray *)dataSource{

    _dataSource = dataSource;
    
    [self.componentArray addObject:ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_Component_NotToUse",nil)];
    [self.codeArray addObject:@""];
    for (UserCouponModel *model in self.dataSource) {
        
        [self.componentArray addObject:[NSString stringWithFormat:@"%@ %@",model.code,model.des]];
        
        [self.codeArray addObject:model.code];
    }
    
    [self.pickerView reloadAllComponents];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubViewsContraint];
    }
    return self;
}

-(NSMutableArray *)componentArray{
    if (!_componentArray) {
        _componentArray = [[NSMutableArray alloc] init];
    }
    return _componentArray;
}

-(NSMutableArray *)codeArray{
    if (!_codeArray) {
        _codeArray = [[NSMutableArray alloc] init];
    }
    return _codeArray;
}

-(void)addSubViewsContraint{
    
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.backgroundView addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.mas_equalTo(self.backgroundView);
        make.height.equalTo(@56);
        make.width.equalTo(self.backgroundView.mas_width).multipliedBy(0.7);
    }];
    
    [self.backgroundView addSubview:self.applyButton];
    [self.applyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.offset(0);
        make.height.equalTo(@56);
        make.width.equalTo(self.backgroundView.mas_width).multipliedBy(0.3);
    }];
    
    [self.backgroundView addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.backgroundView);
        make.bottom.mas_equalTo(self.codeTextField.mas_top).offset(0);
    }];
    
    [self.backgroundView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.backgroundView.mas_leading).offset(0);
        make.trailing.mas_equalTo(self.backgroundView.mas_trailing).offset(0);
        make.bottom.mas_equalTo(self.pickerView.mas_top).offset(0);
        make.height.equalTo(@50);
    }];
    
    [self.backgroundView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(0);
        make.centerY.equalTo(self.titleLabel);
        make.size.equalTo(@50);
    }];
}

-(void)applyButtonClick {

    if (self.selectedFinishBlock) {
        self.selectedFinishBlock(self.codeTextField.text);
    }
}

#pragma mark - uitextFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self show];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
       
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [self hide];
        [textField resignFirstResponder];

        return NO;
    }
    return YES;
}
#pragma mark - PickViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.componentArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.codeTextField.text = self.codeArray[row];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    UILabel * label = (UILabel *)view;
    if (!label){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = ZFCOLOR(0, 0, 0, 1.0);
        label.font = [UIFont boldSystemFontOfSize:16.0];
    }
    
    label.text = self.componentArray[row];
    
    return label;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.backgroundView.frame = CGRectMake(0, - keyboardRect.size.height, SCREEN_WIDTH, SCREEN_HEIGHT);
                     }];

}

- (void)keyboardWillHide {

}

-(void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];

}

-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.frame = CGRectMake(0, -picikerViewHeight-toolbarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

-(void)tap
{
    [self removeFromSuperview];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            _titleLabel.text = [NSString stringWithFormat:@"(0)%@",ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_Title",nil)];
        } else {
            _titleLabel.text = [NSString stringWithFormat:@"%@(0)",ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_Title",nil)];
        }
        
        _titleLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _titleLabel.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"detail_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = ZFCOLOR(0, 0, 0, 0.7);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.alpha = 1.0;
    }
    return _backgroundView;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

-(CustomTextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[CustomTextField alloc] init];
        _codeTextField.delegate = self;
        _codeTextField.clearButtonMode = UITextFieldViewModeAlways;
        _codeTextField.keyboardType = UIKeyboardTypeDefault;
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.borderStyle = UITextBorderStyleBezel;
        _codeTextField.placeholder = ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_CodeTextField_Placeholder",nil);
        [_codeTextField setValue:ZFCOLOR(178, 178, 178, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        [_codeTextField setValue:[UIFont systemFontOfSize:12.0] forKeyPath:@"_placeholderLabel.font"];
        _codeTextField.font = [UIFont systemFontOfSize:14.0];
        _codeTextField.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _codeTextField.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        if ([SystemConfigUtils isRightToLeftShow]) {
            _codeTextField.textAlignment = NSTextAlignmentRight;
        } else {
            _codeTextField.textAlignment = NSTextAlignmentLeft;
        }

    }
    return _codeTextField;
}

-(UIButton *)applyButton{
    if (!_applyButton) {
        _applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _applyButton.backgroundColor = ZFCOLOR(0, 0, 0, 1.0);
        [_applyButton setTitle:ZFLocalizedString(@"CartOrderInfo_MyCouponPickerView_APPLY",nil) forState:UIControlStateNormal];
        [_applyButton setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [_applyButton addTarget:self action:@selector(applyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _applyButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    }
    return _applyButton;
}


@end
