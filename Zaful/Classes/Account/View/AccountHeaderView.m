
//
//  AccountHeaderView.m
//  Dezzal
//
//  Created by 7FD75 on 16/7/27.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "AccountHeaderView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#import "UploadUserIconApi.h"
#import "AliImageReshapeController.h"

// 空页面的类型
typedef NS_ENUM(NSUInteger, MyPhotoChooseType){
    MyPhotoTakePhotoType = 0,  //来源:相机
    MyPhotoAlbumsType = 1     //来源:相册
};

@interface AccountHeaderView () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ALiImageReshapeDelegate>
@property (nonatomic, strong) UIButton *userInfoEditBtn;
@property (nonatomic, strong) YYAnimatedImageView *userIcon;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIView *hLineView;
@property (nonatomic, strong) UIView *bottomBackView;
@property (nonatomic, strong) UILabel *userLevelLabel;
@property (nonatomic, strong) UIView *starContainerView;
@property (nonatomic, strong) UILabel *userEmailLabel;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) UploadUserIconApi *uploadIconApi;
@property (nonatomic, strong) UIImage *uploadedImage;

@end

@implementation AccountHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviewsContraint];
    }
    return self;
}

- (void)refreshAcccountHeaderData {
    NSString *firstName = [NSStringUtils isEmptyString:[AccountManager sharedManager].account.firstname] == NO ? [AccountManager sharedManager].account.firstname:@"";
    NSString *lastname = [NSStringUtils isEmptyString:[AccountManager sharedManager].account.lastname] == NO ? [AccountManager sharedManager].account.lastname:@"";
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@",firstName,lastname];
    self.userEmailLabel.text = [AccountManager sharedManager].account.email;
    [self.userIcon yy_setImageWithURL:[NSURL URLWithString:[AccountManager sharedManager].account.avatar]
                         processorKey:NSStringFromClass([self class])
                          placeholder:[UIImage imageNamed:@"photo_default"]];
}

- (void)addSubviewsContraint {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.userInfoEditBtn];
    [self.userInfoEditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(self);
        make.size.mas_equalTo(@48);
    }];
    
    [self addSubview:self.userIcon];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(@80);
    }];
    
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userIcon.mas_bottom);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - 40));
        make.height.mas_equalTo(@30);
    }];
    
    [self addSubview:self.hLineView];
    [self.hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom);
        make.leading.trailing.mas_equalTo(self);
        make.height.mas_equalTo(@(MIN_PIXEL));
    }];
    
    [self addSubview:self.bottomBackView];
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hLineView.mas_bottom).offset(0);
        make.trailing.leading.mas_equalTo(self);
        make.height.mas_equalTo(@40);
    }];
    
    [self.bottomBackView addSubview:self.userEmailLabel];
    [self.userEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomBackView.mas_top);
        make.leading.mas_equalTo(self.bottomBackView.mas_leading).offset(12);
        make.centerY.mas_equalTo(self.bottomBackView.mas_centerY);
        make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - 12 * 2));
    }];
}

- (void)userInfoEditBtnClick {
    if ([self.delegate respondsToSelector:@selector(accountHeaderViewEditBtnClick:)]) {
        [self.delegate accountHeaderViewEditBtnClick:self];
    }
}

#pragma mark - 头像点击 action
- (void)userIconClick {
    UIAlertController *alertController =  [UIAlertController
                                           alertControllerWithTitle: nil
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * takePhotoAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"AccoundHeaderView_TackPhoto",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self choosePhotoAction:MyPhotoTakePhotoType];
    }];
    UIAlertAction * albumsAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"AccoundHeaderView_ChooseAlbum",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self choosePhotoAction:MyPhotoAlbumsType];
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:ZFLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:takePhotoAction];
    [alertController addAction:albumsAction];
    [alertController addAction:cancelAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 进入拍照或选择照片
- (void)choosePhotoAction:(MyPhotoChooseType)chooseType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    UIBarButtonItem *barItem;
    if (ISIOS9) {
        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
    } else {
        barItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
    }
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (chooseType) {
            case MyPhotoTakePhotoType:
            {
                if (![self isCanUseCamera]) {
                    [MBProgressHUD showMessage:ZFLocalizedString(@"AccoundHeaderView_Settings_Camera",nil)];
                    return;
                }
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.allowsEditing = YES;
            }
                break;
            case MyPhotoAlbumsType:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
                break;
            default:
                break;
        }
    }
    else {
        if(chooseType == MyPhotoTakePhotoType) {
            [MBProgressHUD showMessage:ZFLocalizedString(@"AccoundHeaderView_Divice_Unavailable",nil)];
            return;
        }
        else {
            if (![self isCanUsePhotos]) {
                [MBProgressHUD showMessage:ZFLocalizedString(@"AccoundHeaderView_Settings_Photos",nil)];
                return;
            }
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    [self.controller presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 判断用户是否有权限访问相册/相机
- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}

- (BOOL)isCanUseCamera {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}

#pragma mark - 对图片进行处理
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.75);
}

