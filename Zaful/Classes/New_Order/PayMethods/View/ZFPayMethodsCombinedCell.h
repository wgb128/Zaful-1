//
//  ZFPayMethodsCombinedCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFPayMethodsChildModel;
@class ZFPayMethodsWaysModel;
@interface ZFPayMethodsCombinedCell : UITableViewCell
@property (nonatomic, strong) ZFPayMethodsWaysModel     *model;
@property (nonatomic, copy) NSString                    *codMsg;
@end
