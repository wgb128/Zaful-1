
//
//  ZFCommunitySearchResultView.m
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchResultView.h"
#import "ZFInitViewProtocol.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZFCommunitySearchViewModel.h"
#import "ZFCommunitySearchResultCell.h"
#import "ZFCommunitySearchResultModel.h"

static NSString *const kZFCommunitySearchResultCellIdentifier = @"kZFCommunitySearchResultCellIdentifier";

@interface ZFCommunitySearchResultView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView                                    *tableView;

@property (nonatomic, strong) ZFCommunitySearchViewModel                     *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunitySearchResultModel *> *dataArray;
@end

@implementation ZFCommunitySearchResultView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - private methods
- (void)communityResultUserFollowUserWithModel:(ZFCommunitySearchResultModel *)model andIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [self.viewModel requestFollowedNetwork:model.user_id completion:^(id obj) {
        @strongify(self);
        ZFCommunitySearchResultModel *model = self.dataArray[indexPath.row];
        self.dataArray[indexPath.row].isFollow = !model.isFollow;
        [self.tableView reloadData];
    } failure:^(id obj) {
        [self.tableView reloadData];
    }];
}

#pragma mark - interface methods
- (void)clearOldSearchResultsInfo {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count < 5) {
        tableView.mj_footer.hidden = YES;
    } else {
        tableView.mj_footer.hidden = NO;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFCommunitySearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunitySearchResultCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    cell.searchResultFollowUserCompletionHandler = ^(ZFCommunitySearchResultModel *model) {
        @strongify(self);
        [self communityResultUserFollowUserWithModel:model andIndexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZFCommunitySearchResultModel *friendsResultModel = self.dataArray[indexPath.row];
    
    if (self.communitySearchResultUserInfoCompletionHandler) {
        self.communitySearchResultUserInfoCompletionHandler(friendsResultModel.user_id);
    }
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setSearchKey:(NSString *)searchKey {
    _searchKey = searchKey;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - getter
- (ZFCommunitySearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunitySearchViewModel alloc] init];
    }
    return _viewModel;
}

- (NSMutableArray<ZFCommunitySearchResultModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZFCommunitySearchResultCell class] forCellReuseIdentifier:kZFCommunitySearchResultCellIdentifier];
        
        @weakify(self);
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestSearchUsersNetwork:@[LoadMore,self.searchKey] completion:^(id obj) {
                @strongify(self);
                if([obj isEqual: NoMoreToLoad]) {
                    [self.tableView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.tableView.mj_footer.hidden = YES;
                    }];
                }else {
                    self.dataArray = obj;
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                }
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView.mj_footer endRefreshing];
            }];
        }];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            
            [self.viewModel requestSearchUsersNetwork:@[Refresh, self.searchKey] completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                self.tableView.mj_footer.hidden = NO;
                if (self.dataArray.count == 0 && self.communitySearchNoResultsCompletionHandler) {
                    self.communitySearchNoResultsCompletionHandler();
                }
                [self.tableView reloadData];
       
                [self.tableView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                [self.tableView.mj_header endRefreshing];
            }];
            
        }];
        
    }
    return _tableView;
}

@end
