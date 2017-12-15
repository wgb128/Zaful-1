//
//  CategoryVirtualViewController.h
//  ListPageViewController
//
//  Created by TsangFa on 5/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryVirtualViewController : UIViewController
/**
 * 虚拟分类 3种
 */
@property (nonatomic, copy) NSString   *virtualType;

@property (nonatomic, copy) NSString   *virtualTitle;
- (instancetype)initInHome;

@end
