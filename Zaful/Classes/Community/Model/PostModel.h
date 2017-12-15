//
//  PostModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/20.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostModel : NSObject
@property (nonatomic,copy) NSString *goodsId;
@property (nonatomic,copy) NSString *goodsTitle;
@property (nonatomic,copy) NSString *goodsThumb;
@property (nonatomic,copy) NSString *goodsPrice;
@property (nonatomic,copy) NSString *wid;
@property (nonatomic,assign) BOOL isSelected;
@end
