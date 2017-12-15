//
//  ZFCommunitySearchFriendsViewController.m
//  Zaful
//
//  Created by liuxi on 2017/7/26.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunitySearchFriendsViewController.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunitySearchResultView.h"
#import "ZFCommunitySearchCommonView.h"
#import "ZFCommunitySearchViewModel.h"

@interface ZFCommunitySearchFriendsViewController () <ZFInitViewProtocol, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar                       *friendSearchBar;
@property (nonatomic, strong) ZFCommunitySearchResultView       *resultView;
@property (nonatomic, strong) ZFCommunitySearchCommonView       *commonView;

@property (nonatomic, strong) ZFCommunitySearchViewModel  *viewModel;
@end

@implementation ZFCommunitySearchFriendsViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zfInitView];
    [self zfAutoLayoutView];
}

#pragma mark - private methods
- (void)followCommunityUserWithUserId:(NSString *)userId {
    
}

#pragma mark - action methods
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UISearchBarDelegate>
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.commonView.hidden = NO;
    self.resultView.hidden = YES;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.commonView.hidden = NO;
    self.resultView.hidden = YES;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if(searchBar.returnKeyType != UIReturnKeySearch || searchBar.text.length <= 0) {
        self.commonView.hidden = NO;
        self.resultView.hidden = YES;
        return ;
    }
    self.commonView.hidden = YES;
    self.resultView.hidden = NO;
    self.resultView.searchKey = searchBar.text;
    [searchBar resignFirstResponder];
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.title = NSLocalizedString(@"FavesViewModel_NoData_AddMoreFriends", nil);
    self.view.backgroundColor = ZFCOLOR_WHITE;
    [self.view addSubview:self.friendSearchBar];
    [self.view addSubview:self.commonView];
    [self.view addSubview:self.resultView];
}

- (void)zfAutoLayoutView {
    [self.friendSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.commonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.friendSearchBar.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
    
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.friendSearchBar.mas_bottom);
        make.leading.trailing.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - getter
- (UISearchBar *)friendSearchBar {
    if (!_friendSearchBar) {
        _friendSearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        _friendSearchBar.barTintColor = ZFCOLOR(246, 246, 246, 1.0);
        _friendSearchBar.backgroundImage = [UIImage new];
        _friendSearchBar.searchBarStyle = UISearchBarStyleDefault;
        _friendSearchBar.translucent = NO; //是否半透明
        _friendSearchBar.showsCancelButton = YES;
        [_friendSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _friendSearchBar.returnKeyType = UIReturnKeySearch; //设置按键类型
        _friendSearchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        [_friendSearchBar sizeToFit];
        _friendSearchBar.placeholder = ZFLocalizedString(@"Search_PlaceHolder_Search",nil);
        _friendSearchBar.delegate = self;
        
        if ([SystemConfigUtils isRightToLeftShow]) {
            UITextField *searchField = [_friendSearchBar valueForKey:@"searchField"];
            searchField.textAlignment = NSTextAlignmentRight;
        }
    }
    return _friendSearchBar;
}

- (ZFCommunitySearchResultView *)resultView {
    if (!_resultView) {
        _resultView = [[ZFCommunitySearchResultView alloc] initWithFrame:CGRectZero];
        _resultView.hidden = YES;
        @weakify(self);
        _resultView.communitySearchResultUserInfoCompletionHandler = ^(NSString *userId) {
            @strongify(self);
            [self followCommunityUserWithUserId:userId];
        };
    }
    return _resultView;
}

- (ZFCommunitySearchCommonView *)commonView {
    if (!_commonView) {
        _commonView = [[ZFCommunitySearchCommonView alloc] initWithFrame:CGRectZero];
        
    }
    return _commonView;
}

- (ZFCommunitySearchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ZFCommunitySearchViewModel alloc] init];
    }
    return _viewModel;
}
@end
