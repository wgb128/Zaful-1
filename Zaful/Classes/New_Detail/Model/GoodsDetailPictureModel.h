//
//  GoodsDetailPictureModel.h
//  Dezzal
//
//  Created by ZJ1620 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetailPictureModel : NSObject<YYModel>
@property (nonatomic, copy) NSString   *  img_url;           // 商品缩略图（250*250）
@property (nonatomic, copy) NSString   *  thumb_url;         //商品缩略图（100*100）
@property (nonatomic, copy) NSString   *  img_original;      //商品原图
@property (nonatomic, copy) NSString *wp_image; //webp_image

@end
