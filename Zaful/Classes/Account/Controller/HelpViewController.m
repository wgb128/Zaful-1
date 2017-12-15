//
//  HelpViewController.m
//  Zaful
//
//  Created by Y001 on 16/9/21.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpViewModel.h"
#import "HelpModel.h"
#import "ZFInitViewProtocol.h"
#import "ZFWebViewViewController.h"

@interface HelpViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HelpViewModel         *helpViewModel;
@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@end

@implementation HelpViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self requestData];
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentNatural;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    HelpModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpModel *model = _dataArray[indexPath.row];
    
    ZFWebViewViewController *web = [[ZFWebViewViewController alloc]init];
    web.title = model.title;
    web.link_url = model.url;
    [self.navigationController pushViewController:web animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"Help_VC_Title",nil);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)requestData {
    [self.helpViewModel requestNetwork:nil completion:^(id obj) {
        self.dataArray = obj;
        [self.tableView reloadData];
    } failure:^(id obj) {
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.bounces = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (HelpViewModel * )helpViewModel {
    if (_helpViewModel == nil) {
        _helpViewModel = [[HelpViewModel alloc]init];
    }
    return _helpViewModel;
}

@end
