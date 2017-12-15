//
//  PinterestVC.h
//  TsangFa
//
//  Created by TsangFa on 27/6/16.
//  Copyright (c) 2016 TsangFa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PinterestDelegate
-(void)dismissPinterest;
@end

@interface ZFPinterestVC : UIViewController 
/*!
 *  @brief 分享链接
 */
@property (nonatomic,strong) NSString *url;
/*!
 *  @brief 图片地址
 */
@property (nonatomic,strong) NSString *image;
/*!
 *  @brief 分享内容
 */
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) id<PinterestDelegate> delegate;

@end
