//
//  SYNetworkManager.m
//  SYNetwork
//
//  Created by zhaowei on 16/5/28.
//  Copyright © 2016年 yoshop. All rights reserved.
//

#import "SYNetworkManager.h"
#import "SYNetworkUtil.h"
#import "SYNetworkConfig.h"
#import "SYNetworkCacheManager.h"
#import "SYBaseRequest.h"


@interface SYNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableDictionary *requestIdentifierDictionary;
@property (nonatomic, strong) dispatch_queue_t requestProcessingQueue;

@end

@implementation SYNetworkManager

#pragma mark - Life Cycle

+ (SYNetworkManager *)sharedInstance {
    static SYNetworkManager *instance;
    static dispatch_once_t SYNetworkManagerToken;
    dispatch_once(&SYNetworkManagerToken, ^{
        instance = [[SYNetworkManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self manager];
        [self requestIdentifierDictionary];
    }
    return self;
}

#pragma mark - Private method
- (void)addCookie {
    NSHTTPCookie *zaful_cookie = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                           NSHTTPCookieName:@"staging",
                                                                           NSHTTPCookieValue:@"true",
                                                                           NSHTTPCookieDomain:@"admin.reuew.com",
                                                                           NSHTTPCookiePath:@"/",
                                                                           }];
    
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [storage setCookie:zaful_cookie];
}

- (void)deleteCookie {
    NSHTTPCookie *cookie = [[NSHTTPCookie alloc]initWithProperties:@{
                                                                     NSHTTPCookieName:@"staging",
                                                                     NSHTTPCookieValue:@"true",
                                                                     NSHTTPCookieDomain:@"admin.reuew.com",
                                                                     NSHTTPCookiePath:@"/",
                                                                     }];
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if ([storage.cookies containsObject:cookie]) {
        [storage deleteCookie:cookie];
    }
}

