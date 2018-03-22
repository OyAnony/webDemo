//
//  NBNetWork.m
//  nbProxy
//
//  Created by xdk on 2018/3/22.
//  Copyright © 2018年 NBP. All rights reserved.
//

#import "NBNetWork.h"

#import <PGNetworkHelper/PGNetworkHelper+Synchronously.h>


@implementation NBNetWork

+ (instancetype)shareNetwork {
    
    static NBNetWork *net = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         net = [[NBNetWork alloc]init];
        
        //设置SSL
        [PGNetAPIClient policyWithPinningMode:AFSSLPinningModeNone];
        
    });
    
    
    return net;
}

#pragma mark - base url
- (void)setBaseUrl:(NSString *)baseUrl {
    
    _baseUrl = nil;
    _baseUrl = baseUrl;
    //设置baseUrl
    [PGNetAPIClient baseUrl:baseUrl];
}


- (void)requstMethods:(Type)type
                  url:(NSString *)url
           parameters:(id)parameters
                cache:(BOOL)cache
        responseCache:(id)responseCache
              success:(void(^)(id responseObject,BOOL error))success
              failure:(void(^)(NSError *error))failure {
    
    // https 配置
    //    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    policy.allowInvalidCertificates = YES;
    //    policy.validatesDomainName = YES;
    
    switch (type) {
        case 0:
        {
            
            // post
            //POST请求 只需要将cache设置为true就可以自动缓存
            [PGNetworkHelper POST:url parameters:parameters cache:cache responseCache:nil success:^(id responseObject) {
                
                //这里进行要缓存的数据，cacheKey就是url，如果有参数的话，就把参数拼接到cacheKey后面，下次就可以直接在responseCache block里面获取了
               // [PGNetworkCache saveResponseCache:responseObject forKey:@""];
                
                NSLog(@"responseObject = %@", responseObject);
                success(responseObject,false);
                
            } failure:^(NSError *error) {
                
                NSLog(@"error = %@", error);
                failure(error);
            }];
        }
            break;
            
        case 1:
        {
            
            //GET请求 只需要将cache设置为true就可以自动缓存
            [PGNetworkHelper GET:url parameters:parameters cache:cache responseCache:responseCache success:^(id responseObject) {
                
                success(responseObject,false);
                NSLog(@"responseObject = %@", responseObject);
                
            } failure:^(NSError *error) {
                
                NSLog(@"error = %@", error);
                failure(error);
                
            }];
        }
            break;
        case 2:
        {
            // 同步请求

            [PGNetworkHelper synchronouslyGET:url parameters:parameters cache:cache responseCache:^(id responseCache) {
                
                
                NSLog(@"responseCache = %@", responseCache);
            
            } success:^(id responseObject) {
                
                success(responseObject,false);
                NSLog(@"responseObject = %@", responseObject);
            
            } failure:^(NSError *error) {
            
                failure(error);
                NSLog(@"error = %@", error);
           
            }];
            
        }
            break;
    }
    
}

// 清除缓存
- (void)removeResponseCache:(NSString *)cacheKey {
    
    if(cacheKey){
        
        [PGNetworkCache removeResponseCacheForKey:cacheKey];
        
    }else {
        
        [PGNetworkCache removeAllResponseCache];
    }
}

#pragma mark - 参数转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    //
    
    NSMutableDictionary *mainDic = [[NSMutableDictionary alloc]init];
 
    mainDic[@"currentPage"] = dic[@"currentPage"];
    mainDic[@"pageSize"] = dic[@"pageSize"];
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mainDic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


/// 用户登录
-(void)loginWithUser:(NSDictionary *)parameters success:(void (^)(void))success failure:(void(^)(void))failure {
    
    //多用户一般用userId来保存每个用户的缓存数据
    [PGNetworkCache pathName:@"userId"];
    
}

static AFHTTPSessionManager *manager;

/// anf
+ (AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [ AFHTTPRequestSerializer serializer ];
        manager.responseSerializer = [ AFHTTPResponseSerializer serializer ];
        manager.requestSerializer.timeoutInterval = 30;// 请求超时时间是20秒
    });
    
    
    
    return manager;
}

/// afn
-(void)loginWithUser:(NSDictionary *)parameters success:(void (^)(void))success failure:(void(^)(void))failure showHUD:(BOOL)showHUD {
    
   
    NSString *params = [self dictionaryToJson:parameters];
    NSString *url ;
    
    // 时间戳转时间
    
    // https 配置
    //    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //    policy.allowInvalidCertificates = YES;
    //    policy.validatesDomainName = YES;
    
    
    AFHTTPSessionManager *manager = [[self class] sharedHttpSessionManager];
    
    //    manager.securityPolicy = policy;
    
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    idfv = [idfv stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"flag"];

    __weak typeof(self) weakSelf = self;
    
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *operation, id responseObject) {
        
        NSInteger lizistatus = 0;
        
        if ([operation.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSLog(@"The return class is subclass %@",NSStringFromClass([NSHTTPURLResponse class]));
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            
            lizistatus = [[allHeaders valueForKey:@"aaaa"] integerValue];
        }
        
        
        //        RespondModel *info = [RespondModel mj_objectWithKeyValues:responseObject];
        
        
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        //        [appDelegate dismiss];
        
        if (failure){
            
            failure();
        }
        
    }];
    
    
}


@end
