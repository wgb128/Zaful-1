//
//  RecommendGoods.h
//  Zaful
//
//  Created by huangxieyue on 16/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell

+ (RecommendCell *)recommendCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) void (^jumpBlock)();//跳转VC Block

@property (nonatomic, strong) NSDictionary *data;

@end
