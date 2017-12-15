//
//  ZFCommunityVideoDetailCommentsListView.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailCommentsListView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityVideoDetailCommentsHeaderView.h"
#import "ZFCommunityVideoDetailCommentsListCell.h"

static NSString *const kZFCommunityVideoDetailCommentsHeaderViewIdentifier = @"kZFCommunityVideoDetailCommentsHeaderViewIdentifier";
static NSString *const kZFCommunityVideoDetailCommentsListCellIdentifier = @"kZFCommunityVideoDetailCommentsListCellIdentifier";
@interface ZFCommunityVideoDetailCommentsListView () <ZFInitViewProtocol, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@end

@implementation ZFCommunityVideoDetailCommentsListView
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZFCommunityVideoDetailCommentsHeaderView *headerView = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailCommentsHeaderViewIdentifier];
        return headerView;
    }
    
    ZFCommunityVideoDetailCommentsListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailCommentsListCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return ;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZFCommunityVideoDetailCommentsHeaderView class] forCellReuseIdentifier:kZFCommunityVideoDetailCommentsHeaderViewIdentifier];
        [_tableView registerClass:[ZFCommunityVideoDetailCommentsListCell class] forCellReuseIdentifier:kZFCommunityVideoDetailCommentsListCellIdentifier];
    }
    return _tableView;
}

@end
