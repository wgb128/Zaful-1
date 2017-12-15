//
//  GoodsSortCell.h
//  Dezzal
//
//  Created by Y001 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsSortCell : UITableViewCell

@property (nonatomic, strong) YYAnimatedImageView * selectImg; //单选的图片
@property (nonatomic, strong) UILabel     * typeLabel; //显示类型

/** 点击选择图片*/
@property (nonatomic, copy) void(^selectImgClick)(NSIndexPath * indePath);

+ (GoodsSortCell *)GoodsSortCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath * )indexPath;

@end
