//
//  ZFTrackingListCell.h
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFTrackingListModel;

@interface ZFTrackingListCell : UITableViewCell

@property (nonatomic, strong) ZFTrackingListModel   *model;

@property (assign, nonatomic) BOOL hasUpLine;
@property (assign, nonatomic) BOOL hasDownLine;
@property (assign, nonatomic) BOOL currented;

+ (NSString *)setIdentifier;

@end
