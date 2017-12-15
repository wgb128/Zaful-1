//
//  CommunityCell.h
//  Yoshop
//
//  Created by huangxieyue on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavesItemsModel;

@interface PopularCell : UITableViewCell

+ (PopularCell *)popularCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) FavesItemsModel *itemsModel;

@property (nonatomic, copy) void (^communtiyMyStyleBlock)();//My Style Block

@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);

@property (nonatomic, copy) void (^clickEventBlock)(UIButton *btn);//Click Event Block

@end
