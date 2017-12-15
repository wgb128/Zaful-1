//
//  CheckReviewViewController.h
//  Zaful
//
//  Created by DBP on 16/12/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
#import "OrderDetailGoodModel.h"

@interface CheckReviewViewController : ZFBaseViewController
@property (nonatomic, strong) OrderDetailGoodModel *goodsModel;
@property (nonatomic, strong) NSString *orderid;
@end
