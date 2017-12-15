
//
//  ZFCommunityVideoDetailProductListCell.m
//  Zaful
//
//  Created by liuxi on 2017/8/7.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCommunityVideoDetailProductListCell.h"
#import "ZFInitViewProtocol.h"
#import "ZFCommunityVideoDetailProductInfoCell.h"

static NSString *const kZFCommunityVideoDetailProductInfoCellIdentifier = @"kZFCommunityVideoDetailProductInfoCellIdentifier";

@interface ZFCommunityVideoDetailProductListCell () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView       *tableView;
@end

@implementation ZFCommunityVideoDetailProductListCell
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFCommunityVideoDetailProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:kZFCommunityVideoDetailProductInfoCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[ZFCommunityVideoDetailProductInfoCell class] forCellReuseIdentifier:kZFCommunityVideoDetailProductInfoCellIdentifier];
    }
    return _tableView;
}
@end
