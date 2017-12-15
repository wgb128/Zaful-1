//
//  ZFShareManager.m
//  Zaful
//
//  Created by TsangFa on 8/8/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFShareManager.h"
#import "NativeShareModel.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface ZFShareManager ()<FBSDKSharingDelegate>

@end

@implementation ZFShareManager
+ (instancetype)shareManager {
    static ZFShareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)shareToFacebook {
    FBSDKShareLinkContent  *content = [[FBSDKShareLinkContent alloc] init];
    NSString *encodString = [_model.share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",encodString]];
    content.contentURL = url;
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.shareContent = content;
    dialog.fromViewController = _model.fromviewController;
    dialog.delegate = self;
    dialog.mode = FBSDKShareDialogModeAutomatic;
    [dialog show];
}

- (void)shareToMessenger {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    NSString *encodString = [_model.share_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",encodString]];
    content.contentURL = url;
    
    FBSDKMessageDialog *messageDialog = [[FBSDKMessageDialog alloc] init];
    messageDialog.delegate = self;
    [messageDialog setShareContent:content];
    
    if ([messageDialog canShow]) {
        [messageDialog show];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/en/app/facebook-messenger/id454638411?mt=8"]];
    }
}

- (void)copyLinkURL {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *url = _model.share_url;
    if (url) {
        pasteboard.string = url;
    }
     [MBProgressHUD showMessage:ZFLocalizedString(@"Share_VC_Copied_Success", nil)];
}


#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if ([results[@"completionGesture"] isEqualToString:@"message"]) {
          [MBProgressHUD showMessage:ZFLocalizedString(@"Share_VC_Shared_Messenger_Success",nil)];
    }else{
        [MBProgressHUD showMessage:ZFLocalizedString(@"Share_VC_Shared_Facebook_Success",nil)];
    }
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
     [MBProgressHUD showMessage:ZFLocalizedString(@"Failed",nil)];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
     [MBProgressHUD showMessage:ZFLocalizedString(@"Share_VC_Cancel",nil)];
}



@end
