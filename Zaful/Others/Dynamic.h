//
//  Dynamic.h
//  Zaful
//
//  Created by zhaowei on 2017/3/2.
//  Copyright © 2017年 Y001. All rights reserved.
//

#ifndef Dynamic_h
#define Dynamic_h

//话题列表页
#define TOPIC_LIST_CELL_IDENTIFIER          @"topiclistCell"
//话题展示页
#define TOPIC_CELL_IDENTIFIER               @"topicCell"
//话题头展示页
#define TOPIC_HEAD_CELL_IDENTIFIER          @"topicheadCell"
//话题标签了列表页
#define TOPIC_LABEL_CELL_IDENTIFIER         @"topicLabelCell"
//Messages列表页
#define MESSAGES_LIST_CELL_IDENTIFIER       @"messageslistCell"

//社区cell重用标识
#define POPULAR_CELL_INENTIFIER                     @"PopularCell"
#define FAVES_CELL_INENTIFIER                       @"FavesCell"
#define COMMUNITY_DETAIL_INENTIFIER                 @"CommunityDetailCell"
#define COMMUNITY_REVIEWS_CELL_INENTIFIER           @"CommunityReviewsCell"

#define HOTVIDEO_CELL                               @"HotVideoCell"
#define HOTTOPIC_CELL                               @"HotTopicCell"
#define SEEALL_CELL                                 @"SeeAllCell"

#define STYLE_SHOWS_CELL_INENTIFIER                 @"styleShowsCell"
#define STYLE_LIKES_CELL_INENTIFIER                 @"styleLikesCell"

//社区推荐好友
#define COMMENDUSER_CELL_INENTIFIER                 @"CommendUserCell"
#define FRIENDSRESULT_CELL_INENTIFIER               @"FriendsResultCell"
//社区cell重用标识
#define POST_ORDER_CELL_INENTIFIER                  @"postOrdersCell"
#define POST_WISH_CELL_INENTIFIER                   @"postWishsCell"
#define POST_BAG_CELL_INENTIFIER                    @"postBagsCell"
#define POST_RECENT_CELL_INENTIFIER                 @"postRecentsCell"

#define VIDEO_LIST_CELL_INENTIFIER                  @"videoListCell"
#define VIDEO_COMMENTS_CELL_INENTIFIER              @"videoCommentsCell"
#define VIDEO_RECOMMEND_CELL_INENTIFIER             @"videoRecommendCell"

//首页推荐banner点击进入category
#define REFRESH_CATEGORY                @"RefreshCategory"

/**购物车Badge 数量*/
#define kCollectionBadgeKey     @"kCollectionBadgeKey"

//登录记录
#define kUserEmail              @"kUserEmail"

#define kInitialize             @"kInitialize"

#define kExchangeKey            @"kExchangeKey"
/**汇率-文件名称*/
#define kRateName               @"kRateName"

/**COD-文件名称*/
#define kFilterKey              @"kFilterKey"

#define kFilterName             @"kFilterName"

/**临时-文件名称*/
#define kTempFilterKey          @"kTempFilterKey"
#define kTempCODKey             @"kTempCODKey"
#define kTempCombKey            @"kTempCombKey"
#define kTempOnlineKey             @"kTempOnlineKey"
#define kTempCombCod            @"kTempCombCod"
#define kTempCombOnline         @"kTempCombOnline"
/**当前货币*/
#define kNowCurrencyKey         @"kNowCurrencyKey"
/**国别*/
#define kCountryKey             @"kCountryKey"
/**国别-文件名称*/
#define kCountryName            @"kCountryName"

/**session_id -未登录的sessionId*/
#define kSessionId              @"kSessionId"

#define KTopicKey               @"ktopicKey"
/**热词搜索*/
#define KHotwordSearchKey       @"KHotwordSearchKey"

// 加载更多
#define LoadMore                            @"0"
// 刷新
#define Refresh                             @"1"

#define LoadGIFRefresh                      @"2"

#define NoMoreToLoad                        @"NoMoreToLoad"

#define LoadGIF                             @"0"
#define LoadHUD                             @"1"

#define PageSize                            @"15"

