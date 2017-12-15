//
//  SpacingSubView.m
//  Zaful
//
//  Created by DBP on 17/3/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SpacingSubView.h"

@interface SpacingSubView ()
@property (nonatomic, strong) UIView *SpacingView;
@end
@implementation SpacingSubView

- (instancetype)initWithStatus:(BOOL)hidden {
    if (self = [super initWithFrame:CGRectZero]) {
        self.SpacingView = [[UIView alloc] init];
        self.SpacingView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        
        [self addSubview:self.SpacingView];
        [self.SpacingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

@end
