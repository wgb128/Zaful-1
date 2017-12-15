//
//  AccountProfileViewController.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ModifyPorfileViewModel.h"
#import "JVFloatLabeledTextField.h"

static NSString *const EditDefalutDateString = @"0000-00-00";

@interface EditProfileViewController () <UITextFieldDelegate,RadioButtonDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) JVFloatLabeledTextField *firstNameTextfield;
@property (nonatomic, strong) JVFloatLabeledTextField *lastNameTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *nicknameTextField;

@property (nonatomic, strong) RadioButton *maleBtn;
@property (nonatomic, strong) RadioButton *femaleBtn;
@property (nonatomic, strong) RadioButton *privacyBtn;

@property (nonatomic, strong) JVFloatLabeledTextField *birthDayTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) JVFloatLabeledTextField *phoneTextField;
@property (nonatomic, strong) JVFloatLabeledTextField *emailAddressTextField;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) AccountModel *userModel;
@property (nonatomic, strong) ModifyPorfileViewModel *viewModel;
@property (nonatomic, assign) NSInteger sex;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self requestUserData];
}

- (void)requestUserData
{
    [self.viewModel requestNetwork:nil completion:^(id obj) {
        self.userModel = obj;
    } failure:^(id obj) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
}

- (void)setUserModel:(AccountModel *)userModel {
    _userModel = userModel;
    self.firstNameTextfield.text = userModel.firstname;
    self.lastNameTextField.text = userModel.lastname;
    self.nicknameTextField.text = userModel.nickname;
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
    [tempFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [tempFormatter dateFromString:userModel.birthday];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    self.birthDayTextField.text = dateString;
    self.phoneTextField.text = userModel.phone;
    self.emailAddressTextField.text = userModel.email;
    self.sex = userModel.sex;
    if( userModel.sex == 0 ) {
        [self.femaleBtn setChecked:YES];
    }else{
        [self.maleBtn setChecked:self.maleBtn.index == userModel.sex];
        [self.femaleBtn setChecked:self.femaleBtn.index == userModel.sex];
        [self.privacyBtn setChecked:self.privacyBtn.index == userModel.sex];
    }
}

- (void)setUI {
    self.title = ZFLocalizedString(@"Profile_VC_Title",nil);
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH));
        make.edges.mas_equalTo(self.scrollView).with.insets(UIEdgeInsetsMake(0, 0, 20, 0));
    }];
    
    self.firstNameTextfield = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_FirstName_Placeholder",nil) keyboardType:UIKeyboardTypeDefault];
    [self.containerView addSubview:self.firstNameTextfield];
    [self.firstNameTextfield mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(12);
        make.top.offset(20);
        make.trailing.offset(-12);
        make.height.equalTo(@44);
    }];
    
    self.lastNameTextField = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_LastName_Placeholder",nil) keyboardType:UIKeyboardTypeDefault];
    [self.containerView addSubview:self.lastNameTextField];
    [self.lastNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstNameTextfield);
        make.size.equalTo(self.firstNameTextfield);
        make.top.equalTo(self.firstNameTextfield.mas_bottom).offset(20);
    }];
    
    self.nicknameTextField = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_NickName_Placeholder",nil) keyboardType:UIKeyboardTypeDefault];
    [self.containerView addSubview:self.nicknameTextField];
    [self.nicknameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.lastNameTextField);
        make.size.equalTo(self.lastNameTextField);
        make.top.equalTo(self.lastNameTextField.mas_bottom).offset(20);
    }];
    
    
    [self.containerView addSubview:self.femaleBtn];
    [self.femaleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstNameTextfield.mas_leading);
        make.top.equalTo(self.nicknameTextField.mas_bottom).offset(10);
    }];
    
    [self.containerView addSubview:self.maleBtn];
    [self.maleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.femaleBtn.mas_centerY);
        make.leading.mas_equalTo(self.femaleBtn.mas_trailing).offset(20);
    }];
    
    [self.containerView addSubview:self.privacyBtn];
    [self.privacyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.femaleBtn.mas_centerY);
        make.leading.mas_equalTo(self.maleBtn.mas_trailing).offset(20);
    }];
    
    self.birthDayTextField = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_Birthday_Placeholder",nil) keyboardType:UIKeyboardTypeDefault];
    self.birthDayTextField.inputView = self.datePicker;
    [self.containerView addSubview:self.birthDayTextField];
    [self.birthDayTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.femaleBtn.mas_bottom).offset(10);
        make.leading.leading.equalTo(self.firstNameTextfield);
        make.size.equalTo(self.firstNameTextfield);
    }];
    
    self.phoneTextField = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_Phone_Placeholder",nil) keyboardType:UIKeyboardTypeDefault];
    [self.containerView addSubview:self.phoneTextField];
    [self.phoneTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstNameTextfield);
        make.size.equalTo(self.firstNameTextfield);
        make.top.equalTo(self.birthDayTextField.mas_bottom).offset(20);
    }];
    
    self.emailAddressTextField = [self setTextFieldPlaceholder:ZFLocalizedString(@"Profile_EmailAddress_Placeholder",nil) keyboardType:UIKeyboardTypeEmailAddress];
    self.emailAddressTextField.clearButtonMode = UITextFieldViewModeNever;
    [self.containerView addSubview:self.emailAddressTextField];
    [self.emailAddressTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.firstNameTextfield);
        make.size.equalTo(self.firstNameTextfield);
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(20);
        make.bottom.equalTo(self.containerView);
    }];
    
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.offset(0);
        make.height.equalTo(@60);
    }];
}

