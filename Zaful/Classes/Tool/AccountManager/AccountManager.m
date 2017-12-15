//
//  AccountManager.m
//  Yoshop
//
//  Created by zhaowei on 16/5/31.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "AccountManager.h"

//#define USER_NAME @"name"
//#define USER_EMAIL @"email"
//#define USER_PASSWORD @"password"
//#define USER_AGE @"age"

@implementation AccountManager

+ (AccountManager *)sharedManager {
    static AccountManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        [sharedAccountManagerInstance readUserInfo];
    });
    return sharedAccountManagerInstance;
}

- (void)readUserInfo {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]]) {
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        //解档出数据模型
        AccountModel *account = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];//一定不要忘记finishDecoding，否则会报错
        self.account = account;
        if (self.account) {
            self.isSignIn = YES;
        }
    }
}

- (void)updateUserAvatar:(NSString *)url {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]]) {
        
        NSData *unData = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unData];
        //解档出数据模型
        AccountModel *account = [unarchiver decodeObjectForKey:kDataKey];
        //一定不要忘记finishDecoding，否则会报错
        [unarchiver finishDecoding];
        
        account.avatar = url;
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account forKey:kDataKey];
        [archiver finishEncoding];
        
        [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName] atomically:YES];
        
        self.account = account;
        if (self.account) {
            self.isSignIn = YES;
        }
    }
}

- (void)updateUserDefaultAddressId:(NSString *)addressId {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]]) {
        
        NSData *unData = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unData];
        //解档出数据模型
        AccountModel *account = [unarchiver decodeObjectForKey:kDataKey];
        //一定不要忘记finishDecoding，否则会报错
        [unarchiver finishDecoding];
        
        account.addressId = addressId;
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:account forKey:kDataKey];
        [archiver finishEncoding];
        
        [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName] atomically:YES];
        
        self.account = account;
        if (self.account) {
            self.isSignIn = YES;
        }
    }
}

-(void)saveUserInfo:(AccountModel *)account {

    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:account forKey:kDataKey];
    [archiver finishEncoding];
    ZFLog(@"%@",ZFPATH_DIRECTORY);
    [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName] atomically:YES];
}

- (void)updateUserInfo:(AccountModel *)account {
    
    [self saveUserInfo:account];
    [self readUserInfo];
}

- (void)editUserSomeItems:(AccountModel *)account
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]]) {
        
        NSData *unData = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:unData];
        AccountModel *unarchiverAccount = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        unarchiverAccount.firstname = account.firstname;
        unarchiverAccount.lastname = account.lastname;
        unarchiverAccount.nickname = account.nickname;
        unarchiverAccount.sex = account.sex;
        unarchiverAccount.birthday = account.birthday;
        unarchiverAccount.phone = account.phone;
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:unarchiverAccount forKey:kDataKey];
        [archiver finishEncoding];
        
        [data writeToFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName] atomically:YES];
        
        NSData *unData1 = [[NSData alloc] initWithContentsOfFile:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]];
        NSKeyedUnarchiver *unarchiver1 = [[NSKeyedUnarchiver alloc] initForReadingWithData:unData1];
        AccountModel *unarchiverAccount1 = [unarchiver1 decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        self.account = unarchiverAccount1;
        
        if (self.account) {
            self.isSignIn = YES;
        }
    }

}

- (void)EditUserSomeItems:(AccountModel *)account {
    [self readUserInfo];
    [self saveUserInfo:account];
   
}

- (void)clearUserInfo {
    ZFLog(@"%@",ZFPATH_DIRECTORY);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[ZFPATH_DIRECTORY stringByAppendingPathComponent:kFileName] error:nil];
        self.account = nil;
        self.isSignIn = NO;
    }
}

- (void)clearWebCookie {
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
}

- (NSString *)userId
{
    NSString * userId = @"";
    if ([AccountManager sharedManager].isSignIn) {
        userId = self.account.user_id;
    } 
    return userId;
}

- (NSString *)token
{
    NSString *token = @"";
    if ([AccountManager sharedManager].isSignIn) {
        token = self.account.token;
    }
    return token;
}

- (NSString *)defaultAddressId
{
    NSString *defaultAddressId = @"";
    if ([AccountManager sharedManager].isSignIn) {
        defaultAddressId = self.account.addressId;
    }
    return defaultAddressId;
}


- (NSString *)sessionId
{
    NSString *sessionId = @"";
    if ([AccountManager sharedManager].isSignIn) {
        sessionId = self.account.sess_id;
    }
    return sessionId;
}


@end
