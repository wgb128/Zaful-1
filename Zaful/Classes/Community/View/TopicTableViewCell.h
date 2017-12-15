//
//  TopicTableViewCell.h
//  Zaful
//
//  Created by DBP on 16/11/22.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicDetailListModel.h"

@interface TopicTableViewCell : UITableViewCell
+ (TopicTableViewCell *)topicTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) TopicDetailListModel *model;

@property (nonatomic, copy) void (^communtiyMyStyleBlock)();//My Style Block

@property (nonatomic, copy) void (^clickEventBlock)(UIButton *btn,TopicDetailListModel *model);//Click Event Block
@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);

@end
