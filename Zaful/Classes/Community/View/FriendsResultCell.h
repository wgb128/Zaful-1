//
//  FriendsResultCell.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsResultModel;
@interface FriendsResultCell : UITableViewCell
@property (nonatomic,strong) FriendsResultModel *friendsResultModel;
@property (nonatomic,copy) void (^clickEventBlock)();//Click Event Block
+ (FriendsResultCell *)friendsResultCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@end
