//
//  ZFTrackingPackageViewController.m
//  Zaful
//
//  Created by TsangFa on 4/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFTrackingPackageViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFTrackingPackageViewModel.h"
#import "ZFTrackingListCell.h"
#import "ZFTrackingGoodsCell.h"
#import "ZFTrackingEmptyCell.h"
#import "ZFTrackingPackageModel.h"

@interface ZFTrackingPackageViewController ()<ZFInitViewProtocol>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) ZFTrackingPackageViewModel   *viewModel;
@property (nonatomic, strong) UIView   *empatyView;
@end

@implementation ZFTrackingPackageViewController
#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self zfInitView];
    [self zfAutoLayoutView];
    
    self.viewModel.model = self.model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark -<ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    [self.view addSubview:self.tableView];
    
}

- (void)zfAutoLayoutView {

}

#pragma mark - Getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[ZFTrackingListCell class] forCellReuseIdentifier:[ZFTrackingListCell setIdentifier]];
        [_tableView registerClass:[ZFTrackingGoodsCell class] forCellReuseIdentifier:[ZFTrackingGoodsCell setIdentifier]];
         [_tableView registerClass:[ZFTrackingEmptyCell class] forCellReuseIdentifier:[ZFTrackingEmptyCell setIdentifier]];
        _tableView.dataSource = self.viewModel;
        _tableView.delegate = self.viewModel;
        _tableView.scrollsToTop = YES;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}

- (ZFTrackingPackageViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFTrackingPackageViewModel alloc] init];
        
    }
    return _viewModel;
}



@end
