//
//  ZFOrderPointsCell.h
//  Zaful
//
//  Created by TsangFa on 20/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PointModel;
typedef void(^PointsInputBlock)(NSString *amount,NSString *inputPoint);
typedef void(^PointsShowHelpBlock)(NSString *tips);

@interface ZFOrderPointsCell : UITableViewCell

@property (nonatomic, copy) PointsInputBlock        pointsInputBlock;
@property (nonatomic, copy) PointsShowHelpBlock     pointsShowHelpBlock;
@property (nonatomic, strong) PointModel            *pointModel;
@property (nonatomic, assign) BOOL                  isCod;
+ (NSString *)queryReuseIdentifier;

@end
