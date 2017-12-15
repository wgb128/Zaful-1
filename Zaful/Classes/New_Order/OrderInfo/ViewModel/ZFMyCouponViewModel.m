//
//  ZFMyCouponViewModel.m
//  Zaful
//
//  Created by QianHan on 2017/12/1.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFMyCouponViewModel.h"
#import "ZFMyCouponTableViewCell.h"
#import "ZFMyCouponModel.h"

@interface ZFMyCouponViewModel() <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *_selectedIndexPath;
}

@property (nonatomic, strong) NSMutableArray *availableArray;
@property (nonatomic, strong) NSMutableArray *disabledArray;

@end

@implementation ZFMyCouponViewModel

- (instancetype)initWithAvailableCoupon:(NSArray <ZFMyCouponModel *>*)availableCoupon
                          disableCoupon:(NSArray <ZFMyCouponModel *>*)disableCoupon
                             couponCode:(NSString *)couponCode
                           couponAmount:(NSString *)couponAmount {
    if (self = [self init]) {
        self.availableArray = [NSMutableArray new];
        self.disabledArray  = [NSMutableArray new];
        _selectedIndexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.availableArray addObjectsFromArray:availableCoupon];
        [self.disabledArray addObjectsFromArray:disableCoupon];
        [self reConfigDatasWithCouponCode:couponCode couponAmount:couponAmount];
    }
    return self;
}

- (void)selectedBefore {
    ZFMyCouponModel *model = self.availableArray[_selectedIndexPath.row];
    if (self.itemSelectedHandle) {
        if (model.isSelected) {
            self.itemSelectedHandle(model);
        } else {
            self.itemSelectedHandle(nil);
        }
    }
}

#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.availableArray.count > 0 ? self.availableArray.count : self.disabledArray.count;
    }
    return self.disabledArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.availableArray.count > 0
        && self.disabledArray.count > 0) {
        return 2;
    } else if (self.availableArray.count > 0
               || self.disabledArray.count > 0) {
        return 1;
    }
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ZFMyCouponTableViewCell *cell = [ZFMyCouponTableViewCell couponItemCellWithTableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZFMyCouponModel *model = [[ZFMyCouponModel alloc] init];
    if (indexPath.section == 1) {
        model = self.disabledArray[indexPath.row];
        cell.couponType = CouponDisabled;
        cell.tagBtnActionHandle = ^{
            model.isShowAll = !model.isShowAll;
            [self.disabledArray replaceObjectAtIndex:indexPath.row withObject:model];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    } else {
        model = self.availableArray.count > 0 ? self.availableArray[indexPath.row] : self.disabledArray[indexPath.row];
        if (self.availableArray.count > 0) {
            cell.couponType = CouponAvailable;
        } else {
            cell.couponType = CouponDisabled;
        }
        cell.tagBtnActionHandle = ^{
            model.isShowAll = !model.isShowAll;
            if (self.availableArray.count > 0) {
                [self.availableArray replaceObjectAtIndex:indexPath.row withObject:model];
            } else {
                [self.disabledArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
    [cell configWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ((section == 0
         && self.availableArray.count == 0)
        || section == 1) {
        return 30.0f;
    }
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1
        ||(section == 0
           && self.availableArray.count == 0
           && self.disabledArray.count > 0)) {
        UIView *headerView         = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.width, 30.0)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIView *line               = [[UIView alloc] init];
        line.backgroundColor       = ZFCOLOR(178, 178, 178, 1.0);
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat offsetX = 35.0f * SCREEN_WIDTH_SCALE;
            make.leading.mas_equalTo(headerView.mas_leading).offset(offsetX);
            make.trailing.mas_equalTo(headerView.mas_trailing).offset(- offsetX);
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            make.height.mas_equalTo(0.5f);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = tableView.backgroundColor;
        titleLabel.textColor       = ZFCOLOR(178, 178, 178, 1.0);
        titleLabel.textAlignment   = NSTextAlignmentCenter;
        titleLabel.font            = [UIFont systemFontOfSize:14.0f];
        titleLabel.text            = ZFLocalizedString(@"OrderDetail_Coupon_Header", nil);
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.centerY.mas_equalTo(headerView.mas_centerY);
            make.width.mas_equalTo(line.mas_width).offset(line.width - 68.0 * SCREEN_WIDTH_SCALE * 2);
        }];
        
        return headerView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.availableArray.count > 0
        && indexPath.section == 0) {
        ZFMyCouponModel *preModel = self.availableArray[_selectedIndexPath.row];
        if (indexPath.row != _selectedIndexPath.row) {
            preModel.isSelected = NO;
        }
        ZFMyCouponModel *model    = self.availableArray[indexPath.row];
        model.isSelected          = !model.isSelected;
        [self.availableArray replaceObjectAtIndex:indexPath.row withObject:model];
        [tableView reloadRowsAtIndexPaths:@[_selectedIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.itemSelectedHandle) {
            if (model.isSelected) {
                self.itemSelectedHandle(model);
            } else {
                self.itemSelectedHandle(nil);
            }
        }
        _selectedIndexPath = indexPath;
    }
}

#pragma mark - private Method
- (void)reConfigDatasWithCouponCode:(NSString *)couponCode couponAmount:(NSString *)couponAmount {

    [self.availableArray enumerateObjectsUsingBlock:^(ZFMyCouponModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.isSelected = NO;
    }];
    
    for (ZFMyCouponModel *model in self.disabledArray) {
        model.isSelected = NO;
        if ([model.code isEqualToString:couponCode]) {
            model.isSelected   = YES;
            model.pcode_amount = couponAmount;
            [self.disabledArray removeObject:model];
            [self.availableArray insertObject:model atIndex:0];
            _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
        }
    }
}

@end