/**刷新购物车通知*/
static NSString *const kCartNotification           = @"kCartNotification";
/**刷新购物车通知*/
static NSString *const kCartNum                    = @"kCartNum";
/**登陆通知*/
static NSString *const kLoginNotification          = @"kLoginNotification";
/**退出通知*/
static NSString *const kLogoutNotification         = @"kLogoutNotification";
/**改变货币类型通知*/
static NSString *const kCurrencyNotification       = @"kCurrencyNotification";
/**启动页Model跳转*/
static NSString *const kStartLoadingNotification   = @"kStartLoadingNotification";
/**主要用于用户信息本地存储*/
static NSString *const kDataKey                    = @"kDataKey";

static NSString *const kFileName                   = @"kFileName";
//数据库名称
static NSString *const kDataBaseName               = @"database.db";
//数据库浏览记录表名称
static NSString *const kCommendTableName           = @"t_commend";
/**改变推荐商品列表通知*/
static NSString *const kCommendNotification         = @"kCommendNotification";
/**刷新收藏商品通知*/
static NSString *const kCollectionGoodsNotification   = @"kCollectionGoodsNotification";
/**改变用户信息通知*/
static NSString *const kChangeUserInfoNotification      = @"kChangeUserInfoNotification";
/**关注数量变化通知*/
static NSString *const kFollowStatusChangeNotification  = @"kFollowStatusChangeNotification";
/**点攒数量变化通知*/
static NSString *const kLikeStatusChangeNotification    = @"kLikeStatusChangeNotification";
/**评论数量变化通知*/
static NSString *const kReviewCountsChangeNotification  = @"kReviewCountsChangeNotification";
/**删除变化通知*/
static NSString *const kDeleteStatusChangeNotification    = @"kDeleteStatusChangeNotification";
/**订单支付完成后订单列表刷新通知*/
static NSString *const kRefreshOrderListNotification  = @"kRefreshOrderListNotification";
/**发送完照片Popular数据变化通知*/
static NSString *const kRefreshPopularNotification      = @"kRefreshPopularNotification";
static NSString *const kCommunityPostSuccessNotification = @"kCommunityPostSuccessNotification";
/**发布话题，刷新话题详情页*/
static NSString *const kRefreshTopicNotification          = @"kRefreshTopicNotification";
/**隐藏首页nav bar通知*/
static NSString *const kHomeHideNavbarNotice          = @"kHomeHideNavbarNotice";

//KVO Name
//Collection---ContentOffset
static NSString *const kColletionContentOffsetName      = @"contentOffset";
static NSString *const DZNEmptyDataSetViewName          = @"DZNEmptyDataSetView";  // DZNEmptyDataSetView 类名

/**刷新的时候，合适的数据*/

static const NSUInteger kPageSize                   = 10; // 通常一个列表页面一次加载的个数


//-------------------------------------------------ENUM DEFINE------------------------------------------------------
typedef NS_ENUM(NSInteger, OrderDetailPayStateType) {
    OrderDetailPay = 0,
    OrderDetailCancel
};

//订单详情页商品评论按钮状态
typedef NS_ENUM(NSInteger, btnTag) {
    WriteReview = 0,
    CheckReview
};

//等待的空白页面
typedef NS_ENUM(NSUInteger,LoadingViewShowType) {
    LoadingViewIsShow  = 0,
    LoadingViewNoDataType = 1,
    LoadingViewNoNetType = 2
};

//空页面的类型
typedef NS_ENUM(NSUInteger, EmptyViewShowType){
    EmptyViewHideType = 0,
    EmptyShowNoDataType = 1,
    EmptyShowNoNetType = 2
};

//活动类型
typedef NS_ENUM(NSUInteger, ZFActivityType){
    ZFActivityTypeUnknown,
    ZFActivityTypeBlackFive,
    ZFActivityTypeDoubleEleven,
};

// 新版分类
typedef NS_ENUM(NSInteger,SelectViewDataType) {
    SelectViewDataTypeCategory = 0,
    SelectViewDataTypeSort,
    SelectViewDataTypeRefine
};

typedef NS_ENUM(NSInteger, ZFCartListBlocksType) {
    ZFCartListBlocksTypeNormal = 0,
    ZFCartListBlocksTypeDiscount,
    ZFCartListBlocksTypeUnavailable,
};

