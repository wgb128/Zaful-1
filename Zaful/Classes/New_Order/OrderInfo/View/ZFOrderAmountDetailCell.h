//
//  ZFOrderAmountDetailCell.h
//  Zaful
//
//  Created by TsangFa on 21/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFOrderAmountDetailModel;
@interface ZFOrderAmountDetailCell : UITableViewCell

+ (NSString *)queryReuseIdentifier;

@property (nonatomic, strong) ZFOrderAmountDetailModel   *model;
@end
