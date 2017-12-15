//
//  VerificationView.m
//  Zaful
//
//  Created by DBP on 17/3/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "VerificationView.h"

@interface VerificationView () <UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) CustomTextField *phoneField;
@property (nonatomic, strong) UIButton *senderBtn;
@property (nonatomic, strong) CustomTextField *codeField;
@property (nonatomic, strong) UILabel *alretLabel;
@property (nonatomic, strong) UIButton *vreifyBtn;
@end

@implementation VerificationView

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo([UIApplication sharedApplication].keyWindow).with.insets(UIEdgeInsetsZero);
    }];
    
    CGFloat duration = 0.3;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.8), @(1), @(1.05), @(1)];
    animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"bouce"];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - data
- (instancetype)initWithTitle:(NSString *)title andCode:(NSString *)code andphoneNum:(NSString *)phoneNum {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = ZFCOLOR(0,0,0,0.6);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapClick:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.backGroundView];
        [self.backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.mas_leading).offset(10);
            make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [self.backGroundView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(5);
            make.top.mas_equalTo(self.backGroundView.mas_top).offset(5);
            make.size.mas_equalTo(28);
        }];
        
        [self.backGroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self.backGroundView);
            make.top.mas_equalTo(self.backGroundView.mas_top).offset(22);
            make.height.mas_equalTo(25);
        }];
        
        [self.backGroundView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(18);
            make.trailing.mas_equalTo(self.backGroundView.mas_trailing).offset(-18);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        }];
        
        [self.backGroundView addSubview:self.senderBtn];
        [self.senderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(18);
            make.trailing.mas_equalTo(self.backGroundView.mas_trailing).offset(-12);
            make.height.mas_equalTo(43);
            make.width.mas_equalTo(130);
        }];
        
        [self.backGroundView addSubview:self.phoneField];
        [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.senderBtn.mas_centerY);
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(12);
            make.trailing.mas_equalTo(self.senderBtn.mas_leading).offset(-10);
            make.height.mas_equalTo(43);
        }];
        
        [self.backGroundView addSubview:self.codeField];
        [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneField.mas_bottom).offset(20);
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(12);
            make.trailing.mas_equalTo(self.backGroundView.mas_trailing).offset(-12);
            make.height.mas_equalTo(43);
        }];
        
        [self.backGroundView addSubview:self.alretLabel];
        [self.alretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(18);
            make.top.mas_equalTo(self.codeField.mas_bottom).offset(12);
        }];
        
        [self.backGroundView addSubview:self.vreifyBtn];
        [self.vreifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.backGroundView.mas_leading).offset(12);
            make.trailing.mas_equalTo(self.backGroundView.mas_trailing).offset(-12);
            make.top.mas_equalTo(self.alretLabel.mas_bottom).offset(14);
            make.height.mas_equalTo(40);
            make.bottom.mas_equalTo(self.backGroundView.mas_bottom).offset(-20);
        }];
    }
    self.titleLabel.text = [NSString stringWithFormat:ZFLocalizedString(@"VerificationView_titleLabel", nil),title];
    if([NSStringUtils isEmptyString:code]) {
        self.phoneField.placeholder = [NSString stringWithFormat:@"%@",phoneNum];
    } else {
         self.phoneField.placeholder = [NSString stringWithFormat:@"+%@ %@",code,phoneNum];
    }
    
    return self;
}

