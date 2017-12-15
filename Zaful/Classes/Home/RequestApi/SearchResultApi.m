//
//  SearchResultApi.m
//  Dezzal
//
//  Created by Y001 on 16/8/10.
//  Copyright © 2016年 7FD75. All rights reserved.
//

#import "SearchResultApi.h"

@interface SearchResultApi ()
{
    NSString  * _searchString;
    NSInteger   _page;
    NSInteger   _size;
    NSString  * _orderby;
}
@end

@implementation SearchResultApi

- (instancetype)initSearchResultApiWithSearchString:(NSString *)searchString withPage:(NSInteger)page withSize:(NSInteger)size withOrderby:(NSString *)orderby;
{
    self = [super init];
    if (self) {
        _searchString = searchString;
        _page = page;
        _size = size;
        _orderby = orderby;
    }
    return self;
}

- (BOOL)enableCache {
    return YES;
}

- (BOOL)enableAccessory {
    return YES;
}

- (NSURLRequestCachePolicy)requestCachePolicy {
    return NSURLRequestReloadIgnoringCacheData;
}

- (NSString *)requestPath {
    
    return ENCPATH;
}

- (id)requestParameters {
    return @{
             @"action"    :@"search/get_list",
             @"keyword"   : _searchString,
             @"page"      : @(_page),
             @"page_size" : @(_size),
             @"order_by"  : _orderby
             };
}
- (SYRequestMethod)requestMethod {
    return SYRequestMethodPOST;
}

- (SYRequestSerializerType)requestSerializerType {
    return SYRequestSerializerTypeJSON;
}
@end
