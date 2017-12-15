//
//  ZFOrderCouponCell.h
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFOrderCouponCell : UITableViewCell

@property (nonatomic,copy) NSString *couponAmount;
@property (nonatomic, assign) BOOL                  isCod;

- (void)initCouponAmount:(NSString *)couponAmount;
+ (NSString *)queryReuseIdentifier;

@end