#pragma mark - Delegate
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!CGColorEqualToColor(textField.layer.borderColor,ZFCOLOR(221, 221, 221, 1.0).CGColor)) {
        textField.layer.borderColor = ZFCOLOR(221, 221, 221, 1.0).CGColor;
    }
    if (textField == self.birthDayTextField) {
        //确保加载时也能获取datePicker的文字
        [self datePickerValueChange:self.datePicker];
    }
}

#pragma mark - radioButton
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId {
    _sex = index; //用户性别 0 保密  1 男  2 女
}
#pragma mark DatePciker Action
- (void)datePickerValueChange:(UIDatePicker *)datePicker{
    //将日期转为指定格式显示
    NSString *dateStr = [self.dateFormatter stringFromDate:datePicker.date];
    self.birthDayTextField.text = dateStr;
}

- (BOOL)checkInputTextFieldIsValid:(UITextField *)textField{
    
    BOOL isCheckValid = YES;
    NSString *showHudErrorString = nil;
    
    if ([textField isEqual:self.firstNameTextfield]) {
        if ([NSStringUtils isEmptyString:textField.text]){
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Enter_FirstName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if (!(textField.text.length > 1)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Least_FirstName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if ((textField.text.length > 35)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Maxium_FirstName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
    }
    
    if ([textField isEqual:self.lastNameTextField]) {
        if ([NSStringUtils isEmptyString:textField.text]){
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Enter_LastName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if (!(textField.text.length > 1)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Least_LastName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if ((textField.text.length > 35)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Maxium_LastName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
    }
    
    if ([textField isEqual:self.nicknameTextField]) {
        if ([NSStringUtils isEmptyString:textField.text]){
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Enter_NickName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if (!(textField.text.length > 1)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Least_NickName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if ((textField.text.length > 35)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Maxium_NickName_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
    }
    
    if ([textField isEqual:self.phoneTextField]) {
        if ([NSStringUtils isEmptyString:textField.text]){
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Enter_Phone_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            
            return NO;
        }
        if ((textField.text.length < 6)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Least_Phone_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
        if ((textField.text.length > 20)) {
            showHudErrorString = !isCheckValid ? showHudErrorString : ZFLocalizedString(@"Profile_Maxium_Phone_Message",nil);
            [MBProgressHUD showMessage:showHudErrorString];
            return NO;
        }
    }
    return YES;
}

#pragma mark Save Button Action

- (void)saveBtnClick
{
    // 判断是否都输入
    if (![self checkInputTextFieldIsValid:self.firstNameTextfield]) {
        return;
    }
    
    if (![self checkInputTextFieldIsValid:self.lastNameTextField]) {
        return;
    }
    
    if (![self checkInputTextFieldIsValid:self.nicknameTextField]) {
        return;
    }
    
    if (![self checkInputTextFieldIsValid:self.phoneTextField]) {
        return;
    }
    
    if (![self checkInputTextFieldIsValid:self.emailAddressTextField]) {
        return;
    }
    
    NSDictionary *dict = @{
                           @"firstname" : self.firstNameTextfield.text,
                           @"lastname"  : self.lastNameTextField.text,
                           @"nickname"  : self.nicknameTextField.text,
                           @"sex"       : @(self.sex),
                           @"phone"     : self.phoneTextField.text,
                           @"email"     : self.emailAddressTextField.text,
                           @"birthday"  : self.birthDayTextField.text
                           };
    
    
    [self.viewModel requestSaveInfo:dict completion:^(id obj) {
        AccountModel *userInfoModel = [[AccountModel alloc] init];
        userInfoModel.firstname = self.firstNameTextfield.text;
        userInfoModel.lastname = self.lastNameTextField.text;
        userInfoModel.nickname = self.nicknameTextField.text;
        userInfoModel.sex = self.sex;
        userInfoModel.phone = self.phoneTextField.text;
        userInfoModel.email = self.emailAddressTextField.text;
        userInfoModel.birthday = self.birthDayTextField.text;
        [[AccountManager sharedManager] editUserSomeItems:userInfoModel];
        self.userModel = userInfoModel;
        // 改变用户信息通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeUserInfoNotification object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id obj) {
        
    }];
}

// 设置textField不能输入文字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.birthDayTextField) {
        return NO;
    }
    if (textField.text.length + string.length > 35) {
        [MBProgressHUD showMessage:ZFLocalizedString(@"Profile_Maxium_NickName_Message",nil)];
        return NO;
    }
    return YES;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    }
    return _scrollView;
}

-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

-(RadioButton *)femaleBtn {
    if (!_femaleBtn) {
        _femaleBtn = [[RadioButton alloc] initWithGroupId:@"sex" index:2 normalImage:[UIImage imageNamed:@"order_unchoose"] selectedImage:[UIImage imageNamed:@"order_choose"] title:ZFLocalizedString(@"Profile_Female", nil) color:[UIColor blackColor]];
        [RadioButton addObserverForGroupId:@"sex" observer:self];
    }
    return _femaleBtn;
}

-(RadioButton *)maleBtn{
    if (!_maleBtn) {
        _maleBtn = [[RadioButton alloc] initWithGroupId:@"sex" index:1 normalImage:[UIImage imageNamed:@"order_unchoose"] selectedImage:[UIImage imageNamed:@"order_choose"] title:ZFLocalizedString(@"Profile_Male", nil) color:[UIColor blackColor]];
        [RadioButton addObserverForGroupId:@"sex" observer:self];
    }
    return _maleBtn;
}

- (RadioButton *)privacyBtn {
    if (!_privacyBtn) {
        _privacyBtn = [[RadioButton alloc] initWithGroupId:@"sex" index:3 normalImage:[UIImage imageNamed:@"order_unchoose"] selectedImage:[UIImage imageNamed:@"order_choose"] title:ZFLocalizedString(@"Profile_Privacy", nil) color:[UIColor blackColor]];
        [RadioButton addObserverForGroupId:@"sex" observer:self];
    }
    return _privacyBtn;
}

/**
 *  设置邮箱不能编辑，不能更改TextField里的内容
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.emailAddressTextField]) {
        return NO;
    }
    return YES;
}

-(UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        [_saveBtn setTitle:ZFLocalizedString(@"Profile_Save_Button",nil) forState:UIControlStateNormal];
        [_saveBtn setTitleColor:ZFCOLOR(255, 255, 255, 1.0) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

//- (CustomTextField *)setTextFieldPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType{
//    
//    CustomTextField  *textField = [[CustomTextField alloc] init];
//    textField.delegate = self;
//    textField.clearButtonMode = UITextFieldViewModeAlways;
//    textField.keyboardType = keyboardType;
//    textField.returnKeyType = UIReturnKeyDone;
//    textField.borderStyle = UITextBorderStyleRoundedRect;
//    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    textField.autocorrectionType = UITextAutocorrectionTypeNo;
//    textField.placeholder = placeholder;
//    [textField setValue:ZFCOLOR(178, 178, 178, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
//    [textField setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];
//    textField.font = [UIFont systemFontOfSize:14.0];
//    textField.textColor = ZFCOLOR(0, 0, 0, 1.0);
//    textField.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
//    if ([SystemConfigUtils isRightToLeftShow]) {
//        textField.textAlignment = NSTextAlignmentRight;
//    } else {
//        textField.textAlignment = NSTextAlignmentLeft;
//    }
//    return textField;
//}

- (JVFloatLabeledTextField *)setTextFieldPlaceholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType {
    
    JVFloatLabeledTextField  *textField = [JVFloatLabeledTextField autolayoutView];
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.keyboardType = keyboardType;
    textField.returnKeyType = UIReturnKeyDone;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.placeholder = placeholder;
    textField.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
    textField.textColor = ZFCOLOR(51, 51, 51, 1.0);
    [textField setValue:ZFCOLOR(178, 178, 178, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];

    textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    textField.floatingLabelTextColor = [UIColor lightGrayColor];
    if ([SystemConfigUtils isRightToLeftShow]) {
        textField.textAlignment = NSTextAlignmentRight;
    } else {
        textField.textAlignment = NSTextAlignmentLeft;
    }
    return textField;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"MM/dd/yyyy"];
    }
    return _dateFormatter;
}

- (UIDatePicker *)datePicker {
    
    if (!_datePicker) {
        
        _datePicker = [[UIDatePicker alloc] init];
        // 设置时区
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        //设置日期显示的格式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置显示最大时间
        [_datePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        
        // 设置当前显示时间
        if ([AccountManager sharedManager].account.birthday.length > 0 && ![[AccountManager sharedManager].account.birthday isEqualToString:EditDefalutDateString]) {
            ZFLog(@"%@",[AccountManager sharedManager].account.birthday);
            NSDateFormatter *tempFormatter = [[NSDateFormatter alloc] init];
            
            [tempFormatter setDateFormat:@"MM/dd/yyyy"];
            
            NSDate *date = [tempFormatter dateFromString:[AccountManager sharedManager].account.birthday];
            
            NSString *dateString = [self.dateFormatter stringFromDate:date];
            
            NSDate *newDate = [self.dateFormatter dateFromString:dateString];
            if (newDate) {
                // 怕出现  newDate == nil 的情况
                [_datePicker setDate:newDate];
            }
        }
        else {
            [_datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:-(365 * 24 * 3600 * 20)]];
        }
        
        //监听datePicker的ValueChanged事件
        [_datePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (ModifyPorfileViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ModifyPorfileViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

@end
