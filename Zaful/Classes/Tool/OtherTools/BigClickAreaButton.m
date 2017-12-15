//
//  BigClickAreaButton.m
//  Zaful
//
//  Created by TsangFa on 16/12/1.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "BigClickAreaButton.h"

@implementation BigClickAreaButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(self.clickAreaRadious - bounds.size.width, 0);
    CGFloat heightDelta = MAX(self.clickAreaRadious - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}


@end
