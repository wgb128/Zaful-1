//
//  UIView+Subviews.m
//  GearBest
//
//  Created by zhaowei on 16/3/17.
//  Copyright © 2016年 gearbest. All rights reserved.
//

#import "UIView+Subviews.h"


@implementation UIView (Subviews)

- (UIView*)subViewWithTag:(int)tag {
	for (UIView *v in self.subviews) {
		if (v.tag == tag) {
			return v;
		}
	}
	return nil;
}

@end
