


//
//  ZFCartEditGoodsApi.m
//  Zaful
//
//  Created by liuxi on 2017/9/17.
//  Copyright © 2017年 Y001. All rights reserved.
//

#import "ZFCartEditGoodsApi.h"

@implementation ZFCartEditGoodsApi {
    NSInteger _goodNum;
    NSString *_goodId;
}

-(instancetype)initWithGoodNum:(NSInteger)goodNum GoodId:(NSString *)goodId{
    
    self = [super init];
    if (self) {
        _goodNum = goodNum;
        _goodId = goodId;
    }
    return self;
}
- (BOOL)enableCache {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    return ENCPATH;
}

- (id)requestParameters {
    
    if ([AccountManager sharedManager].isSignIn) {
        return @{
                 @"action"   :  @"cart/edit_cart",
                 @"goods_id" :  _goodId,
                 @"num"      :  @(_goodNum),
                 @"token"    :  TOKEN
                 
                 };
        
    }else{
        return @{
                 @"action"   :  @"cart/edit_cart",
                 @"goods_id" :  _goodId,
                 @"num"      :  @(_goodNum),
                 @"sess_id"  :  SESSIONID
                 
                 };
        
    }
}

- (SYRequestMethod)requestMethod {
    
    return SYRequestMethodPOST;
}


- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}


@end
