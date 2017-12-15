//
//  ContactsViewController.m
//  Zaful
//
//  Created by TsangFa on 17/1/14.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsViewModel.h"
#import <MessageUI/MessageUI.h>
#import "PPPersonModel.h"
#import "PPAddressBookHandle.h"
#define kPPAddressBookHandle [PPAddressBookHandle sharedAddressBookHandle]

@interface ContactsViewController ()<MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIButton *sendButton;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) ContactsViewModel *viewModel;
@property (nonatomic,strong) NSMutableArray *phoneArray;
@end

@implementation ContactsViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZFLocalizedString(@"Contacts_VC_Title",nil);
    
    [self configureUI];
    
    [kPPAddressBookHandle requestAuthorizationWithSuccessBlock:^{
        [self.viewModel loadContactsDataCompletion:^(id obj) {
            [self.tableView reloadData];
        }];
    } failure:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertView"
                                                            message:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure_Message",nil)                                                       delegate:self
                                                  cancelButtonTitle:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure__OK",nil)
                                                  otherButtonTitles:nil];
             */
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure_Title",nil)
                                                            message:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure_Message",nil)                                                       delegate:self
                                                  cancelButtonTitle:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure__OK",nil)
                                                  otherButtonTitles:ZFLocalizedString(@"ContactsViewModel_AuthorizationFailure__GoToSetting",nil),nil];
            
            alert.tag = 101;
            [alert show];
        });
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
         [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSURL *urlSetting = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if (urlSetting) {
            if ([[UIApplication sharedApplication] canOpenURL:urlSetting]) {
                
                [[UIApplication sharedApplication] openURL:urlSetting];
            }
        }
    }
}

#pragma mark - UI
- (void)configureUI {
    [self.view addSubview:self.tableView];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:self.sendButton];
    self.navigationItem.rightBarButtonItem = item;
};

#pragma mark - Button Action
- (void)sendBtnClicked:(UIButton *)sender {
    if (self.phoneArray.count <= 0) {
        return;
    }
    NSString *message = ZFLocalizedString(@"Contacts_VC_Message",nil);
    [self showMessageView:self.phoneArray title:@"Message" body:message];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        // --phones发短信的手机号码的数组，数组中是一个即单发,多个即群发。
        controller.recipients = phones;
        // --短信界面 BarButtonItem (取消按钮) 颜色
        controller.navigationBar.tintColor = [UIColor redColor];
        // --短信内容
        controller.body = body;
        controller.messageComposeDelegate = self;
        controller.title = @"哈哈哈哈";
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"该设备不支持短信功能"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    controller.recipients = nil;
    controller.body = nil;
    controller.title = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消发送");
            break;
            
        case MessageComposeResultSent:
            NSLog(@"已发送");
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
            
        default:
            break;
    }
}

#pragma mark - Lazyload
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableView.rowHeight = 40;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self.viewModel;
        _tableView.dataSource = self.viewModel;
        _tableView.sectionIndexColor = ZFCOLOR(255, 168, 0, 1);
    }
    return _tableView;
}

-(ContactsViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ContactsViewModel alloc] init];
        _viewModel.controller = self;
        @weakify(self)
        _viewModel.countBlock = ^(NSArray *array){
            @strongify(self)
            NSString *countStr;
            if (array.count <= 0) {
                if ([SystemConfigUtils isRightToLeftShow]) {
                    countStr = [NSString stringWithFormat:@"(%ld)%@",(unsigned long)array.count,ZFLocalizedString(@"Contacts_VC_Send",nil)];
                } else {
                    countStr = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"Contacts_VC_Send",nil),(unsigned long)array.count];
                }
                
            }else{
                if ([SystemConfigUtils isRightToLeftShow]) {
                    countStr = [NSString stringWithFormat:@"(%ld)%@",(unsigned long)array.count,ZFLocalizedString(@"Contacts_VC_Send",nil)];
                } else {
                    countStr = [NSString stringWithFormat:@"%@(%ld)",ZFLocalizedString(@"Contacts_VC_Send",nil),(unsigned long)array.count];
                }
            }
            [self.sendButton setTitle:countStr forState:UIControlStateNormal];
            
            NSMutableArray *temp = [NSMutableArray array];
            for (PPPersonModel *model in array) {
                NSString *phone = [NSString stringWithFormat:@"%@",model.mobileArray.firstObject];
                [temp addObject:phone];
            }
            self.phoneArray = temp;
        };
    }
    return _viewModel;
}

-(UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([SystemConfigUtils isRightToLeftShow]) {
            [_sendButton setTitle:[NSString stringWithFormat:@"(0)%@",ZFLocalizedString(@"Contacts_VC_Send",nil)] forState:UIControlStateNormal];
            ;
        } else {
            [_sendButton setTitle:[NSString stringWithFormat:@"%@(0)",ZFLocalizedString(@"Contacts_VC_Send",nil)] forState:UIControlStateNormal];
        }
        
        [_sendButton addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.frame = CGRectMake(0, 0, 60, 40);
        [_sendButton setTitleColor:ZFCOLOR(255, 168, 0, 1) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _sendButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_sendButton sizeToFit];
    }
    return _sendButton;
}

-(NSMutableArray *)phoneArray {
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

@end
