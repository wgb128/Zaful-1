//
//  ZFAddressViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddAddressView.h"
#import "ZFAddressEditViewController.h"
#import "ZFAddressListTableViewCell.h"
#import "ZFAddressInfoModel.h"
#import "ZFAddressViewModel.h"


static NSString *const kZFAddressListTableViewCellIdentifier = @"kZFAddressListTableViewCellIdentifier";

@interface ZFAddressViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource> {
    NSInteger       _currentSelectIndex;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) ZFAddAddressView      *addAddressView;
@property (nonatomic, strong) ZFAddressViewModel    *viewModel;
@property (nonatomic, strong) NSMutableArray<ZFAddressInfoModel *>      *dataArray;

@property (nonatomic, assign) BOOL          isEditNormal;  // 是否已经经过编辑

@end

@implementation ZFAddressViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEditNormal = NO;
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - action methods
- (void)editTouchEvent:(UIBarButtonItem *)sender {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self.tableView reloadData];
    sender.title = self.tableView.editing ? ZFLocalizedString(@"Address_VC_Done",nil) : ZFLocalizedString(@"Address_VC_Edit",nil);
}

- (void)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        @weakify(self);
        ZFAddressInfoModel *model = self.dataArray[_currentSelectIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:_currentSelectIndex];
        [self selectDefaulAddressWithAddressId:model.address_id andIndexPath:indexPath completion:^{
            @strongify(self);
            if (self.addressChooseCompletionHandler) {
                self.addressChooseCompletionHandler(self.dataArray[indexPath.section]);
            }
        }];
    }];
}

#pragma mark - private methods
- (void)configNavigationView {

    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:ZFLocalizedString(@"Address_VC_Edit",nil) style:UIBarButtonItemStyleDone target:self action:@selector(editTouchEvent:)];
    
    [editItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [editItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = editItem;
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:ZFLocalizedString(@"CartOrderInfo_Address_List_Close",nil) style:UIBarButtonItemStyleDone target:self action:@selector(closeButtonAction:)];
    
    [closeItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    [closeItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
    self.navigationItem.leftBarButtonItem = closeItem;
}

- (void)selectDefaulAddressWithAddressId:(NSString *)addressId andIndexPath:(NSIndexPath *)indexPath completion:(void (^)())completion{
    if (_currentSelectIndex == indexPath.section
        && !self.isEditNormal) {
        return ;
    }
    @weakify(self);
    [self.viewModel requestsetDefaultAddressNetwork:addressId completion:^(BOOL isOK) {
        @strongify(self);
        if (!isOK) {
            return ;
        }
        ZFAddressInfoModel *selectModel = self.dataArray[indexPath.section];
        selectModel.is_default = YES;
        self.dataArray[indexPath.section] = selectModel;
        ZFAddressInfoModel *currentSelectModel = self.dataArray[_currentSelectIndex];
        currentSelectModel.is_default = NO;
        self.dataArray[_currentSelectIndex] = currentSelectModel;
        _currentSelectIndex = indexPath.section;
        [self.tableView reloadData];
        if (completion) {
            completion();
        }
    }];
}

- (void)deleteAddressWithAddressId:(NSString *)addressId andIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    
    [self.viewModel requestDeleteAddressNetwork:addressId completion:^(BOOL isOK) {
        @strongify(self);
        if (!isOK) {
            return ;
        }
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
}

- (void)updateAddAddressLayoutWithCanAdd:(BOOL)canAdd {
    if (canAdd) {
        [self.view addSubview:self.addAddressView];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
        }];
        
        [self.addAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(self.view);
            make.top.mas_equalTo(self.tableView.mas_bottom);
        }];
    } else {
        [self.addAddressView removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFAddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFAddressListTableViewCellIdentifier];
    cell.model = self.dataArray[indexPath.section];
    if (self.dataArray[indexPath.section].is_default) {
        self->_currentSelectIndex = indexPath.section;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressEditSelectCompletionHandler = ^(ZFAddressInfoModel *model) {
        @weakify(self);
        if (self.showType == AddressInfoShowTypeCart) {
            if (tableView.editing) {
                ZFAddressEditViewController *addressEditVC = [[ZFAddressEditViewController alloc] init];
                addressEditVC.model = model;
                
                addressEditVC.addressEditSuccessCompletionHandler = ^{
                    @strongify(self);
                    self.isEditNormal = YES;
                    [self.tableView.mj_header beginRefreshing];
                };
                [self.navigationController pushViewController:addressEditVC animated:YES];
            } else {
//                [self selectDefaulAddressWithAddressId:model.address_id andIndexPath:indexPath completion:^{
//                    @strongify(self);
//                    if (self.addressChooseCompletionHandler) {
//                        self.addressChooseCompletionHandler(self.dataArray[indexPath.section]);
//                    }
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self selectDefaulAddressWithAddressId:model.address_id andIndexPath:indexPath completion:^{
                        @strongify(self);
                        if (self.addressChooseCompletionHandler) {
                            self.addressChooseCompletionHandler(self.dataArray[indexPath.section]);
                        }
                    }];
                }];

            }
        } else {
            ZFAddressEditViewController *addressEditVC = [[ZFAddressEditViewController alloc] init];
            addressEditVC.model = model;
            
            addressEditVC.addressEditSuccessCompletionHandler = ^{
                @strongify(self);
                [self.tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:addressEditVC animated:YES];
        }
 
    };
    return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == self.dataArray.count - 1 ? 10 : CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return !self.tableView.editing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return ;
    }
    ZFAddressInfoModel *model = self.dataArray[indexPath.section];
    @weakify(self);
    @weakify(tableView);
    [self.viewModel requestDeleteAddressNetwork:model.address_id completion:^(BOOL isOK) {
        @strongify(self);
        if (isOK) {
            if (indexPath.section < self.dataArray.count) {
                @strongify(self);
                [self.dataArray removeObjectAtIndex:indexPath.section];
                [self updateAddAddressLayoutWithCanAdd:(self.dataArray.count < 5)];
                @strongify(tableView);
                [tableView beginUpdates];
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                [tableView reloadData];
            } else {
                
            }
        } else {
            [tableView reloadData];
        }
    }];
}

