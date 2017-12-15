//
//  GoodsDetailModel.h
//  Dezzal
//
//  Created by ZJ1620 on 16/8/1.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetialSizeModel.h"
#import "GoodsDetialColorModel.h"
#import "GoodsDetailPictureModel.h"
#import "GoodsDetailSameModel.h"
#import "GoodsDetailSizeColorModel.h"
#import "GoodsDetailFirstReviewModel.h"
#import "GoodsReductionModel.h"
#import "GoodsDetailMulitAttrModel.h"

@protocol GoodsModel

@end

@interface GoodsDetailModel : NSObject<YYModel>

@property (nonatomic, strong) NSArray<GoodsDetailSameModel *> *same_cat_goods; //推荐商品[{size_list},{color_list}]
@property (nonatomic, strong) GoodsDetailSizeColorModel *same_goods_spec;//同款商品属性
@property (nonatomic, copy) NSString                    *same_cat_goods_page;  //推荐商品页数
@property (nonatomic, copy) NSString                    *properties;// 商品属性
@property (nonatomic, copy) NSString                    *specification;//商品规格（属性、规格只有一个有值）
@property (nonatomic, strong) NSArray<GoodsDetailPictureModel*> *pictures; //商品图片[{picture},{picture}]
@property (nonatomic, assign) NSInteger                 pic_count;    //轮播图片数量
@property (nonatomic, copy) NSString                    *delivery_level;//发货时间等级{1：3，2：5-10，3：7-15}
@property (nonatomic, copy) NSString                    *time_description;//发货时间
@property (nonatomic, copy) NSString                    *goods_name;// 商品名称
@property (nonatomic, assign) NSInteger                 goods_number;// 商品库存
@property (nonatomic, copy) NSString                    *is_on_sale;//商品上架状态{1：上架，0：下架}
@property (nonatomic, copy) NSString                    *is_promote;//促销{1是0否}
@property (nonatomic, assign) BOOL                      is_cod;
@property (nonatomic, copy) NSString                    *is_mobile_price;//手机专享价{1是0否}
@property (nonatomic, copy) NSString                    *market_price;//| 商品市场价
@property (nonatomic, copy) NSString                    *model_id;//模特ID
@property (nonatomic, copy) NSString                    *promote_end_time;//商品促销结束时间
@property (nonatomic, copy) NSString                    *promote_price;//商品促销价格
@property (nonatomic, copy) NSString                    *promote_zhekou;//商品折扣百分数
@property (nonatomic, copy) NSString                    *shelf_down_type;//| 商品清仓状态{100：是，0：否}
@property (nonatomic, copy) NSString                    *shop_price;//
@property (nonatomic, copy) NSString                    *url;// | 商品URL
@property (nonatomic, copy) NSString                    *size_url;// 尺码表H5 URL
@property (nonatomic, copy) NSString                    *model_url;//模特信息H5 URL
@property (nonatomic, copy) NSString                    *desc_url;  // 产品描述H5 URL
@property (nonatomic, copy) NSString                    *is_collect; //收藏{1：是，0：否}
@property (nonatomic, copy) NSString                    *like_count;
@property (nonatomic, copy) NSString                    *goods_id;//商品Id
@property (nonatomic, copy) NSString                    *goods_sn;
@property (nonatomic, copy) NSString                    *shop_diff_mobile;
@property (nonatomic, copy) NSString                    *shipping_tips;
@property (nonatomic, copy) NSString                    *group_goods_id;
@property (nonatomic, copy) NSString                    *wp_image;//webpImage
@property (nonatomic, copy) NSString                    *reViewCount; // 评论数
@property (nonatomic, copy) NSString                    *rateAVG; // 总星星平均数
@property (nonatomic, copy) NSString                    *long_cat_name; // 用于AF统计
@property (nonatomic,strong)  GoodsDetailFirstReviewModel                   *reviewListModel;
@property (nonatomic, strong) GoodsReductionModel                           *reductionModel;
@property (nonatomic, strong) NSArray<GoodsDetailMulitAttrModel *>          *goods_mulit_attr;
@property (nonatomic, strong) NSArray<GoodsDetailFirstReviewModel *>        *reviewList;
@end





