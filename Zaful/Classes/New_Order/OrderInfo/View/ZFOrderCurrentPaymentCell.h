//
//  ZFOrderCurrentPaymentCell.h
//  Zaful
//
//  Created by TsangFa on 17/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFOrderCurrentPaymentCell : UITableViewCell

@property (nonatomic, copy) NSString   *currentPayment;

+ (NSString *)queryReuseIdentifier;

@end
