

//
//  ZFCommunityDetailViewController.m
//  Zaful
//
//  Created by Apple on 2017/8/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityDetailViewModel.h"
#import "ZFCommunityDetailHeaderView.h"
#import "ZFCommunityDetailProductListView.h"
#import "ZFCommunityDetailReviewsView.h"
#import "ZFCommunityDetailModel.h"
#import "ZFCommunityDetailReviewsModel.h"
#import "InputTextView.h"

static NSString *const kZFCommunityDetailHeaderViewIdentifier = @"kZFCommunityDetailHeaderViewIdentifier";
static NSString *const kZFCommunityDetailProductListViewIdentifier = @"kZFCommunityDetailProductListViewIdentifier";
static NSString *const kZFCommunityDetailReviewsViewIdentifier = @"kZFCommunityDetailReviewsViewIdentifier";

@interface ZFCommunityDetailViewController () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) InputTextView                 *reviewsView;
@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) ZFCommunityDetailViewModel    *viewModel;
@property (nonatomic, strong) ZFCommunityDetailModel        *model;

@property (nonatomic, strong) NSMutableArray<ZFCommunityDetailReviewsModel *> *reviewsList;
@end

@implementation ZFCommunityDetailViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
    
}

#pragma mark - private methods
- (void)requestCommunityDetailInfo {
    @weakify(self);
    [self.viewModel requestNetwork:self.reviewsId completion:^(id obj) {
        @strongify(self);
        self.model = obj;
        self.model.reviewsId = self.reviewsId;
        
    } failure:^(id obj) {
        
    }];
}

- (void)requestCommunityDetailReviewsInfo {
    [self.viewModel requestReviewsListNetwork:@[@(1), self.reviewsId] completion:^(id obj) {
        self.reviewsList = [NSMutableArray arrayWithArray:obj];
    } failure:^(id obj) {
        
    }];
}

#pragma mark - action methods


#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFCommunityDetailHeaderView *headerView = [tableView dequeueReusableCellWithIdentifier:kZFCommunityDetailHeaderViewIdentifier];
        return headerView;
    } else if (indexPath.section == 1) {
        ZFCommunityDetailProductListView *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityDetailProductListViewIdentifier];
        return cell;
    } else if (indexPath.section == 2) {
        ZFCommunityDetailReviewsView *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityDetailReviewsViewIdentifier];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}


#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.reviewsView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    
    [self.reviewsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - setter
- (void)setReviewsId:(NSString *)reviewsId {
    _reviewsId = reviewsId;
    [self requestCommunityDetailInfo];
}

#pragma mark -getter
- (ZFCommunityDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunityDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZFCommunityDetailHeaderView class] forCellReuseIdentifier:kZFCommunityDetailHeaderViewIdentifier];
        [_tableView registerClass:[ZFCommunityDetailProductListView class] forCellReuseIdentifier:kZFCommunityDetailProductListViewIdentifier];
        [_tableView registerClass:[ZFCommunityDetailReviewsView class] forCellReuseIdentifier:kZFCommunityDetailReviewsViewIdentifier];
        
    }
    return _tableView;
}

- (InputTextView *)reviewsView {
    if (!_reviewsView) {
        _reviewsView = [[InputTextView alloc] initWithFrame:CGRectZero];
        _reviewsView.backgroundColor = [UIColor colorWithWhite:255 alpha:0];
        [_reviewsView setPlaceholderText:ZFLocalizedString(@"CommunityDetail_VC_TextView_Placeholder",nil)];
    }
    return _reviewsView;
}
@end
