//
//  StyleLikesCell.h
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StyleLikesModel;
@interface StyleLikesCell : UITableViewCell
+ (StyleLikesCell *)styleLikesCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) StyleLikesModel *reviewsModel;
@property (nonatomic,copy) void (^communtiyMyStyleBlock)();//My Style Block
@property (nonatomic,copy) void (^clickEventBlock)(PopularBtnTag tag);//Click Event Block
@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);
@end
