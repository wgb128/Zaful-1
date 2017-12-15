//
//  FriendsViewController.m
//  Zaful
//
//  Created by zhaowei on 2017/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsCommendViewModel.h"
#import "FriendsResultViewModel.h"
#import "CommendUserCell.h"
#import "FriendsResultCell.h"
#import "FriendsResultModel.h"
#import "CommendUserModel.h"

@interface FriendsViewController ()<UISearchBarDelegate>
@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,weak) UITableView *commendTableView;
@property (nonatomic,weak) UITableView *resultTableView;

@property (nonatomic,strong) FriendsCommendViewModel *commendViewModel;
@property (nonatomic,strong) FriendsResultViewModel *resultViewModel;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self requestCommendData];
    [self.commendTableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
}

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.resultViewModel.dataArray enumerateObjectsUsingBlock:^(FriendsResultModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.user_id isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.resultTableView reloadData];
    
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.commendViewModel.dataArray enumerateObjectsUsingBlock:^(CommendUserModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.user_id isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.commendTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = ZFLocalizedString(@"AddMoreFriends_VC_Title",nil);
}

-(void)viewDidLayoutSubviews {
    if ([self.commendTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.commendTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.commendTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.commendTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.resultTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.resultTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)requestCommendData {
    @weakify(self)
    self.commendTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.commendViewModel requestNetwork:LoadMore completion:^(id obj) {
            @strongify(self)
            [self.commendTableView reloadData];
            
            if([obj isEqual: NoMoreToLoad]) {
                [self.commendTableView.mj_footer endRefreshingWithNoMoreData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.commendTableView.mj_footer.hidden = YES;
                }];
                
            }else {
                [self.commendTableView.mj_footer endRefreshing];
            }
            
        } failure:^(id obj) {
            @strongify(self)
            [self.commendTableView reloadData];
            [self.commendTableView.mj_footer endRefreshing];
        }];
    }];
    
    self.commendTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.commendViewModel requestNetwork:Refresh completion:^(id obj) {
            @strongify(self)
            [self.commendTableView reloadData];
            if (self.commendTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.commendTableView.mj_footer resetNoMoreData];
            }
            [self.commendTableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.commendTableView reloadData];
            [self.commendTableView.mj_header endRefreshing];
        }];
    }];
}

- (void)requestResultData {
    @weakify(self)
    self.resultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.resultViewModel requestNetwork:LoadMore completion:^(id obj) {
            @strongify(self)
            [self.resultTableView reloadData];
            
            if([obj isEqual: NoMoreToLoad]) {
                [self.resultTableView.mj_footer endRefreshingWithNoMoreData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.resultTableView.mj_footer.hidden = YES;
                }];
                
            }else {
                [self.resultTableView.mj_footer endRefreshing];
            }
            
        } failure:^(id obj) {
            @strongify(self)
            [self.resultTableView reloadData];
            [self.resultTableView.mj_footer endRefreshing];
        }];
    }];
    
    self.resultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.resultViewModel requestNetwork:Refresh completion:^(id obj) {
            @strongify(self)
            [self.resultTableView reloadData];
            if (self.resultTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.resultTableView.mj_footer resetNoMoreData];
            }
            [self.resultTableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.resultTableView reloadData];
            [self.resultTableView.mj_header endRefreshing];
        }];
    }];
}

