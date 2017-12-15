//
//  ZFOrderPaymentListCell.h
//  Zaful
//
//  Created by TsangFa on 18/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  PaymentListModel;
@interface ZFOrderPaymentListCell : UITableViewCell

+ (NSString *)queryReuseIdentifier;

@property (nonatomic,strong) PaymentListModel *paymentListmodel;
@property (nonatomic, assign) BOOL            isChoose;

@end


