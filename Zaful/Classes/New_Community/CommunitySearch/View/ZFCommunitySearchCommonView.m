
//
//  ZFCommunitySearchCommonView.m
//  Zaful
//
//  Created by liuxi on 2017/7/28.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchCommonView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunitySearchNoResultView.h"
#import "ZFCommunitySearchInviteFriendsView.h"
#import "ZFCommunitySearchSuggestUsersListCell.h"
#import "ZFCommunitySearchSuggestedUserHearderView.h"
#import "ZFCommunitySearchViewModel.h"
#import "ZFCommunitySuggestedUsersModel.h"

static NSString *const kZFCommunitySearchSuggestedUserHearderViewIdentifier = @"kZFCommunitySearchSuggestedUserHearderViewIdentifier";
static NSString *const kZFCommunitySearchSuggestUsersListCellIdentifier = @"kZFCommunitySearchSuggestUsersListCellIdentifier";


@interface ZFCommunitySearchCommonView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZFCommunitySearchNoResultView         *noResultView;
@property (nonatomic, strong) ZFCommunitySearchInviteFriendsView    *inviteFriendsView;
@property (nonatomic, strong) UITableView                           *recommonListView;
@property (nonatomic, strong) ZFCommunitySearchViewModel            *viewModel;

@property (nonatomic, strong) NSMutableArray<ZFCommunitySuggestedUsersModel *> *dataArray;
@end

@implementation ZFCommunitySearchCommonView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
        [self.recommonListView.mj_header beginRefreshing];
    }
    return self;
}

#pragma mark - private methods
- (void)communitySuggestUserFollowUserWithModel:(ZFCommunitySuggestedUsersModel *)model andIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [self.viewModel requestFollowedNetwork:model.user_id completion:^(id obj) {
        @strongify(self);
        ZFCommunitySuggestedUsersModel *model = self.dataArray[indexPath.row];
        self.dataArray[indexPath.row].isFollow = !model.isFollow;
        [self.recommonListView reloadData];
    } failure:^(id obj) {
        [self.recommonListView reloadData];
    }];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunitySearchSuggestUsersListCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                   kZFCommunitySearchSuggestUsersListCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    @weakify(self);
    
    cell.followUserCompletionHandler = ^(ZFCommunitySuggestedUsersModel *model) {
        @strongify(self);
        [self communitySuggestUserFollowUserWithModel:model andIndexPath:indexPath];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZFCommunitySuggestedUsersModel *model = self.dataArray[indexPath.row];
    if (self.communitySuggestedUserInfoCompletionHandler) {
        self.communitySuggestedUserInfoCompletionHandler(model.user_id);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 185;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZFCommunitySearchSuggestedUserHearderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kZFCommunitySearchSuggestedUserHearderViewIdentifier];
    return header;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(244, 244, 244, 1.f);
    [self addSubview:self.inviteFriendsView];
    [self addSubview:self.noResultView];
    [self addSubview:self.recommonListView];
    [self addSubview:self.maskView];
}

- (void)zfAutoLayoutView {
    [self.inviteFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(120 * SCREEN_WIDTH_SCALE);
    }];
    
    [self.noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(136 * SCREEN_WIDTH_SCALE);
    }];
    
    [self.recommonListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(120 * SCREEN_WIDTH_SCALE + 10, 0, 0, 0));
    }];
    

}

#pragma mark - setter
- (void)setNoResultTips:(BOOL)noResultTips {
    _noResultTips = noResultTips;
    self.noResultView.hidden = !_noResultTips;
    self.inviteFriendsView.hidden = _noResultTips;
}

#pragma mark - getter
- (ZFCommunitySearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunitySearchViewModel alloc] init];
    }
    return _viewModel;
}

- (ZFCommunitySearchInviteFriendsView *)inviteFriendsView {
    if (!_inviteFriendsView) {
        _inviteFriendsView = [[ZFCommunitySearchInviteFriendsView alloc] initWithFrame:CGRectZero];
        @weakify(self);
        _inviteFriendsView.inviteFacebookCompletionHandler = ^{
            @strongify(self);
            if (self.communityInviteFacebookCompletionHandler) {
                self.communityInviteFacebookCompletionHandler();
            }
        };
        
        _inviteFriendsView.inviteContactCompletionHandler = ^{
            @strongify(self);
            if (self.communityInviteContactsCompletionHandler) {
                self.communityInviteContactsCompletionHandler();
            }
        };
    }
    return _inviteFriendsView;
}

- (ZFCommunitySearchNoResultView *)noResultView {
    if (!_noResultView) {
        _noResultView = [[ZFCommunitySearchNoResultView alloc] initWithFrame:CGRectZero];
        _noResultView.hidden = YES;
    }
    return _noResultView;
}

- (UITableView *)recommonListView {
    if (!_recommonListView) {
        _recommonListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _recommonListView.backgroundColor = ZFCOLOR_WHITE;
        _recommonListView.delegate = self;
        _recommonListView.dataSource = self;
        _recommonListView.showsVerticalScrollIndicator = NO;
        _recommonListView.showsHorizontalScrollIndicator = NO;
        _recommonListView.tableFooterView = [UIView new];
        [_recommonListView registerClass:[ZFCommunitySearchSuggestUsersListCell class] forCellReuseIdentifier:kZFCommunitySearchSuggestUsersListCellIdentifier];
        [_recommonListView registerClass:[ZFCommunitySearchSuggestedUserHearderView class] forHeaderFooterViewReuseIdentifier:kZFCommunitySearchSuggestedUserHearderViewIdentifier];
        
        @weakify(self);
        _recommonListView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:LoadMore completion:^(id obj) {
                @strongify(self);
                if([obj isEqual: NoMoreToLoad]) {
                    [self.recommonListView.mj_footer endRefreshing];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.recommonListView.mj_footer.hidden = YES;
                    }];
                }else {
                    self.dataArray = obj;
                    [self.recommonListView reloadData];
                    [self.recommonListView.mj_footer endRefreshing];
                }
                
            } failure:^(id obj) {
                @strongify(self);
                [self.recommonListView reloadData];
                [self.recommonListView.mj_footer endRefreshing];
            }];
        }];
        
        _recommonListView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel requestNetwork:Refresh completion:^(id obj) {
                @strongify(self);
                self.dataArray = obj;
                [self.recommonListView reloadData];
                self.recommonListView.mj_footer.hidden = NO;
                [self.recommonListView.mj_header endRefreshing];
            } failure:^(id obj) {
                @strongify(self);
                [self.recommonListView reloadData];
                [self.recommonListView.mj_header endRefreshing];
            }];
        }];

    }
    return _recommonListView;
}

@end
