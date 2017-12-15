//
//  FriendsCommendHeadView.h
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FriendsCommendHeadView : UITableViewHeaderFooterView
@property (nonatomic,copy) void(^contactsTouchBlock)();
@property (nonatomic,copy) void(^inviteTouchBlock)();
+ (FriendsCommendHeadView *)friendsCommendHeadViewWithTableView:(UITableView *)tableView;
@end
