//
//  ZFCommunityAccountShowsListModel.h
//  Zaful
//
//  Created by liuxi on 2017/8/4.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFCommunityAccountShowsListModel : NSObject
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,strong) NSArray *list;
@end
