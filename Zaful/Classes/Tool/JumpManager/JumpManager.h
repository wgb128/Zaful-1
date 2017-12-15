//
//  JumpManager.h
//  Zaful
//
//  Created by DBP on 16/10/25.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JumpModel;
@interface JumpManager : NSObject
+ (void)doJumpActionTarget:(id)target withJumpModel:(JumpModel *)jumpModel;
@end
