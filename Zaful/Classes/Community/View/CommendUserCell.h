//
//  CommendUserCell.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//  推荐用户的CELL

#import <UIKit/UIKit.h>

@class CommendUserModel;
@interface CommendUserCell : UITableViewCell
@property (nonatomic,strong) CommendUserModel *commendUserModel;
@property (nonatomic,copy) void (^clickEventBlock)();//Click Event Block
+ (CommendUserCell *)commendUserCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
