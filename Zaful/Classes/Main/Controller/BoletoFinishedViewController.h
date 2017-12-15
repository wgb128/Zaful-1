//
//  BoletoFinishedViewController.h
//  Zaful
//
//  Created by TsangFa on 15/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFBaseViewController.h"

typedef void (^BoContiueBlock) ();

typedef void (^BoOrderListBlock) ();

@interface BoletoFinishedViewController : ZFBaseViewController

@property (nonatomic, copy) NSString   *order_number;

@property (nonatomic, copy) NSString   *order_id;

@property (nonatomic, copy) BoContiueBlock   boContiueBlock;

@property (nonatomic, copy) BoOrderListBlock   boOrderListBlock;

@end