//跳转页面类型
typedef NS_ENUM(NSInteger, JumpActionType) {
    JumpDefalutActionType = 0, // 默认备注，后台没有返回
    JumpHomeChannelActionType = 1, // 频道首页
    JumpCategoryActionType = 2, // 分页类
    JumpGoodDetailActionType = 3, // 商品详情页
    JumpSearchActionType = 4, // 搜索
    JumpInsertH5ActionType = 5, // 嵌入H5
    JumpBuyShowActionType = 6, //社区
    JumpExternalLinkActionType = 7, //外部链接
    JumpMessageActionType = 8, //消息列表
    JumpCouponActionType = 9, //优惠券列表
    JumpOrderListActionType = 10, //订单列表
    JumpOrderDetailActionType = 11, //订单详情
    JumpCartActionType = 12, //购物车列表
    JumpCollectionActionType = 13, //收藏夹列表
    JumpVirtualCategoryActionType = 14 //虚拟分类
};

//首页banner跳转页面类型
typedef NS_ENUM(NSInteger, BannerActionType) {
    BannerNativeActionType = 1, // 原生
    BannerInsertH5ActionType = 2 // 嵌入H5
};

typedef NS_ENUM(NSInteger, BannerLocationType) {
    BannerLocationTypeCategory = 1, // 分类页
    BannerLocationTypeSort     = 2, // 搜索页
    BannerLocationTypeVirtual  = 3, // 虚拟分类
    BannerLocationTypeGoodsDetail = 4, // 商品详情
    BannerLocationTypePostDetail = 5, // 帖子详情_社区
    BannerLocationTypeTopicDetail = 6 // 话题详情_社区
};

//用户性别  1 男  2 女  3 保密
typedef NS_ENUM(NSUInteger, UserEnumSexType){
    UserEnumSexTypeMale = 1,
    UserEnumSexTypeFemale = 2,
    UserEnumSexTypePrivacy = 3
};

typedef NS_ENUM(NSUInteger, SubscribeType){
    SubscribeTypeNo = 0,
    SubscribeTypeYes = 1
};

// 注册页网页跳转类型
typedef NS_ENUM(NSUInteger, FastPaypalCheckType){
    //未登录&未注册
    //返回：1.用户信息  2.PP地址信息
    FastPaypalCheckTypeNoLoginAndNoRegiste = 1,
    //2.未登录 & PP用户注册过 & 无地址信息
    //返回：1.用户信息  2.PP地址信息
    FastPaypalCheckTypeNoLoginAndRegistedAndNoAddress = 2,
    //3.未登录 & PP用户注册过 & 有地址信息
    //返回：1.用户信息  2.checkout信息
    FastPaypalCheckTypeNoLoginAndRegistedAndHasAddress = 3,
    //4.登录 & 无地址信息
    //返回：1.PP地址信息
    FastPaypalCheckTypeLoginAndNoAddress = 4,
    //5.登录 & 有地址信息
    //返回：1.checkout信息
    FastPaypalCheckTypeLoginAndHasAddress = 5
};

// COD取整方式
typedef NS_ENUM(NSUInteger, CashOnDeliveryTruncType){
    //不显示不取整
    CashOnDeliveryTruncTypeDefault = 0,
    //向上
    CashOnDeliveryTruncTypeUp = 1,
    //向下取整
    CashOnDeliveryTruncTypeDown = 2
    
};

// 快捷支付状态类型
typedef NS_ENUM(NSUInteger, FastPaypalOrderType){
    //快速支付成功
    FastPaypalOrderTypeSuccess = 1,
    //快速支付失败
    FastPaypalOrderTypeFail = 2,
    //普通支付
    FastPaypalOrderTypeCommon = 3
};

typedef NS_ENUM(NSUInteger, CartCheckOutBackValueEnumType){
    //成功
    CartCheckOutBackValueEnumTypeSuccess = 0,
    //没有地址
    CartCheckOutBackValueEnumTypeNoAddress,
    //购物车没有此商品
    CartCheckOutBackValueEnumTypeNoGoods,
    //没有物流
    CartCheckOutBackValueEnumTypeNoShipping,
    //不支持此支付
    CartCheckOutBackValueEnumTypeNoPayment,
    //此商品已下架
    CartCheckOutBackValueEnumTypeShelvesed,
    //库存不足
    CartCheckOutBackValueEnumTypeNoStock
} ;


