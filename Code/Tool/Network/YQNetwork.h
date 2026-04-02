//
//  YQNetwork.h

//
//  Created by  on 2018/3/16.
//  
//

#import <Foundation/Foundation.h>
#import <AFNetworkReachabilityManager.h>




typedef void(^myblock)(id obj, NSInteger code);
typedef enum : NSUInteger {
    POST,
    GET,
    DELETE,
    PUT,
} RequestMode;

@interface YQNetwork : NSObject

@property (nonatomic, assign) NSInteger showTime;

@property (nonatomic, assign) NSInteger pingCount;

@property (nonatomic, strong) NSString *hostUrl;
@property (nonatomic, strong) NSMutableArray *loadUrlArray;

+ (void)foundHost;

+ (YQNetwork*)shared;


///是否没有网络
+ (BOOL)isNotReachable;


///网络变化监听
+ (void)ReachabilityChanged:(void(^)(AFNetworkReachabilityStatus status))changedBlock;

///获取域名
+ (NSString *)getHostUrl;

+ (NSString *)getFileHostUrl;

+ (void)StopMonitoring;

/**
 网络请求

 @param mode 请求类型
 @param tailUrl url
 @param params params
 @param callBackDictionary 回调
 */
+ (void)requestMode:(RequestMode)mode
            tailUrl:(NSString *)tailUrl
             params:(id)params
     showLoadString:(NSString *)string
           andBlock:(myblock)callBackDictionary;



/**
网络请求

@param mode 请求类型
@param tailUrl url
@param params params
@param backMainThread 是否需要回到主线程
@param callBackDictionary 回调
*/
+ (void)requestMode:(RequestMode)mode
            tailUrl:(NSString *)tailUrl
             params:(id)params
     backMainThread:(BOOL)backMainThread
     showLoadString:(NSString *)string
           andBlock:(myblock)callBackDictionary;



+ (void)uploadVideo:(NSString *)path  andBlock:(myblock)callBackDictionary;

+ (void)uploadImage:(UIImage *)image
           progress:(void(^)(CGFloat progress))proressblock
           andBlock:(myblock)callBackDictionary;
+ (void)uploadImage:(UIImage *)image
           progress:(void(^)(CGFloat progress))proressblock
             string:(NSString *)string
           andBlock:(myblock)callBackDictionary;


+ (void)downloadFile:(NSString *)url
                name:(NSString *)name
            progress:(void(^)(CGFloat progress))progress
       completeBlock:(void(^)(NSString *lrc))completeBlock;

+ (NSURLSessionDownloadTask *)downloadMp3:(NSString *)url name:(NSString *)name progress:(void (^)(CGFloat))progress completeBlock:(void (^)(NSString *))completeBlock;


//+ (void)initNetworking;



+ (void)hiddenProgress;

+ (void)showProgressView:(NSString *)info;

+ (NSString *)getCacheFilePath:(NSString *)url;


+ (void)testPing:(myblock)block;

@end
