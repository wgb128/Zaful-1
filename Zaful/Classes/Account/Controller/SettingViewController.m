//
//  SettingViewController.m
//  Zaful
//
//  Created by Y001 on 16/9/21.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "SettingViewController.h"
#import "ZFLangugeSettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZFLocalizedString(@"Setting_VC_Title",nil);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}

// 初始化表单
- (void)initializeForm {
    @weakify(self)
    // 表单对象
    XLFormDescriptor *form;
    // 表单Section对象
    XLFormSectionDescriptor *section;
    // 表单Row对象
    XLFormRowDescriptor *row;
    // 初始化form 顺便带个title
    form = [XLFormDescriptor formDescriptor];
    // 第一个Section
    section = [XLFormSectionDescriptor formSection];
    section.headerHeight = 0.1;
    section.footerHeight = 0.1;
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section1"  rowType:XLFormRowDescriptorTypeInfo];
    row.title = ZFLocalizedString(@"Setting_Cell_RateUs",nil);
    [row.cellConfig setObject:@(UITableViewCellAccessoryDisclosureIndicator) forKey:@"accessoryType"];
    
    row.action.formBlock = ^(XLFormRowDescriptor * sender){
        NSString *str = [NSString stringWithFormat:  @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",kCfgAppId ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    };
    [section addFormRow:row];
    
    // Info cell
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"section1"  rowType:XLFormRowDescriptorTypeInfo];
    row.title = ZFLocalizedString(@"Setting_Cell_ClearCache",nil);
    row.value = [NSString stringWithFormat:@"%.2fM",[self getCache]];
    row.action.formBlock = ^(XLFormRowDescriptor * sender){
        @strongify(self)
        YYImageCache *cache = [YYWebImageManager sharedManager].cache;
        // clear cache
        [cache.memoryCache removeAllObjects];
        [cache.diskCache removeAllObjects];
        sender.value = [NSString stringWithFormat:@"%.2fM",[self getCache]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:ZFLocalizedString(@"SettingViewModel_Cache_Alert_Message",nil) delegate:nil cancelButtonTitle:ZFLocalizedString(@"SettingViewModel_Cache_Alert_OK",nil) otherButtonTitles:nil, nil];
        [alert show];
    };
    [section addFormRow:row];
    
    // Info cell
    row= [XLFormRowDescriptor formRowDescriptorWithTag:@"section1"  rowType:XLFormRowDescriptorTypeInfo];
    row.title = ZFLocalizedString(@"Setting_Cell_Version",nil);
    row.value = ZFSYSTEM_VERSION;
    row.action.formBlock = ^(XLFormRowDescriptor * sender){
        @strongify(self)
        [self requestContrastVersion];
    };
    [section addFormRow:row];
    
    // language
    row= [XLFormRowDescriptor formRowDescriptorWithTag:@"section1"  rowType:XLFormRowDescriptorTypeInfo];
    row.title = ZFLocalizedString(@"Setting_Cell_Languege",nil);
    row.value = [[ZFLocalizationString shareLocalizable] currentLanguageName];
    row.action.formBlock = ^(XLFormRowDescriptor * sender){
        ZFLangugeSettingViewController *languageViewController = [[ZFLangugeSettingViewController alloc] init];
        [self.navigationController pushViewController:languageViewController animated:YES];
    };
    [section addFormRow:row];
    
    self.form = form;
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
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", @"https://itunes.apple.com/lookup?id=", kCfgAppId];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        ZFLog(@"%@", error.description);
        return;
    }
    
    NSArray *resultArray = [appInfoDict objectForKey:@"results"];
    if (![resultArray count]) {
        ZFLog(@"error : resultArray == nil");
        return;
    }
    
    //获取服务器上应用的最新版本号
    NSString * versionStr =[[[appInfoDict objectForKey:@"results"]objectAtIndex:0]valueForKey:@"version"];
    NSString *trackName = [NSString stringWithFormat:@"%@ %@",ZFLocalizedString(@"SettingViewModel_Version_Alert_Title", nil),versionStr];//infoDict[@"trackName"];
    
    //获取当前设备中应用的版本号
    //判断两个版本是否相同
    if ([versionStr compare:ZFSYSTEM_VERSION options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
        
        UIAlertController *alertController =  [UIAlertController
                                               alertControllerWithTitle:trackName
                                               message:ZFLocalizedString(@"SettingViewModel_Version_Alert_Message",nil)
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:ZFLocalizedString(@"SettingViewModel_Version_Alert_NotNow",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        UIAlertAction *updata = [UIAlertAction actionWithTitle:ZFLocalizedString(@"SettingViewModel_Version_Alert_Update",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/zaful/id%@?l=zh&ls=1&mt=8",kCfgAppId]];
            [[UIApplication sharedApplication] openURL:url];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:updata];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {  //版本号和app store上的一致
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:trackName message:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_Message",nil) delegate:nil cancelButtonTitle:ZFLocalizedString(@"SettingViewModel_Version_Latest_Alert_OK",nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}



@end

