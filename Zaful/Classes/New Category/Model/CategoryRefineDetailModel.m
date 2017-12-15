//
//  CategoryRefineDetailModel.m
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryRefineDetailModel.h"
#import "CategoryRefineCellModel.h"

@implementation CategoryRefineDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"childArray"   : @"child" };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"childArray"   : [CategoryRefineCellModel class] };
    
}

@end
