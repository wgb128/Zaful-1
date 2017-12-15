//
//  FavesCell.h
//  Zaful
//
//  Created by DBP on 17/1/18.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavesItemsModel;

@interface FavesCell : UITableViewCell

+ (FavesCell *)favesCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) FavesItemsModel *itemsModel;

@property (nonatomic, copy) void (^communtiyMyStyleBlock)();//My Style Block

@property (nonatomic, copy) void (^topicDetailBlock)(NSString *labName);

@property (nonatomic, copy) void (^clickEventBlock)(UIButton *btn);//Click Event Block

@end
