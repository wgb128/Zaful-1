//
//  ZFTrackingGoodsCell.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFTrackingGoodsModel;

@interface ZFTrackingGoodsCell : UITableViewCell

@property (nonatomic, strong) ZFTrackingGoodsModel   *model;

+ (NSString *)setIdentifier;

@end
