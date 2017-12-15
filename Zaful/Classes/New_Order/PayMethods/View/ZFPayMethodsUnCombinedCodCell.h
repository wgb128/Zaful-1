//
//  ZFPayMethodsUnCombinedCodCell.h
//  Zaful
//
//  Created by liuxi on 2017/10/12.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZFPayMethodsChildModel;
@interface ZFPayMethodsUnCombinedCodCell : UITableViewCell

@property (nonatomic, strong) ZFPayMethodsChildModel   *model;

@property (nonatomic, copy) NSString   *codMsg;

@end
