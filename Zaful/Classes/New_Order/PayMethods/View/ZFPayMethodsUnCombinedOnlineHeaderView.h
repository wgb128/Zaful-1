//
//  ZFPayMethodsUnCombinedOnlineHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayMethodsOnlineSelectCompletionHandler)(void);
@interface ZFPayMethodsUnCombinedOnlineHeaderView : UITableViewHeaderFooterView
@property (nonatomic, assign) BOOL                                          isSelect;
@property (nonatomic, copy) PayMethodsOnlineSelectCompletionHandler         payMethodsOnlineSelectCompletionHandler;
@end
