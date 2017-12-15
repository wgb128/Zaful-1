//
//  ModifyPorfileViewModel.h
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "BaseViewModel.h"

@interface ModifyPorfileViewModel : BaseViewModel
@property (nonatomic, weak) UIViewController *controller;
- (void)requestSaveInfo:(id)parmaters completion:(void (^)(id))completion failure:(void (^)(id))failure;
@end
