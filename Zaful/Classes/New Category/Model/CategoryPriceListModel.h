//
//  CategoryPriceListModel.h
//  ListPageViewController
//
//  Created by TsangFa on 5/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryPriceListModel : NSObject

@property (nonatomic, assign) CGFloat   price_max;

@property (nonatomic, assign) CGFloat   price_min;

@property (nonatomic, copy) NSString   *price_range;

@end
