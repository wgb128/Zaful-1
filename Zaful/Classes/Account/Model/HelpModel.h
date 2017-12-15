//
//  HelpModel.h
//  Zaful
//
//  Created by Y001 on 16/9/21.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HelpModel : NSObject<YYModel>
@property (nonatomic, copy) NSString * helpId;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * url;

@end
