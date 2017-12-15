//
//  StyleShowsListModel.h
//  Yoshop
//
//  Created by zhaowei on 16/7/13.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleShowsListModel : NSObject
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong) NSArray *list;
@end
