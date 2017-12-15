//
//  CountryListModel.h
//  Yoshop
//
//  Created by zhaowei on 16/6/8.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CountryModel;
@interface CountryListModel : NSObject
@property (nonatomic,copy) NSString *key;
@property (nonatomic,strong) NSArray<CountryModel *> *countryList;
@end
