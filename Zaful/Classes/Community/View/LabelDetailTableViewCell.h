//
//  LabelDetailTableViewCell.h
//  Zaful
//
//  Created by DBP on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelDetailListModel.h"

@interface LabelDetailTableViewCell : UITableViewCell

+ (LabelDetailTableViewCell *)labelDetailTableViewCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) LabelDetailListModel *model;

@property (nonatomic, copy) void (^communtiyMyStyleBlock)();//My Style Block

@property (nonatomic, copy) void (^clickEventBlock)(UIButton *btn);//Click Event Block
@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);

@end
