//
//  ZFMultiAttributeInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFMultAttributeModel.h"
@interface ZFMultiAttributeInfoView : UIView
@property (nonatomic, strong) NSArray<ZFMultAttributeModel *>           *attrsArray;
@end
