//
//  CommunityReviewsCell.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityDetailReviewsListMode;

@interface CommunityReviewsCell : UITableViewCell

+ (CommunityReviewsCell *)communityDetailCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) CommunityDetailReviewsListMode *reviesModel;

@property (nonatomic,copy) void (^replyBlock)();//回复Block

@property (nonatomic,copy) void (^jumpMyStyleBlock)();//跳转VC Block

@end
