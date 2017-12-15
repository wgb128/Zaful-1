//
//  CategoryPriceListSectionView.h
//  Zaful
//
//  Created by TsangFa on 13/7/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CategoryPriceListSectionViewTouchHandler)(NSString *selectTitle ,BOOL isSelect);

@interface CategoryPriceListSectionView : UITableViewHeaderFooterView

@property (nonatomic, copy)   NSString   *priceRange;

@property (nonatomic, assign) BOOL       isSelect;

@property (nonatomic, copy) CategoryPriceListSectionViewTouchHandler   categoryPriceListSectionViewTouchHandler;

+ (NSString *)setIdentifier;

@end
