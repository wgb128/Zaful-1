//
//  GuideController.h
//  BossBuy
//
//  Created by BB on 15/7/20.
//  Copyright (c) 2015年 fasionspring. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectedEnter)();
@interface GuideController : UIViewController

@property (nonatomic, strong) UIScrollView  *pagingScrollView;
@property (nonatomic, strong) UIButton      *enterButton;

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

@property (nonatomic, strong) NSArray *coverImageNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames button:(UIButton*)button;

@end
