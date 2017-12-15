//
//  ZFCommunityDetailReviewsView.m
//  Zaful
//
//  Created by liuxi on 2017/8/8.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityDetailReviewsView.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityDetailReviewsHeaderView.h"
#import "ZFCommunityDetailReviewsCell.h"

static NSString *const kZFCommunityDetailReviewsCellIdentifier = @"kZFCommunityDetailReviewsCellIdentifier";

@interface ZFCommunityDetailReviewsView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ZFCommunityDetailReviewsHeaderView    *reviewsHeaderView;
@property (nonatomic, strong) UITableView                           *tableView;
@end

@implementation ZFCommunityDetailReviewsView
#pragma mark - init methods
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self zfInitView];
        [self zfAutoLayoutView];
    }
    return self;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityDetailReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityDetailReviewsCellIdentifier forIndexPath:indexPath];
    return cell;
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.contentView.backgroundColor = ZFCOLOR_WHITE;
    [self.contentView addSubview:self.tableView];
}

- (void)zfAutoLayoutView {

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - getter
- (ZFCommunityDetailReviewsHeaderView *)reviewsHeaderView {
    if (!_reviewsHeaderView) {
        _reviewsHeaderView = [[ZFCommunityDetailReviewsHeaderView alloc] initWithFrame:CGRectZero];
    }
    return _reviewsHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = self.reviewsHeaderView;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[ZFCommunityDetailReviewsCell class] forCellReuseIdentifier:kZFCommunityDetailReviewsCellIdentifier];
    }
    return _tableView;
}

@end
