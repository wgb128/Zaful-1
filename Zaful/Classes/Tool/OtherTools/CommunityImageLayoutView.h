//
//  CommunityImageLayoutView.h
//  Zaful
//
//  Created by zhaowei on 2017/2/10.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityImageLayoutView : UIView
@property (nonatomic,assign) CGFloat leadingSpacing;
@property (nonatomic,assign) CGFloat trailingSpacing;
@property (nonatomic,assign) CGFloat fixedSpacing;
@property (nonatomic,strong) NSArray *imagePaths;
@end