//订单状态
typedef NS_ENUM(NSUInteger, OrderStateEnumType){
    OrderStateEnumTypeWaitingForPayment = 0,//未付款
    OrderStateEnumTypePaid,//已付款
    OrderStateEnumTypeProcessing,//备货
    OrderStateEnumTypeShippedOut,//完全发货
    OrderStateEnumTypeDelivered,//已收到货
    OrderStateEnumTypeRefunded = 10,//退款
    OrderStateEnumTypeCancelled,//取消
    OrderStateEnumTypePartialOrderDispatched = 15,//部分配货
    OrderStateEnumTypeDispatched,//完全配货
    OrderStateEnumTypePartialOrderShipped = 20 //部分发货
} ;

typedef NS_ENUM(NSInteger, PaymentStatus) {
    PaymentStatusUnknown,
    PaymentStatusDone,
    PaymentStatusCancel,
    PaymentStatusFail,
};

typedef NS_ENUM(NSInteger, TabBarIndex) {
    TabBarIndexHome,
    TabBarIndexCategory,
    TabBarIndexCommunity,
    TabBarIndexDesigners,
    TabBarIndexAccount,
};

//页面加载数据为空的类型
typedef NS_ENUM(NSInteger, EmptyPageType) {
    EmptyPageTypeDefault,
    EmptyPageTypeHidden,
    EmptyPageTypeNoData,
    EmptyPageTypeNoNetwork,
};

//页面加载数据为空的类型
typedef NS_ENUM(NSInteger, FBRegisterType) {
    FBRegisterTypeHadRegister,
    FBRegisterTypeSuccess
};

//社区用户类型
typedef NS_ENUM(NSInteger, ZFUserListType) {
    ZFUserListTypeLike = 5,
    ZFUserListTypeFollowing = 0,
    ZFUserListTypeFollowed = 1,
};

//社区首页Popular四个按钮Tag值
typedef NS_ENUM(NSInteger, PopularBtnTag) {
    likeBtnTag = 9852,
    reviewBtnTag,
    integralBtnTag,
    shareBtnTag,
    followBtnTag,
    mystyleBtnTag,
    deleteBtnTag
};

typedef NS_ENUM(NSInteger, CommunityGoodsType) {
    CommunityGoodsTypeWish,
    CommunityGoodsTypeBag,
    CommunityGoodsTypeOrder,
    CommunityGoodsTypeRecent
};

// 社区消息类型
typedef NS_ENUM(NSInteger, MessageListType) {
    MessageListFollowTag = 1,
    MessageListCommendTag,
    MessageListLikeTag,
    MessageListGainedPoints
};

// 注册页网页跳转类型
typedef NS_ENUM(NSUInteger, RegisterType){
    RegisterPolicyType = 0,
    RegisterTermType = 1
};

// 支付界面类型
typedef NS_ENUM(NSUInteger, PaymentUIType){
    // 普通支付界面
    PaymentUITypeSingle   = 1,
    // 组合界面
    PaymentUITypeCombine  = 2
};

// 支付流程状态
typedef NS_ENUM(NSUInteger, PaymentProcessType){
    // 老的支付流程
    PaymentProcessTypeOld   = 1,
    // 拆单支付流程
    PaymentProcessTypeNew   = 2
};

// 组合支付状态
typedef NS_ENUM(NSUInteger, PaymentStateType){
    // 支付失败
    PaymentStateTypeFailure   = 1,
    // 等待支付
    PaymentStateTypeWaite     = 2
};

// 支付类型
typedef NS_ENUM(NSUInteger, PayCodeType){
    // cod
    PayCodeTypeCOD        = 1,
    // online
    PayCodeTypeOnline     = 2,
    // combine
    PayCodeTypeCombine    = 3,
    // 老接口
    PayCodeTypeOld        = 9
};

// 当前支付方式
typedef NS_ENUM(NSUInteger, CurrentPaymentType){
    // cod 支付
    CurrentPaymentTypeCOD      = 1,
    // online 支付
    CurrentPaymentTypeOnline   = 2
};


#endif /* Dynamic_h */

