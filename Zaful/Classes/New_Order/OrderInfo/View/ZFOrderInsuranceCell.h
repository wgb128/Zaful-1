//
//  ZFOrderInsuranceCell.h
//  Zaful
//
//  Created by TsangFa on 19/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFOrderInsuranceCell : UITableViewCell

@property (nonatomic, copy) NSString   *insuranceFee; // 物流保险费
@property (nonatomic, assign) BOOL                  isCod;

@property (nonatomic, assign) BOOL     isChoose;

+ (NSString *)queryReuseIdentifier;

@end
