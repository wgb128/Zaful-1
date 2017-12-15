//
//  ZFLoginViewController.h
//  Zaful
//
//  Created by TsangFa on 28/11/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZFLoginEnterType) {
    ZFLoginEnterTypeLogin = 0,
    ZFLoginEnterTypeSignUp
};

typedef void (^SuccessSignBlock)();

typedef void (^CancelSignBlock)();

@interface ZFLoginViewController : UIViewController

@property (nonatomic, assign) ZFLoginEnterType      enterType;

@property (nonatomic, copy) SuccessSignBlock successBlock;

@property (nonatomic, copy) CancelSignBlock cancelSignBlock;

@end
