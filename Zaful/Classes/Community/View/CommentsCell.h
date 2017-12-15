//
//  CommentsCell.h
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityDetailReviewsListMode;

@interface CommentsCell : UITableViewCell

+ (CommentsCell *)commentsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) CommunityDetailReviewsListMode *reviesModel;

@property (nonatomic, copy) void (^replyBlock)();//回复Block

@property (nonatomic, copy) void (^jumpBlock)(NSString *userId);//跳转VC Block

@end
