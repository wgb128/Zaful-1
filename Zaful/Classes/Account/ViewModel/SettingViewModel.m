//
//  SettingViewModel.m
//  Zaful
//
//  Created by DBP on 17/2/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "SettingViewModel.h"

@interface SettingViewModel ()

@end

@implementation SettingViewModel

#pragma mark - tableviewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * celId = @"cellId";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:celId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = ZFLocalizedString(@"Setting_Cell_RateUs",nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            cell.textLabel.text = ZFLocalizedString(@"Setting_Cell_ClearCache",nil);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[self getCache]];
            
            break;
        case 2:
            cell.textLabel.text = ZFLocalizedString(@"Setting_Cell_Version",nil);
            cell.detailTextLabel.text = ZFSYSTEM_VERSION;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            NSString *str = [NSString stringWithFormat:  @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",1078789949 ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
            break;
        case 1:
        {
            YYImageCache *cache = [YYWebImageManager sharedManager].cache;
            // clear cache
            [cache.memoryCache removeAllObjects];
            [cache.diskCache removeAllObjects];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ZFLocalizedString(@"SettingViewModel_Cache_Alert_Message",nil) delegate:nil cancelButtonTitle:ZFLocalizedString(@"SettingViewModel_Cache_Alert_OK",nil) otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case 2:
            [self requestContrastVersion];
            break;
            
        default:
            break;
    }
}

#pragma maek - 获取缓存
- (CGFloat)getCache
{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    
    NSUInteger totalMemoryCacheBytes = cache.memoryCache.totalCost;
    
    NSUInteger totalDiskCacheBytes = cache.diskCache.totalCost;
    
    CGFloat totalMemoryCacheMega = totalMemoryCacheBytes / 1024.0 / 1204;
    
    CGFloat totalDiskCacheMega = totalDiskCacheBytes / 1024.0 / 1204;
    
    ZFLog(@"%.2f",totalMemoryCacheMega + totalDiskCacheMega);
    
    return (totalMemoryCacheMega + totalDiskCacheMega);
}

#pragma maek - 获取版本
- (void)requestContrastVersion
{
    NSError *error;
    //kAPP_URL : http://itunes.apple.com/lookup?id=
    //kAppId : 在iTunes connect上申请的APP ID
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"https://itunes.apple.com/lookup?id=", @"1078789949"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        NSLog(@"%@", error.description);
        return;
    }
    
    NSArray *resultArray = [appInfoDict objectForKey:@"results"];
    
    if (![resultArray count]) {
        NSLog(@"error : resultArray == nil");
        return;
    }
    
    NSDictionary *infoDict = [resultArray objectAtIndex:0];
    //获取服务器上应用的最新版本号
    NSString * versionStr =[[[appInfoDict objectForKey:@"results"]objectAtIndex:0]valueForKey:@"version"];
    NSString *trackName = infoDict[@"trackName"];
    
    //获取当前设备中应用的版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
    //判断两个版本是否相同
    if ([currentVersion floatValue] > [versionStr floatValue]) {
        NSString *titleStr = [NSString stringWithFormat:@"%@", trackName];
        NSString *messageStr = [NSString stringWithFormat:ZFLocalizedString(@"SettingViewModel_Version_Alert_Message",nil), versionStr];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:ZFLocalizedString(@"SettingViewModel_Version_Alert_NotNow",nil) otherButtonTitles:ZFLocalizedString(@"SettingViewModel_Version_Alert_Update",nil), nil];
        alert.tag = 10000;
        [alert show];
        
    } else {  //版本号和app store上的一致
        NSString *titleStr = [NSString stringWithFormat:@"%@", trackName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_Message",nil) delegate:nil cancelButtonTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma maek - 跳转AppStore
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000 ) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/zaful/id1078789949?l=zh&ls=1&mt=8"];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

@end
