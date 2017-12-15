//
//  FollowModel.h
//  Yoshop
//
//  Created by Stone on 16/7/11.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FollowItemModel.h"

@interface FollowModel : NSObject

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *listArray;

@end
