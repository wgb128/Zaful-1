//
//  ShowsViewController.h
//  Yoshop
//
//  Created by huangxieyue on 16/8/18.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFBaseViewController.h"

@interface ShowsViewController : ZFBaseViewController

- (instancetype)initUserId:(NSString*)userid;

@property (nonatomic, copy) NSString *userid;

@end
