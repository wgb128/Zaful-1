//
//  CommunityDetailHeaderCell.h
//  Yoshop
//
//  Created by huangxieyue on 16/8/6.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ImgTouchBlock)(NSArray *groupItems , NSArray *imgArrays,NSInteger viewIndex);

@class CommunityDetailModel;

@interface CommunityDetailHeaderCell : UITableViewCell

- (void) initWithDetailModel:(CommunityDetailModel*)detailModel ListUser:(NSMutableArray*)listUser;

@property (nonatomic,copy) void (^clickDetailBlock)(PopularBtnTag tag);//Click Event Block

@property (nonatomic,copy) void (^clickLikeListBlock)();

@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);

@property (nonatomic,weak) UIViewController *controller;

@property (nonatomic,copy) ImgTouchBlock imgTouchBlock;

+ (CommunityDetailHeaderCell *)communityDetailHeaderCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@end
