//
//  NBNetWork.h
//  nbProxy
//
//  Created by xdk on 2018/3/22.
//  Copyright © 2018年 NBP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

// 网络请求带缓存
#import <PGNetworkHelper/PGNetworkHelper.h>

typedef NS_ENUM(NSInteger, Type)
{
    TypePost = 0,
    TypeGet  = 1,
    TypeSynGet = 2 //同步请求
};

/// 数据交互
@interface NBNetWork : NSObject

/// 管理请求
@property (nonatomic, strong) AFHTTPSessionManager *manager;

/// 请求地址
@property (nonatomic, strong) NSString *baseUrl;


/**
 网络请求单例方法

 @return 网络请求类 NBNetWork
 */
+ (NBNetWork *)shareNetwork;


/**
 网络请求

 @param type 请求类型（post get）
 @param url 请求地址
 @param parameters 请求参数
 @param cache 缓存（ture：false 根据url进行缓存，如果需要对参数缓存 需配置里面）
 @param responseCache 返回数据
 @param success 请求成功
 @param failure 请求失败
 */
- (void)requstMethods:(Type)type
         url:(NSString *)url
  parameters:(id)parameters
       cache:(BOOL)cache
responseCache:(id)responseCache
     success:(void(^)(id responseObject,BOOL error))success
     failure:(void(^)(NSError *error))failure;


/**
 *  上传图片文件
 *
 *  @param url        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 */
- (void)upImage:(NSString *)url
     parameters:(NSDictionary *)parameters
         images:(NSArray *)images
           name:(NSString *)name
       fileName:(NSString *)fileName
       mimeType:(NSString *)mimeType
       progress:(void)progress
        success:(void)success
        failure:(void)failure;


/**
 清除缓存（如果cachekey为nil，则删除所有缓存）

 @param cacheKey 更加url缓存数据（需要传入url）
 */
- (void)removeResponseCache:(NSString *)cacheKey;


/**
  用户登录
 */
- (void)userLonin;

/**
 * 登录接口
 *
 *  @parma parameters 登录参数
 *  @parma success    登录成功后方法
 *  @parma failure    登录失败后方法
 *
 *  return  nil
 */
-(void)loginWithUser:(NSDictionary *)parameters success:(void (^)(void))success failure:(void(^)(void))failure;



@end