- (NSData *)compressImageWithOriginImage:(UIImage *)originImage {
    NSData* imageData;
    float i = 1.0;
    do {
        imageData = UIImageJPEGRepresentation(originImage, i);
        i -= 0.1;
    } while (imageData.length > 2*1024*1024);
    return imageData;
}

+ (UIImage *)scaleImage:(UIImage *)image toMinSize:(float)size
{
    CGSize temSize = CGSizeZero;
    if (MIN(image.size.width, image.size.height)<=size) {
        temSize = image.size;
    }else if (image.size.width-image.size.height>0) {
        temSize = CGSizeMake(image.size.width*size/image.size.height, size);
    }else{
        temSize = CGSizeMake(size, image.size.height*size/image.size.width);
    }
    UIGraphicsBeginImageContext(temSize);
    [image drawInRect:CGRectMake(0, 0, temSize.width, temSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma mark - 截取图片的某一部分
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

#pragma mark - ALiImageReshapeDelegate

- (void)imageReshaperController:(AliImageReshapeController *)reshaper didFinishPickingMediaWithInfo:(UIImage *)image {
    if (image.size.width != 640)
    {
        image = [self scaleImage:image toScale:640/image.size.width];
    }
    //图片压缩
    NSData* imageData = [self compressImageWithOriginImage:image];
    
    
    // 将图片以base64的字符串返回
    self.imageString = [imageData base64String];
    self.uploadIconApi = [[UploadUserIconApi alloc] initWithImageData:self.imageString];
    //显示菊花 
    [self.uploadIconApi startWithBlockSuccess:^(__kindof SYBaseRequest *request) {
        id requestJSON = [NSStringUtils desEncrypt:request api:NSStringFromClass(self.uploadIconApi.class)];
        if ([requestJSON[@"statusCode"] integerValue] == 200) {
            [self.userIcon yy_setImageWithURL:[NSURL URLWithString:requestJSON[@"result"][@"data"][@"url"]] processorKey:NSStringFromClass([self class]) placeholder:[UIImage imageNamed:@"photo_default"]];
            /**
             *  针对上传头像成功后返回的url归档.
             */
            [[AccountManager sharedManager] updateUserAvatar:requestJSON[@"result"][@"data"][@"url"]];
            
            [MBProgressHUD showMessage:requestJSON[@"result"][@"msg"]];
            
        }
        
    } failure:^(__kindof SYBaseRequest *request, NSError *error) {
         ZFLog(@"\n-------------------------- 错误日志 --------------------------\n接口:%@\n状态码:%ld\n报错信息:%@",NSStringFromClass(request.class),request.responseStatusCode,request.responseString);
        
        [MBProgressHUD showMessage:ZFLocalizedString(@"Global_Network_Not_Available",nil)];
    }];
    
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageReshaperControllerDidCancel:(AliImageReshapeController *)reshaper {
    [reshaper dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    AliImageReshapeController *vc = [[AliImageReshapeController alloc] init];
    vc.sourceImage = image;
    vc.reshapeScale = 1/1;
    vc.delegate = self;
    [picker pushViewController:vc animated:YES];
    
}

#pragma maek - Lazy
-(UIButton *)userInfoEditBtn{
    if (!_userInfoEditBtn) {
        _userInfoEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userInfoEditBtn setImage:[UIImage imageNamed:@"account_edit"] forState:UIControlStateNormal];
        [_userInfoEditBtn addTarget:self action:@selector(userInfoEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userInfoEditBtn;
}

-(YYAnimatedImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [[YYAnimatedImageView alloc] init];
        _userIcon.userInteractionEnabled = YES;
        _userIcon.backgroundColor = [UIColor blackColor];
        _userIcon.contentMode = UIViewContentModeScaleToFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconClick)];
        [_userIcon addGestureRecognizer:tap];
        _userIcon.layer.cornerRadius = 40;
        _userIcon.clipsToBounds = YES;
    }
    return _userIcon;
}

-(UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = ZFCOLOR(0, 0, 0, 1.0);
        _userNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _userNameLabel;
}

-(UIView *)hLineView{
    if (!_hLineView) {
        _hLineView = [[UIView alloc] init];
        _hLineView.backgroundColor = ZFCOLOR(221, 221, 221, 1.0);
    }
    return _hLineView;
}

-(UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
        _bottomBackView.backgroundColor = ZFCOLOR(245, 245, 245, 1.0);
    }
    return _bottomBackView;
}

-(UILabel *)userEmailLabel{
    if (!_userEmailLabel) {
        _userEmailLabel = [[UILabel alloc] init];
        _userEmailLabel.textColor = ZFCOLOR(178, 178, 178, 1.0);
        _userEmailLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _userEmailLabel;
}

@end
