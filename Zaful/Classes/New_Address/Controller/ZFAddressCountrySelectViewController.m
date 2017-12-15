//
//  ZFAddressCountrySelectViewController.m
//  Zaful
//
//  Created by liuxi on 2017/8/29.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressCountrySelectViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressCountryViewModel.h"
#import "ZFAddressCountryModel.h"
#import "ZFAddressCountrySearchResultView.h"

@interface ZFAddressCountrySelectViewController () <ZFInitViewProtocol, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView                                       *tableView;
@property (nonatomic, strong) ZFAddressCountrySearchResultView                  *searchResultView;
@property (nonatomic, strong) UISearchBar                                       *searchBar;
@property (nonatomic, strong) ZFAddressCountryViewModel                         *viewModel;
@property (nonatomic, strong) NSMutableArray<ZFAddressCountryModel *>           *countryArray;
@property (nonatomic, strong) NSMutableArray                                    *keysArray;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray *> *countryList;
@end

@implementation ZFAddressCountrySelectViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - private methods
- (void)dealWithCountryInfoData {
    
    [self.countryArray enumerateObjectsUsingBlock:^(ZFAddressCountryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj.region_name substringWithRange:NSMakeRange(0, 1)];
        if ([self.countryList objectForKey:key]) {
            NSMutableArray *values = [self.countryList objectForKey:key];
            [values addObject:obj];
            [self.countryList setObject:values forKey:key];
        } else {
            NSMutableArray *values = [NSMutableArray array];
            [self.keysArray addObject:key];
            [values addObject:obj];
            [self.countryList setObject:values forKey:key];
        }
    }];
}

- (NSMutableArray *)smartMatchSearchResultWithKey:(NSString *)key {
    NSMutableArray<ZFAddressCountryModel *> *searchResult = [NSMutableArray array];
    [self.countryArray enumerateObjectsUsingBlock:^(ZFAddressCountryModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger first = 0, second = 0, hash = 0; //hash记录权值， INF为不匹配状态，否则为匹配状态，使用二进制按位标记。权值小排前面，权值相同采用字典序。
        while (first < obj.region_name.length && second < key.length) {
            NSString *first_str = [[obj.region_name substringWithRange:NSMakeRange(first, 1)] lowercaseString];
            NSString *second_str = [[key substringWithRange:NSMakeRange(second, 1)] lowercaseString];
            if ([first_str isEqualToString:second_str]) {   //匹配到对应位置，
                hash |= (1 << first);
                ++first, ++second;
            } else {
                ++first;
            }
        }
        //判断当前second是不是已经匹配完key, 如果匹配完，更新权值，并将匹配到的model加入到搜索结果数组中。
        if (second == key.length) { //匹配完状态
            obj.hashCost = hash;
            [searchResult addObject:obj];
        }
    }];
    NSMutableArray<ZFAddressCountryModel *> *sortSearchArray = [NSMutableArray arrayWithArray:[searchResult sortedArrayUsingComparator:^NSComparisonResult(ZFAddressCountryModel *  _Nonnull obj1, ZFAddressCountryModel *  _Nonnull obj2) {
        return obj1.hashCost > obj2.hashCost ? NSOrderedDescending : obj1.hashCost < obj2.hashCost ? NSOrderedAscending: NSOrderedSame;
    }]];
    return sortSearchArray;
}

#pragma mark - <UISearchBarDelegate>
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0 || self.countryArray.count == 0) {
        self.searchResultView.hidden = YES;
        return ;
    }
    //筛选处理数据源
    self.searchResultView.dataArray = [self smartMatchSearchResultWithKey:searchText];
    self.searchResultView.hidden = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchResultView.dataArray removeAllObjects];
    self.searchResultView.hidden = YES;
    searchBar.text = @"";
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keysArray.count;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countryList[self.keysArray[section]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCountryCell"];
    cell.textLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZFAddressCountryModel *model = self.countryList[self.keysArray[indexPath.section]][indexPath.row];
    cell.textLabel.text = model.region_name;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"addressContryHeaderIdentifer"];
    header.textLabel.text = self.keysArray[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.addressCountrySelectCompletionHandler) {
        self.addressCountrySelectCompletionHandler(self.countryList[self.keysArray[indexPath.section]][indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keysArray;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = ZFLocalizedString(@"ModifyAddress_Country_Placeholder", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchResultView];
}

- (void)zfAutoLayoutView {
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    
    [self.searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
}

#pragma mark - setter


#pragma mark - getter
- (ZFAddressCountryViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFAddressCountryViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFAddressCountrySearchResultView *)searchResultView {
    if (!_searchResultView) {
        _searchResultView = [[ZFAddressCountrySearchResultView alloc] initWithFrame:CGRectZero];
        _searchResultView.hidden = YES;
        
        @weakify(self);
        _searchResultView.addressCountryResultSelectCompletionHandler = ^(ZFAddressCountryModel *model) {
            @strongify(self);
            if (self.addressCountrySelectCompletionHandler) {
                self.addressCountrySelectCompletionHandler(model);
            }
            self.searchResultView.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _searchResultView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionIndexColor = [UIColor orangeColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addressCountryCell"];
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"addressContryHeaderIdentifer"];
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:nil completion:^(id obj) {
                @strongify(self);
                self.countryArray = obj;
                [self dealWithCountryInfoData];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }];
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.placeholder = ZFLocalizedString(@"Search_PlaceHolder_Search", nil);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (NSMutableArray *)keysArray {
    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    return _keysArray;
}

- (NSMutableDictionary<NSString *,NSMutableArray *> *)countryList {
    if (!_countryList) {
        _countryList = [NSMutableDictionary dictionary];
    }
    return _countryList;
}
@end