#pragma mark - Public method
- (void)addRequest:(SYBaseRequest *)request {
    dispatch_async(self.requestProcessingQueue, ^{
        //启动cookies
        self.manager.requestSerializer.HTTPShouldHandleCookies = YES;
        NSString *url = request.requestURLString;
        SYRequestMethod method = request.requestMethod;
        id parameters = request.requestParameters;
        
        NSString *tip;
        if (preRelease) {
            tip = @"预发布";
        }else{
#ifdef   isOpenDebugConfig
            tip = @"测试环境";
#else
            tip  = @"正式环境";
#endif
        }
        
        //Request Serializer
        switch (request.requestSerializerType) {
            case SYRequestSerializerTypeHTTP: {
                self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            }
            case SYRequestSerializerTypeJSON: {
                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            }
            default: {
                SYNetworkLog(@"Error, unsupport method type");
                break;
            }
        }
        self.manager.requestSerializer.cachePolicy = request.requestCachePolicy;
        self.manager.requestSerializer.timeoutInterval = request.requestTimeoutInterval;
        
        //HTTPHeaderFields
        NSDictionary *requestHeaderFieldDictionary = request.requestHeader;
        if (requestHeaderFieldDictionary) {
            for (NSString *key in requestHeaderFieldDictionary.allKeys) {
                NSString *value = requestHeaderFieldDictionary[key];
                [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        NSString *lang = [ZFLocalizationString shareLocalizable].nomarLocalizable;
        [dict setValue:lang forKey:@"lang"];
        [dict setValue:[NSString stringWithFormat:@"%@",ZFSYSTEM_VERSION] forKey:@"version"];
        [dict setValue:TOKEN forKey:@"token"];
        
        if ([url containsString:AppBaseURL]) {
            [dict copy];
            parameters = dict;
            
            ZFLog(@"\n🍀未加密🍀请求的URL %@:%@  \n参数:%@ \n👉json👈:%@",tip,url,dict,[dict yy_modelToJSONString]);
            if (request.encryption) {
                parameters = @{@"data":[NSStringUtils encryptWithDict:dict]};
                ZFLog(@"\n❌加密后❌URL %@:%@  \n参数:%@ \n👉json👈:%@",tip,url,parameters,[parameters yy_modelToJSONString]);
            }
            
            if (![dict[@"action"] isEqualToString:@"Community/review"] || ![dict[@"action"] isEqualToString:@"Community/upload"]) {
                // 做header签名处理
                NSString *requestJson =  [parameters yy_modelToJSONString];
                NSString *key = PrivateKey;
                NSString *headerKey = [NSStringUtils ZFNSStringMD5:[requestJson stringByAppendingString:key]];
                NSString *headerValue = [NSStringUtils ZFNSStringMD5:[[requestJson stringByAppendingString:headerKey] stringByAppendingString:key]];
                ZFLog(@"\n-----key:%@\n-----value:%@",headerKey,headerValue);
                [self.manager.requestSerializer setValue:headerValue forHTTPHeaderField:headerKey];
            }
        }else{
            parameters = dict;
            if (preRelease) {
                [self addCookie];
            }else{
                [self deleteCookie];
            }
            ZFLog(@"\n🌼社区🌼URL %@:%@  \n参数:%@",tip,url,parameters);
        }
        
        switch (method) {
            case SYRequestMethodGET: {
                request.sessionDataTask = [self.manager GET:url
                                                 parameters:parameters
                                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                                       [self handleRequest:request progress:downloadProgress];
                                                   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                       [self handleRequestFailureWithSessionDatatask:task error:error];
                                                   }];
                break;
            }
            case SYRequestMethodPOST: {
                if (request.constructingBodyBlock) {
                    request.sessionDataTask = [self.manager POST:url
                                                      parameters:parameters
                                       constructingBodyWithBlock:request.constructingBodyBlock
                                                        progress:^(NSProgress * _Nonnull uploadProgress) {
                                                            [self handleRequest:request progress:uploadProgress];
                                                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                            [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                            [self handleRequestFailureWithSessionDatatask:task error:error];
                                                        }];
                } else {
                    request.sessionDataTask = [self.manager POST:url
                                                      parameters:parameters
                                                        progress:^(NSProgress * _Nonnull downloadProgress) {
                                                            [self handleRequest:request progress:downloadProgress];
                                                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                            [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                            [self handleRequestFailureWithSessionDatatask:task error:error];
                                                        }];
                }
                break;
            }
            case SYRequestMethodHEAD: {
                request.sessionDataTask = [self.manager HEAD:url
                                                  parameters:parameters
                                                     success:^(NSURLSessionDataTask * _Nonnull task) {
                                                         [self handleRequestSuccessWithSessionDataTask:task responseObject:nil];
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         [self handleRequestFailureWithSessionDatatask:task error:error];
                                                     }];
                break;
            }
            case SYRequestMethodPUT: {
                request.sessionDataTask = [self.manager PUT:url
                                                 parameters:parameters
                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                        [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                        [self handleRequestFailureWithSessionDatatask:task error:error];
                                                    }];
                break;
            }
            case SYRequestMethodDELETE: {
                request.sessionDataTask = [self.manager DELETE:url
                                                    parameters:parameters
                                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                           [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                           [self handleRequestFailureWithSessionDatatask:task error:error];
                                                       }];
                break;
            }
            case SYRequestMethodPATCH: {
                request.sessionDataTask = [self.manager PATCH:url
                                                   parameters:parameters
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          [self handleRequestSuccessWithSessionDataTask:task responseObject:responseObject];
                                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                          [self handleRequestFailureWithSessionDatatask:task error:error];
                                                      }];
                break;
            }
            default: {
                SYNetworkLog(@"Error, unsupport method type");
                break;
            }
        }
        [self addRequestIdentifierWithRequest:request];
    });
}

- (void)removeRequest:(SYBaseRequest *)request completion:(void (^)())completion {
    dispatch_async(self.requestProcessingQueue, ^{
        [request.sessionDataTask cancel];
        [self removeRequestIdentifierWithRequest:request];
        completion?completion():nil;
    });
}

- (void)removeAllRequest {
    NSDictionary *requestIdentifierDictionary = self.requestIdentifierDictionary.copy;
    for (NSString *key in requestIdentifierDictionary.allValues) {
        SYBaseRequest *request = self.requestIdentifierDictionary[key];
        [request.sessionDataTask cancel];
        [self.requestIdentifierDictionary removeObjectForKey:key];
    }
}

#pragma mark - Private method

- (BOOL)isValidResultWithRequest:(SYBaseRequest *)request {
    BOOL result = YES;
    if (request.jsonObjectValidator != nil) {
        result = [SYNetworkUtil isValidateJSONObject:request.responseJSONObject
                             withJSONObjectValidator:request.jsonObjectValidator];
    }
    return result;
}

- (void)handleRequest:(SYBaseRequest *)request progress:(NSProgress *)progress {
    if ([request.delegate respondsToSelector:@selector(requestProgress:)]) {
        [request.delegate requestProgress:progress];
    }
    if (request.progressBlock) {
        request.progressBlock(progress);
    }
}

- (void)handleRequestSuccessWithSessionDataTask:(NSURLSessionDataTask *)sessionDataTask responseObject:(id)responseObject {
    NSString *key = @(sessionDataTask.taskIdentifier).stringValue;
    SYBaseRequest *request = self.requestIdentifierDictionary[key];
    request.responseData = responseObject;
    if (request) {
        if ([self isValidResultWithRequest:request]) {
            if (request.enableCache) {
                NSString *cacheKey = [SYNetworkUtil cacheKeyWithRequest:request];
                [[SYNetworkCacheManager sharedInstance] setObject:request.responseData forKey:cacheKey];
            }
            if ([request.delegate respondsToSelector:@selector(requestSuccess:)]) {
                [request.delegate requestSuccess:request];
            }
            if (request.successBlock) {
                request.successBlock(request);
            }
            [request toggleAccessoriesStopCallBack];
        } else {
            SYNetworkLog(@"Request %@ failed, status code = %@", NSStringFromClass([request class]), @(request.responseStatusCode));
            if ([request.delegate respondsToSelector:@selector(requestFailure:error:)]) {
                [request.delegate requestFailure:request error:nil];
            }
            if (request.failureBlock) {
                request.failureBlock(request, nil);
            }
            [request toggleAccessoriesStopCallBack];
        }
    }
    [request clearCompletionBlock];
    [self removeRequestIdentifierWithRequest:request];
}

- (void)handleRequestFailureWithSessionDatatask:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error {
    NSString *key = @(sessionDataTask.taskIdentifier).stringValue;
    SYBaseRequest *request = self.requestIdentifierDictionary[key];
    request.responseData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (request) {
        if ([request.delegate respondsToSelector:@selector(requestFailure:error:)]) {
            [request.delegate requestFailure:request error:error];
        }
        if (request.failureBlock) {
            request.failureBlock(request, error);
        }
        [request toggleAccessoriesStopCallBack];
    }
    [request clearCompletionBlock];
    [self removeRequestIdentifierWithRequest:request];
}

- (void)addRequestIdentifierWithRequest:(SYBaseRequest *)request {
    if (request.sessionDataTask != nil) {
        NSString *key = @(request.sessionDataTask.taskIdentifier).stringValue;
        @synchronized (self) {
            [self.requestIdentifierDictionary setObject:request forKey:key];
        }
    }
    SYNetworkLog(@"Add request: %@", NSStringFromClass([request class]));
}

- (void)removeRequestIdentifierWithRequest:(SYBaseRequest *)request {
    NSString *key = @(request.sessionDataTask.taskIdentifier).stringValue;
    @synchronized (self) {
        [self.requestIdentifierDictionary removeObjectForKey:key];
    }
    SYNetworkLog(@"Request queue size = %@", @(self.requestIdentifierDictionary.count));
}

#pragma mark - Property method

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        SYNetworkConfig *config = [SYNetworkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy = config.securityPolicy;
        _manager.operationQueue.maxConcurrentOperationCount = config.maxConcurrentOperationCount;
    }
    return _manager;
}

- (NSMutableDictionary *)requestIdentifierDictionary {
    if (_requestIdentifierDictionary == nil) {
        _requestIdentifierDictionary = [NSMutableDictionary dictionary];
    }
    return _requestIdentifierDictionary;
}

- (dispatch_queue_t)requestProcessingQueue {
    if (_requestProcessingQueue == nil) {
        _requestProcessingQueue = dispatch_queue_create("com.zaful.synetwork.request.processing", DISPATCH_QUEUE_SERIAL);
    }
    return _requestProcessingQueue;
}

@end
