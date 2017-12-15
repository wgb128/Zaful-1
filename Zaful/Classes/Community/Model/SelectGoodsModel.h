//
//  SelectGoodsModel.h
//  Zaful
//
//  Created by TsangFa on 16/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectGoodsModel : NSObject

@property (nonatomic,copy) NSString *imageURL;

@property (nonatomic,copy) NSString *goodsID;

@property (nonatomic,assign) CommunityGoodsType goodsType;

@end
