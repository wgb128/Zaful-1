//
//  ZFRegisterView.h
//  Zaful
//
//  Created by TsangFa on 2/12/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SignupButtonCompletionHandler)(NSString *email, NSString *password, BOOL isSubscribe);

typedef void(^GoogleplusButtonCompletionHandler)(void);

typedef void(^FacebookButtonCompletionHandler)(void);

typedef void(^LoginButtonCompletionHandler)(void);

typedef void(^BackButtonCompletionHandler)(void);

typedef void(^WebJumpActionCompletionHandler)(NSString *title, NSString *url);

@interface ZFRegisterView : UIView

@property (nonatomic, copy) SignupButtonCompletionHandler           registerButtonCompletionHandler;
@property (nonatomic, copy) GoogleplusButtonCompletionHandler       googleplusButtonCompletionHandler;
@property (nonatomic, copy) FacebookButtonCompletionHandler         facebookButtonCompletionHandler;
@property (nonatomic, copy) LoginButtonCompletionHandler            loginButtonCompletionHandler;
@property (nonatomic, copy) BackButtonCompletionHandler             backButtonCompletionHandler;
@property (nonatomic, copy) WebJumpActionCompletionHandler          webJumpActionCompletionHandler;


@end
