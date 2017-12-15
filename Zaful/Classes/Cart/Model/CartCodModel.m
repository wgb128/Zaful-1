//
//  CartCodModel.m
//  Zaful
//
//  Created by TsangFa on 24/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CartCodModel.h"

@implementation CartCodModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"totalMax"   : @"max",
             @"totalMin"   : @"min",
             @"codFee"     : @"fee"
             };
}

@end
