//
//  VideoListCell.h
//  Zaful
//
//  Created by zhaowei on 2016/11/23.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoInfoModel;

@interface VideoListCell : UITableViewCell

@property (nonatomic, strong) VideoInfoModel *videoInfoModel;

+ (VideoListCell *)videoListCellWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath;

@end
