//
//  CheckReviewModel.h
//  Zaful
//
//  Created by DBP on 16/12/27.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckReviewModel : NSObject
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *rate_overall;
@property (nonatomic, strong) NSArray *reviewPic;
@end
