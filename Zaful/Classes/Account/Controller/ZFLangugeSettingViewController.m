//
//  ZFLangugeSettingViewController.m
//  Zaful
//
//  Created by QianHan on 2017/10/24.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFLangugeSettingViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "ZFNavigationController.h"
#import <Firebase/Firebase.h>

@interface ZFLangugeSettingViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) NSArray *languageArray;
@property (nonatomic, strong) UITableView *langugeTableView;
@property (nonatomic, strong) UIImageView *accesoryImageView;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation ZFLangugeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupView];
}

- (void)setupView {
    [self.view addSubview:self.langugeTableView];
}

- (void)initData {
    self.title = ZFLocalizedString(@"Setting_Cell_Languege", nil);
    self.view.backgroundColor = ZFCOLOR(245.0, 245.0, 245.0, 1.0);
    self.languageArray = [ZFLocalizationString shareLocalizable].languageArray;
    [self selectIndex];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
}

- (void)selectIndex {
    _selectedIndex = 0;
    for (NSInteger i = 0; i < self.languageArray.count; i++) {
        NSString *languegeCode = self.languageArray[i][2];
        if ([languegeCode isEqualToString:[ZFLocalizationString shareLocalizable].nomarLocalizable]) {
            _selectedIndex = i;
            break;
        }
    }
}

#pragma mark - event
- (void)settingLanguge {
    [self reLoadRootViewController];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.languageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const kLangugeIdentifier = @"kLangugeIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLangugeIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLangugeIdentifier];
        cell.textLabel.textColor       = ZFCOLOR(51.0, 51.0, 51.0, 1.0);
        cell.textLabel.font            = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.textColor = ZFCOLOR(121, 121, 121, 1.0);
        cell.detailTextLabel.font      = [UIFont systemFontOfSize:14.0];
    }
    cell.textLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    cell.textLabel.text       = self.languageArray[indexPath.row][1];
//    cell.detailTextLabel.text = self.languageArray[indexPath.row][1];
    cell.selectionStyle       = UITableViewCellSelectionStyleNone;
    if (indexPath.row == _selectedIndex) {
        cell.accessoryView = self.accesoryImageView;
    } else {
        cell.accessoryView = [UIView new];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedIndex) {
        return;
    }
    self.saveButton.enabled = YES;
    _selectedIndex = indexPath.row;
    [tableView reloadData];
}

#pragma mark - privte method
- (void)reLoadRootViewController {
    
    NSString *oldLocalizable = [ZFLocalizationString shareLocalizable].nomarLocalizable;
    [ZFLocalizationString shareLocalizable].nomarLocalizable = self.languageArray[_selectedIndex][2];
    
    [ZFFireBaseAnalytics selectContentWithItemId:[NSString stringWithFormat:@"Language_%@", [ZFLocalizationString shareLocalizable].nomarLocalizable]
                                        itemName:@"Language_Change"
                                     ContentType:@"Language"
                                    itemCategory:@"UITableCell"];
    
    if ([SystemConfigUtils isCanRightToLeftShow]) {
        [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    } else {
        if (ISIOS9) {
            [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
        }
    }
    
    if (ISIOS11) {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_arrow_left"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_arrow_left"]];
    } else {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:[SystemConfigUtils isRightToLeftShow] ? @"nav_arrow_right" : @"nav_arrow_left"]];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate requestRateAndProfile:^{
        FIRApp *firApp = [FIRApp defaultApp];
        if (firApp) {
            [firApp deleteApp:^(BOOL success) {
                [appDelegate configurFireBase];
            }];
        }
        
        appDelegate.tabBarVC                  = [[ZFTabBarController alloc] init];
        appDelegate.window.rootViewController = appDelegate.tabBarVC;
        appDelegate.tabBarVC.selectedIndex    = TabBarIndexAccount;
        
        ZFNavigationController *currentNavigationController = appDelegate.tabBarVC.viewControllers[TabBarIndexAccount];
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        [currentNavigationController pushViewController:settingViewController animated:YES];
    } failure:^{
        [MBProgressHUD showMessage:ZFLocalizedString(@"Failed", nil)];
        [ZFLocalizationString shareLocalizable].nomarLocalizable = oldLocalizable;
        
        if ([SystemConfigUtils isCanRightToLeftShow]) {
            [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        } else {
            if (ISIOS9) {
                [UIView appearance].semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
            }
        }
    }];
}

#pragma mark - getter/setter
- (UITableView *)langugeTableView {
    if (!_langugeTableView) {
        _langugeTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _langugeTableView.delegate = self;
        _langugeTableView.dataSource = self;
        _langugeTableView.backgroundColor = [UIColor clearColor];
        _langugeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _langugeTableView.tableFooterView = [UIView new];
    }
    return _langugeTableView;
}

- (UIImageView *)accesoryImageView {
    if (!_accesoryImageView) {
        UIImage *image = [UIImage imageNamed:@"refine_select"];
        _accesoryImageView = [[UIImageView alloc] initWithImage:image];
        _accesoryImageView.backgroundColor = [UIColor clearColor];
        _accesoryImageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    }
    return _accesoryImageView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = [UIColor clearColor];
        _saveButton.enabled = NO;
        [_saveButton setTitleColor:ZFCOLOR(51.0, 51.0, 51.0, 1.0) forState:UIControlStateNormal];
        [_saveButton setTitleColor:ZFCOLOR(221.0, 221.0, 221.0, 1.0) forState:UIControlStateDisabled];
//        [_saveButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(settingLanguge) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *title = ZFLocalizedString(@"Profile_Save_Button", nil);
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:_saveButton.titleLabel.font.fontName size:_saveButton.titleLabel.font.pointSize]}];
        _saveButton.frame = CGRectMake(0.0, 0.0, titleSize.width, self.navigationController.navigationBar.height);
        [_saveButton setTitle:title forState:UIControlStateNormal];
    }
    return _saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
