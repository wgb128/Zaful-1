//
//  OrderDetailLineSubView.m
//  Zaful
//
//  Created by DBP on 17/3/3.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "OrderDetailLineSubView.h"

@interface OrderDetailLineSubView ()
@property (nonatomic, strong) UIView *lineView;
@end

@implementation OrderDetailLineSubView

- (instancetype)initWithStatus:(BOOL)hidden {
    if (self = [super initWithFrame:CGRectZero]) {
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 15, 0));
            make.height.mas_equalTo(@(MIN_PIXEL));
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
