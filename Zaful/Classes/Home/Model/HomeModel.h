//
//  HomeModel.h
//  Zaful
//
//  Created by Y001 on 16/9/17.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject<YYModel>

@property (nonatomic, strong) NSMutableArray * advArray;
@property (nonatomic, strong) NSMutableArray * categoryArray;
@property (nonatomic, strong) NSMutableArray * bannerArray;;
@property (nonatomic, strong) NSMutableArray * goodsArray;
@property (nonatomic, strong) NSMutableArray *floatArray;

@end
