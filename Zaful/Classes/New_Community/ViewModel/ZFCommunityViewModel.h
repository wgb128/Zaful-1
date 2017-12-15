//
//  ZFCommunityViewModel.h
//  Zaful
//
//  Created by liuxi on 2017/7/25.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ZFCommunityViewModel : BaseViewModel
- (void)requestMessageCountNetwork:(id)parmaters completion:(void (^)(id obj))completion failure:(void (^)(id obj))failure;
@end
