//
//  PostPhotosManager.h
//  Zaful
//
//  Created by zhaowei on 2016/11/29.
//  Copyright © 2016年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostPhotosManager : NSObject
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,assign) BOOL isSelectOriginalPhoto;

+ (PostPhotosManager *)sharedManager;
- (void)clearData;
@end
