

//
//  ZFAddressStateSearchResultView.m
//  Zaful
//
//  Created by liuxi on 2017/9/6.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFAddressStateSearchResultView.h"
#import "ZFInitViewProtocol.h"
#import "ZFAddressStateModel.h"

@interface ZFAddressStateSearchResultView () <ZFInitViewProtocol, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView           *tableView;
@end

@implementation ZFAddressStateSearchResultView
#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressStateCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZFAddressStateModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.provinceName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.addressStateSearchSelectCompletionHandler) {
        self.addressStateSearchSelectCompletionHandler(self.dataArray[indexPath.row]);
    }
}

#pragma mark - <ZFInitViewProtocol>
- (void)zfInitView {
    self.backgroundColor = ZFCOLOR(247, 247, 247, 1.f);
    [self addSubview:self.tableView];
}

- (void)zfAutoLayoutView {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - setter
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"addressStateCell"];
    }
    return _tableView;
}

@end
