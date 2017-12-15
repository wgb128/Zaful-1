//
//  ZFPayMethodsUnCombinedCodHeaderView.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayMethodsCodSelectCompletionHandler)(void);
@interface ZFPayMethodsUnCombinedCodHeaderView : UITableViewHeaderFooterView
@property (nonatomic, assign) BOOL                                          isSelect;
@property (nonatomic, copy) PayMethodsCodSelectCompletionHandler            payMethodsCodSelectCompletionHandler;
@end
