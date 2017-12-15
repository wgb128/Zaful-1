//
//  RateModel.h
//  Yoshop
//
//  Created by zhaowei on 16/6/1.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RateModel : NSObject<NSCoding>
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *rate;
@property (nonatomic,copy) NSString *symbol;
@end