- (void)emptyNoDataOption {
    @weakify(self);
    [self.tableView zf_configureWithPlaceHolderBlock:^UIView * _Nonnull(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = NO;
        UIView * customView = [[UIView alloc] initWithFrame:CGRectZero];
        
        
        YYAnimatedImageView *imageView = [YYAnimatedImageView new];
        imageView.image = [UIImage imageNamed:@"emptyAddress"];
        [customView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(customView.mas_top).mas_offset(170 * DSCREEN_HEIGHT_SCALE);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = ZFCOLOR(102, 102, 102, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = ZFLocalizedString(@"AddressListViewModel_NoData_Title", nil);
        [customView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(customView.mas_centerX);
        }];
        
        return customView;
    } normalBlock:^(UITableView * _Nonnull sender) {
        @strongify(self);
        self.tableView.scrollEnabled = YES;
    }];

}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"Address_VC_Title", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    if (self.showType == AddressInfoShowTypeCart) {
        [self configNavigationView];
    } 
    [self.view addSubview:self.tableView];

}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - setter
- (void)setShowType:(AddressInfoShowType)showType {
    _showType = showType;
    
}

#pragma mark - getter
- (NSMutableArray<ZFAddressInfoModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ZFAddressViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFAddressViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZFAddressListTableViewCell class] forCellReuseIdentifier:kZFAddressListTableViewCellIdentifier];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestAddressListNetwork:nil completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                [self updateAddAddressLayoutWithCanAdd:(self.dataArray.count < 5)];
                [self emptyNoDataOption];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                //[self updateAddAddressLayoutWithCanAdd:(self.dataArray.count < 5)];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
    }
    return _tableView;
}

- (ZFAddAddressView *)addAddressView {
    if (!_addAddressView) {
        _addAddressView = [[ZFAddAddressView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _addAddressView.addAddressCompletionHandler = ^{
            @strongify(self);
            ZFAddressEditViewController *addAddressVC = [[ZFAddressEditViewController alloc] init];
            addAddressVC.addressEditSuccessCompletionHandler = ^{
                @strongify(self);
                [self.tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:addAddressVC animated:YES];
        };
    }
    return _addAddressView;
}
@end
