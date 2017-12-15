//
//  ZFOrderMultiAttributeInfoView.h
//  Zaful
//
//  Created by liuxi on 2017/10/24.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFMultAttributeModel.h"

@interface ZFOrderMultiAttributeInfoView : UIView
@property (nonatomic, strong) NSArray<ZFMultAttributeModel *>           *attrsArray;

@end
