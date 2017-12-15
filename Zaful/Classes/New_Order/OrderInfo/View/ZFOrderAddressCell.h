//
//  ZFOrderAddressCell.h
//  Zaful
//
//  Created by TsangFa on 17/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFAddressInfoModel;
@interface ZFOrderAddressCell : UITableViewCell

@property (nonatomic, strong) ZFAddressInfoModel   *addressModel;

+ (NSString *)queryReuseIdentifier;

@end
