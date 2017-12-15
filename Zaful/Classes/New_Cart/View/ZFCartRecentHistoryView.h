//
//  ZFCartRecentHistoryTableViewCell.h
//  Zaful
//
//  Created by liuxi on 2017/9/16.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartRecentHistoryGoodsDetailCompletionHandler)(NSString *goodsId);

@interface ZFCartRecentHistoryView : UITableViewCell

@property (nonatomic, copy) CartRecentHistoryGoodsDetailCompletionHandler       cartRecentHistoryGoodsDetailCompletionHandler;

- (void)changeCommendGoodsListInfo;
@end
