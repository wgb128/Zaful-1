//
//  PostViewController.h
//  Zaful
//
//  Created by TsangFa on 16/11/26.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

@interface PostViewController : ZFBaseViewController

@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;
@property (nonatomic, copy) NSString *topic;//传入话题

@end
