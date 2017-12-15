//
//  MessagesViewController.m
//  Zaful
//
//  Created by DBP on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessagesViewModel.h"
#import "MessagesListModel.h"

@interface MessagesViewController ()
@property (nonatomic,strong) MessagesViewModel *viewModel;
@property (nonatomic,strong) UITableView *messagesTableView;
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = ZFLocalizedString(@"MessagesViewModel_title", nil);
     [self.view addSubview:self.goodsTableView];
    [self requestMessagesData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followStatusChangeValue:) name:kFollowStatusChangeNotification object:nil];
}

#pragma mark - 接收关注通知
- (void)followStatusChangeValue:(NSNotification *)noti {
    //接收通知传过来的两个值 dict[@"isFollow"],dict[@"userId"]
    NSDictionary *dict = noti.object;
    BOOL isFollow = [dict[@"isFollow"] boolValue];
    NSString *followedUserId = dict[@"userId"];
    //遍历当前列表数组找到相同userId改变关注按钮状态
    [self.viewModel.dataArray enumerateObjectsUsingBlock:^(MessagesListModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.user_id isEqualToString:followedUserId]) {
            obj.isFollow = isFollow;
        }
    }];
    [self.messagesTableView reloadData];
}

- (void)requestMessagesData {
    @weakify(self)
    self.messagesTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[LoadMore] completion:^(id obj) {
            @strongify(self)
            [self.messagesTableView reloadData];
            if([obj isEqual: NoMoreToLoad]) {
                [self.messagesTableView.mj_footer endRefreshingWithNoMoreData];
                [UIView animateWithDuration:0.3 animations:^{
                    _messagesTableView.mj_footer.hidden = YES;
                }];
            }else {
                [self.messagesTableView.mj_footer endRefreshing];
            }
        } failure:^(id obj) {
            @strongify(self)
            [self.messagesTableView.mj_footer endRefreshing];
        }];
    }];
    
    self.messagesTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        @weakify(self)
        [self.viewModel requestNetwork:@[Refresh] completion:^(NSArray *obj) {
            @strongify(self)
            if (![NSArrayUtils isEmptyArray:obj]) {
            }
            
            [self.messagesTableView reloadData];
            if (self.messagesTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.messagesTableView.mj_footer resetNoMoreData];
            }
            [self.messagesTableView.mj_header endRefreshing];
        } failure:^(id obj) {
            @strongify(self)
            [self.messagesTableView.mj_header endRefreshing];
        }];
    }];
    [self.messagesTableView.mj_header beginRefreshing];

}

#pragma mark - Setter/Getter
-(UITableView *)goodsTableView {
    if (!_messagesTableView) {
        _messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _messagesTableView.rowHeight = 114;
        _messagesTableView.delegate = self.viewModel;
        _messagesTableView.dataSource = self.viewModel;
        _messagesTableView.showsVerticalScrollIndicator = YES;
        _messagesTableView.showsHorizontalScrollIndicator = NO;
        // 设置端距，这里表示separator离左边和右边均80像素
        _messagesTableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        _messagesTableView.backgroundColor = ZFCOLOR(255, 255, 255, 1.0);
        _messagesTableView.emptyDataSetSource = self.viewModel;
        _messagesTableView.emptyDataSetDelegate = self.viewModel;
        _messagesTableView.tableFooterView = [[UIView alloc] init];
    }
    return _messagesTableView;
}

-(MessagesViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MessagesViewModel alloc] init];
        _viewModel.controller = self;
    }
    return _viewModel;
}

@end