- (void)setIsCodeSuccess:(BOOL)isCodeSuccess {
    if (!isCodeSuccess) {
        self.alretLabel.text = ZFLocalizedString(@"VerificationView_alretLabel_error", nil);
    }
}
#pragma mark - btnclik
//倒计时功能
- (void)startTime:(UIButton *)showButton{
    
    if (self.sendCodeBlock) {
        self.sendCodeBlock();
    }
    __block int timeout = 119; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [showButton setTitle:ZFLocalizedString(@"VerificationView_showButton_titile", nil) forState:UIControlStateNormal];
                showButton.userInteractionEnabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [showButton setTitle:[NSString stringWithFormat:ZFLocalizedString(@"VerificationView_showButton_resent", nil),strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                showButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)closeBtnClick {
    [self removeFromSuperview];
}

- (void)vreifyBtnClick {
    if ([NSStringUtils isEmptyString:self.codeField.text]) {
        self.alretLabel.text = ZFLocalizedString(@"VerificationView_alretLabel_empty", nil);
        return;
    }
    if (self.codeBlock) {
        self.codeBlock(self.codeField.text);
    }
}

- (void)closeTapClick:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.backGroundView];
    CGRect userHeaderImageRect = [self convertRect:self.backGroundView.bounds fromView:self];
    if (CGRectContainsPoint(userHeaderImageRect, touchPoint)) {
        //clicked user header image.
        return;
    }
    [self removeFromSuperview];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
        //make.top.mas_equalTo(25 *DSCREEN_HEIGHT_SCALE);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-100 *DSCREEN_HEIGHT_SCALE);
    }];

    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //动画完成后的代码
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.backGroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.mas_trailing).offset(-10);
        //make.top.mas_equalTo(25 *DSCREEN_HEIGHT_SCALE);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //动画完成后的代码
    }];

}

#pragma mark - lazy
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backGroundView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"verification"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _detailLabel.numberOfLines = 0;
        _detailLabel.text = ZFLocalizedString(@"VerificationView_detailLabel", nil);
    }
    return _detailLabel;
}


-(CustomTextField *)codeField {
    if (!_codeField) {
        _codeField = [[CustomTextField alloc] init];
        _codeField.delegate = self;
        _codeField.backgroundColor = [UIColor whiteColor];
        if ([SystemConfigUtils isCanRightToLeftShow]) {
            _codeField.textAlignment = NSTextAlignmentRight;
        }
        _codeField.placeholder = ZFLocalizedString(@"VerificationView_codeField", nil);
        [_codeField showCurrentViewBorder:0.5 color:ZFCOLOR(178, 178, 178, 1.0)];
        _codeField.font = [UIFont systemFontOfSize:14];
        _codeField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _codeField;
}

- (CustomTextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[CustomTextField alloc] init];
        _phoneField.textAlignment = NSTextAlignmentCenter;
        _phoneField.backgroundColor = ZFCOLOR(226, 226, 226, 1.0);
        _phoneField.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _phoneField.font = [UIFont systemFontOfSize:14];
        _phoneField.keyboardType = UIKeyboardTypePhonePad;
        _phoneField.userInteractionEnabled = NO;
    }
    return _phoneField;
}

- (UIButton *)senderBtn {
    if (!_senderBtn) {
        _senderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderBtn.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        _senderBtn.titleLabel.textColor = ZFCOLOR(255, 255, 255, 1.0);
        _senderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_senderBtn setTitle:ZFLocalizedString(@"VerificationView_showButton_titile", nil) forState:UIControlStateNormal];
        [_senderBtn addTarget:self action:@selector(startTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _senderBtn;
}

- (UILabel *)alretLabel {
    if (!_alretLabel) {
        _alretLabel = [[UILabel alloc] init];
        _alretLabel.font = [UIFont systemFontOfSize:14];
        _alretLabel.textColor = ZFCOLOR(255, 168, 0, 1.0);

    }
    return _alretLabel;
}

- (UIButton *)vreifyBtn {
    if (!_vreifyBtn) {
        _vreifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _vreifyBtn.backgroundColor = ZFCOLOR(51, 51, 51, 1.0);
        _vreifyBtn.titleLabel.textColor = ZFCOLOR(255, 255, 255, 1.0);
        _vreifyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_vreifyBtn setTitle:ZFLocalizedString(@"VerificationView_VERIFY", nil) forState:UIControlStateNormal];
        [_vreifyBtn addTarget:self action:@selector(vreifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vreifyBtn;
}
@end
