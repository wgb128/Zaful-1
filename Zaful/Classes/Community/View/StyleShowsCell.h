//
//  StyleShowsCell.h
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StyleShowsModel;
@interface StyleShowsCell : UITableViewCell
+ (StyleShowsCell *)styleShowsCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) StyleShowsModel *reviewsModel;
@property (nonatomic,copy) void (^communtiyMyStyleBlock)();//My Style Block
@property (nonatomic,copy) void (^clickEventBlock)(PopularBtnTag tag);//Click Event Block
@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);
@end
