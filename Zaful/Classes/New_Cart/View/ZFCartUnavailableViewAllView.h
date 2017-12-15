//
//  ZFCartUnavailableViewAllView.h
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CartUnavailableViewAllSelectCompletionHandler)(BOOL isShowMore);

@interface ZFCartUnavailableViewAllView : UITableViewHeaderFooterView
@property (nonatomic, assign) BOOL          isShowMore;
@property (nonatomic, copy) CartUnavailableViewAllSelectCompletionHandler       cartUnavailableViewAllSelectCompletionHandler;
@end
