//
//  GoodsSortViewController.m
//  Dezzal
//
//  Created by Y001 on 16/7/28.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "GoodsSortViewController.h"
#import "GoodsSortCell.h"

@interface GoodsSortViewController ()
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation GoodsSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _dataArray = [NSMutableArray arrayWithObjects:ZFLocalizedString(@"GoodsSortViewController_Type_Recommend",nil),ZFLocalizedString(@"GoodsSortViewController_Type_New",nil),ZFLocalizedString(@"GoodsSortViewController_Type_LowToHigh",nil),ZFLocalizedString(@"GoodsSortViewController_Type_HighToLow",nil),nil];
    //赋值_statusArray
    _statusArray = [NSMutableArray array];
    for (int i = 0;i<_dataArray.count;i++ ) {
        [_statusArray setObject:@"0" atIndexedSubscript:i];
    }
    [_statusArray setObject:@"1" atIndexedSubscript:_selectIndex];
    [self setUI];
    [self initView];
}

#pragma mark - UI

- (void)setUI{
    self.navigationItem.title = ZFLocalizedString(@"GoodsSort_VC_Title",nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"category_delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
}

#pragma mark - 布局
/**
 *  布局界面
 */
- (void)initView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

/**
 *  关闭按钮
 */
- (void)closeClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  确定按钮
 *
 *  @param btn <#btn description#>
 */
- (void)doneClick
{
    @weakify(self)

    //数组里内容不要翻译，传递给后台的
    NSArray * sortArray = [NSArray arrayWithObjects:@"recommend",@"new_arrivals",@"price_low_to_high",@"price_high_to_low", nil];

    if(self.sortBlock)
    {
        @strongify(self)
     //找到选择的目标
        self.sortBlock(_selectIndex,sortArray[_selectIndex]);
    }
    [self closeClick];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableviewDelegate,UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSortCell * cell = [GoodsSortCell GoodsSortCellWithTableView:tableView andIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.typeLabel.text =_dataArray[indexPath.row];
    if (indexPath.row == _selectIndex) {
        [cell.typeLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
        [cell.selectImg setImage:[UIImage imageNamed:@"category_choose"]];
    }
    else
    {
        [cell.typeLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.selectImg setImage:nil];
    }
    cell.selectImgClick = ^(NSIndexPath * indexPath)
    {
        for (int i = 0; i<_statusArray.count; i++) {
            [_statusArray setObject:@"0" atIndexedSubscript:i];
        }
        [_statusArray setObject:@"1" atIndexedSubscript:indexPath.row];
        _selectIndex = indexPath.row;
        [_tableView reloadData];
        [self performSelector:@selector(doneClick) withObject:nil afterDelay:0.3];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    if ([_statusArray[indexPath.row] isEqualToString:@"0"]) {
        for (int i =0; i<_statusArray.count; i++) {
            [_statusArray setObject:@"0" atIndexedSubscript:i];
        }
        [_statusArray setObject:@"1" atIndexedSubscript:_selectIndex];
        [_tableView reloadData];
    }
    [self performSelector:@selector(doneClick) withObject:nil afterDelay:0.3];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.001;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