- (void)initView {
    //设置选项
    UISearchBar *searchBar  = [[UISearchBar alloc] init];
    searchBar.barTintColor = ZFCOLOR(246, 246, 246, 1.0);
    searchBar.backgroundImage = [UIImage new];
    searchBar.searchBarStyle = UISearchBarStyleDefault;
    searchBar.translucent = NO; //是否半透明
    searchBar.showsCancelButton = YES;
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    searchBar.returnKeyType = UIReturnKeySearch; //设置按键类型
    searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [searchBar sizeToFit];
    searchBar.placeholder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
    searchBar.delegate = self;

    if ([SystemConfigUtils isRightToLeftShow]) {
        UITextField *searchField = [searchBar valueForKey:@"searchField"];
        searchField.textAlignment = NSTextAlignmentRight;
    }
    // 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    UIView *searchView=[searchBar.subviews objectAtIndex:0];
    if (searchView) {
        for (id search in searchView.subviews) {
            if ([search isKindOfClass:[UITextField class]] || [search isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                if ([SystemConfigUtils isRightToLeftShow]) {
                    UITextField *searchField = (UITextField *)search;
                    searchField.textAlignment = NSTextAlignmentRight;
                }
            } else if ([search isKindOfClass:NSClassFromString(@"UINavigationButton")]){
                UIButton *barCancleButton=(UIButton *)search;
                // 修改文字颜色
                [barCancleButton setTitle:ZFLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
                [barCancleButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateNormal];
                [barCancleButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateHighlighted];
                barCancleButton.titleLabel.font = [UIFont systemFontOfSize:10];
            }
        }
    }
    
//    for (UIView *cancelBtn in [searchBar subviews]) {
//            if ([cancelBtn isKindOfClass:[UIButton class]]) {
//                UIButton *cancelButton = (UIButton*)cancelBtn;
//                // 修改文字颜色
//                [cancelButton setTitle:ZFLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
//                [cancelButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateNormal];
//                [cancelButton setTitleColor:ZFCOLOR(255, 168, 0, 1.0) forState:UIControlStateHighlighted];
//                
//            }
//    }
    
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
    }];
    self.searchBar = searchBar;
    
    
    UITableView *commendTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    commendTableView.delegate = self.commendViewModel;
    commendTableView.dataSource = self.commendViewModel;
    [commendTableView registerClass:[CommendUserCell class] forCellReuseIdentifier:COMMENDUSER_CELL_INENTIFIER];
    [self.view addSubview:commendTableView];
    [commendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    commendTableView.tableFooterView = [UIView new];
    self.commendTableView = commendTableView;
    
    UITableView *resultTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    resultTableView.hidden = YES;
    resultTableView.delegate = self.resultViewModel;
    resultTableView.dataSource = self.resultViewModel;
    resultTableView.emptyDataSetSource = self.resultViewModel;
    resultTableView.emptyDataSetDelegate = self.resultViewModel;
    [resultTableView registerClass:[FriendsResultCell class] forCellReuseIdentifier:FRIENDSRESULT_CELL_INENTIFIER];
    [self.view addSubview:resultTableView];
    [resultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchBar.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    self.resultTableView = resultTableView;
    self.resultViewModel.friendResultTableView = self.resultTableView;
}

#pragma mark - Setter/Getter
-(FriendsCommendViewModel *)commendViewModel {
    if (!_commendViewModel) {
        _commendViewModel = [[FriendsCommendViewModel alloc] init];
        _commendViewModel.controller = self;
    }
    return _commendViewModel;
}

#pragma mark - Setter/Getter
-(FriendsResultViewModel *)resultViewModel {
    if (!_resultViewModel) {
        _resultViewModel = [[FriendsResultViewModel alloc] init];
        _resultViewModel.controller = self;
    }
    return _resultViewModel;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.commendTableView.hidden = YES;
    self.resultTableView.hidden = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.commendTableView.hidden = NO;
    self.resultTableView.hidden = YES;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(searchBar.returnKeyType==UIReturnKeySearch) {
        if ([searchBar.text length] > 0) {
            [searchBar resignFirstResponder];
            @weakify(self)
            self.resultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                @strongify(self)
                @weakify(self)
                [self.resultViewModel requestNetwork:@[LoadMore,searchBar.text] completion:^(id obj) {
                    @strongify(self)
                    [self.resultTableView reloadData];
                    
                    if([obj isEqual: NoMoreToLoad]) {
                        [self.resultTableView.mj_footer endRefreshingWithNoMoreData];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            self.resultTableView.mj_footer.hidden = YES;
                        }];
                        
                    }else {
                        [self.resultTableView.mj_footer endRefreshing];
                    }

                } failure:^(id obj) {
                    @strongify(self)
                    [self.resultTableView reloadData];
                    [self.resultTableView.mj_footer endRefreshing];
                }];
            }];
            
            self.resultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                @strongify(self)
                @weakify(self)
                [self.resultViewModel requestNetwork:@[Refresh,searchBar.text] completion:^(NSArray *obj) {
                    @strongify(self)
                    if (![NSArrayUtils isEmptyArray:obj]) {
                    }
                    
                    [self.resultTableView reloadData];
                    if (self.resultTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                        [self.resultTableView.mj_footer resetNoMoreData];
                    }
                    [self.resultTableView.mj_header endRefreshing];
                } failure:^(id obj) {
                    @strongify(self)
                    [self.resultTableView.mj_header endRefreshing];
                }];
            }];
            [self.resultTableView.mj_header beginRefreshing];


        }
    }
}

@end
