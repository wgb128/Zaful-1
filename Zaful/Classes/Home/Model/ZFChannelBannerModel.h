//
//  ZFChannelBannerModel.h
//  Zaful
//
//  Created by QianHan on 2017/10/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFChannelBannerModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *bannerId;
@property (nonatomic, copy) NSString *bannerImgURL;
@property (nonatomic, copy) NSString *bannerImgHeight;
@property (nonatomic, copy) NSString *bannerName;
@property (nonatomic, copy) NSString *bannerSort;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *deepLinkURL;
@property (nonatomic, copy) NSString *isShow;

@end
