//
//  CategoryRefineModel.m
//  ListPageViewController
//
//  Created by TsangFa on 1/7/17.
//  Copyright © 2017年 TsangFa. All rights reserved.
//

#import "CategoryRefineSectionModel.h"
#import "CategoryRefineDetailModel.h"

@implementation CategoryRefineSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"refine_list"   : [CategoryRefineDetailModel class] };
    
}
@end
