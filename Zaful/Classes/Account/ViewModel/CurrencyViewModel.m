//
//  CurrencyViewModel.m
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "CurrencyViewModel.h"
#import "GoodsSortCell.h"
#import "RateModel.h"

@interface CurrencyViewModel ()
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation CurrencyViewModel

- (void)requestData {
    _dataArray = [self getTheExchangeCurrencyList];
}

#pragma mark 获取不同汇率
- (NSArray *)getTheExchangeCurrencyList {
    
    NSArray *array = [ExchangeManager currencyList];
    NSMutableArray * currencyListArray = [NSMutableArray arrayWithCapacity:4];
    for (RateModel *model in array) {
        NSString *needString = [NSString stringWithFormat:@"%@ %@",model.symbol,model.code];
        [currencyListArray addObject:needString];
    }
    return currencyListArray.copy;
}

#pragma mark - UITableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ExchangeManager updateLocalCurrency:_dataArray[indexPath.row]];
    if (self.selectCurrencyBlock) {
        self.selectCurrencyBlock([ExchangeManager localCurrency]);
    }
    [_tableView reloadData];
    /**
     *  发送改变货币类型通知
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrencyNotification object:nil];
    
    [self.controller.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currencyCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currencyCell"];
    }
    cell.textLabel.textAlignment = [SystemConfigUtils isRightToLeftShow] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text =_dataArray[indexPath.row];
    cell.accessoryView = [_dataArray[indexPath.row] isEqualToString:[ExchangeManager localCurrency]] ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose"]] : nil;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
@end
