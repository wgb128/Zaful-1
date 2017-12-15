//
//  ZFHomePageMenuListView.h
//  Zaful
//
//  Created by QianHan on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFHomePageMenuListView : NSObject

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, copy) void(^selectedMenuIndex)(NSInteger index);
@property (nonatomic, copy) void(^tabHiddenHandle)(void);

- (instancetype)initWithMenuTitles:(NSArray *)menuTitles selectedIndex:(NSInteger)selectedIndex;
- (void)showWithOffsetY:(CGFloat)offsetY;
- (void)hidden;

@end
