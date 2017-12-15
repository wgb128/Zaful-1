//
//  ZFOrderGoodsCell.h
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckOutGoodListModel;

@interface ZFOrderGoodsCell : UITableViewCell

@property (nonatomic, strong) NSArray<CheckOutGoodListModel *>  *goodsList;

+ (NSString *)queryReuseIdentifier;

@end
