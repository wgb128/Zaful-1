//
//  ContactsCell.h
//  Zaful
//
//  Created by TsangFa on 17/1/15.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPPersonModel;

typedef void(^ContactsSelectBlock)(PPPersonModel *model);

@interface ContactsCell : UITableViewCell

@property (nonatomic,copy) ContactsSelectBlock contactsSelectBlock;

@property (nonatomic,strong) PPPersonModel *model;

+ (ContactsCell *)contactsCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@end
