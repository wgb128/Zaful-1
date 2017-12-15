//
//  CartOrderInfoShippingInsuranceView.h
//  Dezzal
//
//  Created by 7FD75 on 16/8/19.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartCreateOrderManager.h"

typedef void (^InsuranceSelectBlock)(BOOL isSelected);


@interface CartOrderInfoShippingInsuranceCell : UITableViewCell

+ (CartOrderInfoShippingInsuranceCell *)cellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) CartCreateOrderManager *manager;

@property (nonatomic, copy) InsuranceSelectBlock insuranceSelectBlock;

@end
