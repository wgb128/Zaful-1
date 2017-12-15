//
//  ZFTrackingPackageViewModel.m
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingPackageViewModel.h"
#import "ZFTrackingPackageModel.h"
#import "ZFTrackingListCell.h"
#import "ZFTrackingGoodsCell.h"
#import "ZFTrackingListHeaderView.h"
#import "ZFTrackingPackageApi.h"
#import "ZFTrackingListModel.h"
#import "ZFTrackingEmptyCell.h"

static const NSInteger kTrackingSectionNumber  = 2;
static const CGFloat kRouteSectionHeaderHeight = 60.0;


typedef NS_ENUM(NSUInteger, TrackingSectionType) {
    TrackingGoodListSectionType = 0,
    TrackingListSectionType     = 1
};

@implementation ZFTrackingPackageViewModel
#pragma mark - Setter
- (void)setModel:(ZFTrackingPackageModel *)model {
    _model = model;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kTrackingSectionNumber;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case TrackingGoodListSectionType:
            return self.model.track_goods.count;
            break;
        case TrackingListSectionType:
            return self.model.track_list.count > 0 ? self.model.track_list.count : 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TrackingGoodListSectionType:
        {
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = ZFCOLOR(247, 247, 247, 1);
            return lineView;
        }
            break;
        case TrackingListSectionType:
        {
            ZFTrackingListHeaderView *headerView = [[ZFTrackingListHeaderView alloc] init];
            headerView.model = self.model;
            return headerView;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case TrackingGoodListSectionType:
            return 8;
            break;
        case TrackingListSectionType:
            return kRouteSectionHeaderHeight;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TrackingGoodListSectionType:
        {
            ZFTrackingGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZFTrackingGoodsCell setIdentifier]];
            if (indexPath.row <= self.model.track_goods.count - 1) {
                cell.model = self.model.track_goods[indexPath.row];
            }
            return cell;
        }
            break;
        case TrackingListSectionType:
        {
            if (self.model.track_list.count > 0) {
                ZFTrackingListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZFTrackingListCell setIdentifier]];
                if (indexPath.row <= self.model.track_list.count - 1) {
                    cell.model = self.model.track_list[indexPath.row];
                    cell.hasUpLine = indexPath.row == 0 ? NO : YES;
                    cell.currented = indexPath.row == 0 ? YES : NO;
                    cell.hasDownLine = indexPath.row == self.model.track_list.count - 1 ? NO : YES;
                }
                return cell;
            }else{
                ZFTrackingEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZFTrackingEmptyCell setIdentifier]];
                return cell;
            }
        }
            break;
        default:
        {
            return [UITableViewCell new];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case TrackingGoodListSectionType:
        {
            return 120;
        }
            break;
        case TrackingListSectionType:
        {
            if (self.model.track_list.count > 0) {
                ZFTrackingListModel *model = self.model.track_list[indexPath.row];
                return model.height;
            }else{
                return 250;
            }
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

@end
