//
//  LaunchStatusViewController.h
//  Zaful
//
//  Created by zhaowei on 2017/1/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LaunchStatusViewController : UIViewController
@property (nonatomic,copy) void (^reloadBlock)();
@end
