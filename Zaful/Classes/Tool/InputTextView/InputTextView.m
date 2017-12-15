//
//  InputTextView.m
//  Yoshop
//
//  Created by zhaowei on 16/6/28.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "InputTextView.h"

#define kNavigationBarHeight (IPHONE_X_5_15 ? 88.0f : 64.0f)
@interface InputTextView()<UITextViewDelegate,UIScrollViewDelegate>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
    CGFloat _kKeyboardHeight; // 键盘高度
}

@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *lineView;
//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation InputTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    /**
     点击 空白区域取消
     */
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    return self;
}

- (void)initView{
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.leading.mas_equalTo(IPHONE_X_5_15 ? 48.0f : 8.0f);
        make.bottom.mas_equalTo(-6);
//        make.width.mas_equalTo(SCREEN_WIDTH-85);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.leading.mas_equalTo(IPHONE_X_5_15 ? 56.0f : 16.0f);
        make.height.mas_equalTo(39);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0.5);
        make.bottom.mas_equalTo(-9);
        make.trailing.mas_equalTo(-7);
        make.width.mas_equalTo(70);
        make.leading.mas_equalTo(self.textView.mas_trailing).offset(8);
    }];
    
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.frame = [[UIScreen mainScreen] bounds];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _kKeyboardHeight = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, SCREEN_HEIGHT - _kKeyboardHeight - 49 - kNavigationBarHeight, SCREEN_WIDTH, 49);
        
    }else{
        CGRect rect = CGRectMake(0, SCREEN_HEIGHT - self.backGroundView.frame.size.height - _kKeyboardHeight - kNavigationBarHeight, SCREEN_WIDTH, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        self.frame = CGRectMake(0, SCREEN_HEIGHT-49-kNavigationBarHeight, SCREEN_WIDTH, 49);
    }else{
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - rect.size.height - kNavigationBarHeight, SCREEN_WIDTH, self.backGroundView.frame.size.height);
    }
}

- (void)centerTapClick{
    [self.textView resignFirstResponder];
}

#pragma mark --- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    /**
     *  设置占位符
     */
    
    /*直接利用textView的contentSize算textView高度 和 Y modify by HYZ*/
    self.backGroundView.height = textView.contentSize.height + 12;
    if (self.backGroundView.height > 100) {
        self.backGroundView.height = 100;
    }
    // 为了改变 backGroundView 的 y值 随时改变，防止出现遮挡的问题 （球）
    CGRect rect = CGRectMake(0, SCREEN_HEIGHT - self.backGroundView.frame.size.height - _kKeyboardHeight - kNavigationBarHeight, SCREEN_WIDTH, self.backGroundView.frame.size.height);
    self.backGroundView.frame = rect;
   
    if (textView.text.length > 300) {
        self.placeholderLabel.text = @"";
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [MBProgressHUD showMessage:ZFLocalizedString(@"InputTextView_message", nil)];

        });

        self.sendButton.userInteractionEnabled = NO;
        [self.sendButton setTitleColor:ZFCOLOR(209 , 209, 209, 1.0) forState:UIControlStateNormal];
    }else if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        [self.sendButton setTitleColor:ZFCOLOR(209 , 209, 209, 1.0) forState:UIControlStateNormal];
        self.sendButton.userInteractionEnabled = NO;
    }else {
        self.placeholderLabel.text = @"";
        self.sendButton.userInteractionEnabled = YES;
        [self.sendButton setTitleColor:ZFCOLOR(33 , 150, 243, 1.0) forState:UIControlStateNormal];
    }
    
#if 0
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(SCREEN_WIDTH-65, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - 49, SCREEN_WIDTH, 49);
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - textView.contentSize.height-10, SCREEN_WIDTH,textView.contentSize.height+10);
    }else{
        statusTextView = YES;
        return;
    }
#endif
    
}

#pragma  mark -- 发送事件
- (void)sendClick:(UIButton *)sender{
    
    [self.textView endEditing:YES];
    if (self.InputTextViewBlock) {
        self.InputTextViewBlock(self.textView.text);
    }
    
    //---- 发送成功之后清空 ------//
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
//    [self.sendButton setBackgroundColor:YSCOLOR(209 , 209, 209, 1.0)];
    [self.sendButton setTitleColor:ZFCOLOR(209 , 209, 209, 1.0) forState:UIControlStateNormal];
    self.sendButton.userInteractionEnabled = NO;
    self.frame = CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH, 49);
    self.backGroundView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
}


#pragma mark --- 懒加载控件
- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _backGroundView.backgroundColor = [UIColor whiteColor];//YSCOLOR(230, 230, 230, 1.0);
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = ZFCOLOR(209, 209, 209, 1.0);
        [self.backGroundView addSubview:_lineView];
    }
    return _lineView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.backgroundColor = ZFCOLOR(241, 241, 241, 1.0);
        if ([SystemConfigUtils isRightToLeftShow]) {
            _textView.textAlignment = NSTextAlignmentRight;
        }
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = ZFCOLOR(153, 153, 153, 1.0);
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
//        [_sendButton setBackgroundColor:YSCOLOR(209 , 209, 209, 1.0)];
        [_sendButton setTitle:ZFLocalizedString(@"InputTextView_Send",nil) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setTitleColor:ZFCOLOR(209 , 209, 209, 1.0) forState:UIControlStateNormal];
        [_sendButton setTitleColor:ZFCOLOR(156 , 211, 255, 1.0) forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
//        _sendButton.layer.cornerRadius = 5;
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}

#pragma mark --- UIScrollViewDelegate
//修改此处是为了让textView可以滚动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (statusTextView == NO) {
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }else{
//        
//    }
//}

#pragma mark - textViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.text.length>299) {
        if ([text isEqualToString:@""])
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
