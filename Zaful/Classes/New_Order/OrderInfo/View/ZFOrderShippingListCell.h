//
//  ZFOrderShippingListCell.h
//  Zaful
//
//  Created by TsangFa on 19/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShippingListModel;
@interface ZFOrderShippingListCell : UITableViewCell
+ (NSString *)queryReuseIdentifier;
@property (nonatomic, strong) ShippingListModel *shippingListModel;
@property (nonatomic, assign) BOOL              isChoose;
@property (nonatomic, assign) BOOL              isCod;
@end
