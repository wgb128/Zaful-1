//
//  TopicListTableViewCell.h
//  Zaful
//
//  Created by DBP on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"

@interface TopicListTableViewCell : UITableViewCell
+ (TopicListTableViewCell *)topicListTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) TopicListModel *listModel;
@end
