//
//  ZFTrackingListModel.m
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingListModel.h"

@interface ZFTrackingListModel ()
@property (assign, nonatomic) CGFloat tempHeight;
@end

@implementation ZFTrackingListModel

- (CGFloat)height {
    
    if (_tempHeight == 0) {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
        
        CGFloat leftSpace = 68.0;
        CGFloat rightSpace = 16.0;
        CGFloat topSpace = 20.0;
        CGFloat midSpace = 8.0;
        CGFloat upSpace  = 20.0;
        
        CGRect statusRect = [self.status boundingRectWithSize:CGSizeMake(KScreenWidth - leftSpace - rightSpace, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        CGRect dateRect = [self.ondate boundingRectWithSize:CGSizeMake(KScreenWidth - leftSpace - rightSpace, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        _tempHeight = statusRect.size.height + dateRect.size.height + topSpace + upSpace + midSpace;
    }
    
    return _tempHeight;
}


@end
