//
//  MessagesTableViewCell.h
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesListModel.h"

@interface MessagesTableViewCell : UITableViewCell
+ (MessagesTableViewCell *)messagesTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) MessagesListModel *listModel;
@property (nonatomic, copy) void (^messagetapListAvatarBlock)();//My Style Block
@property (nonatomic,copy) void (^clickEventBlock)();//Click Event Block
@end
