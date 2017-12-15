//
//  WriteReviewViewController.h
//  Zaful
//
//  Created by DBP on 16/12/28.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"
@class OrderDetailGoodModel;

typedef void(^WriteReviewSuccess)(void);

@interface WriteReviewViewController : ZFBaseViewController
@property (nonatomic, strong) OrderDetailGoodModel *goodsModel;
@property (nonatomic, copy) NSString *orderid;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, copy) WriteReviewSuccess blockSuccess;
@end
