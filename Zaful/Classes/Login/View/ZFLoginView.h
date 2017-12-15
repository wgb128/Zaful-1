//
//  ZFLoginView.h
//  Zaful
//
//  Created by TsangFa on 1/12/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignInButtonCompletionHandler)(NSString *email, NSString *password);

typedef void(^GoogleplusButtonCompletionHandler)(void);

typedef void(^FacebookButtonCompletionHandler)(void);

typedef void(^RegisterButtonCompletionHandler)(void);

typedef void(^BackButtonCompletionHandler)(void);

typedef void(^ForgotPasswordRequestCompletionHandler)(NSString *email);

@interface ZFLoginView : UIView

@property (nonatomic, copy) SignInButtonCompletionHandler       signInButtonCompletionHandler;
@property (nonatomic, copy) GoogleplusButtonCompletionHandler   googleplusButtonCompletionHandler;
@property (nonatomic, copy) FacebookButtonCompletionHandler     facebookButtonCompletionHandler;
@property (nonatomic, copy) RegisterButtonCompletionHandler     registerButtonCompletionHandler;
@property (nonatomic, copy) BackButtonCompletionHandler         backButtonCompletionHandler;
@property (nonatomic, copy) ForgotPasswordRequestCompletionHandler      forgotPasswordRequestCompletionHandler;


@end
