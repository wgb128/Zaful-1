//
//  PostPhotosManager.m
//  Zaful
//
//  Created by zhaowei on 2016/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import "PostPhotosManager.h"

@interface PostPhotosManager ()

@end

@implementation PostPhotosManager
+ (PostPhotosManager *)sharedManager {
    static PostPhotosManager *sharedManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManagerInstance = [[self alloc] init];
        sharedManagerInstance.selectedPhotos = [NSMutableArray array];
        sharedManagerInstance.selectedAssets = [NSMutableArray array];
        sharedManagerInstance.isSelectOriginalPhoto = NO;
    });
    return sharedManagerInstance;
}

- (void)clearData {
    [self.selectedPhotos removeAllObjects];
    [self.selectedAssets removeAllObjects];
    self.isSelectOriginalPhoto = NO;
}
@end
