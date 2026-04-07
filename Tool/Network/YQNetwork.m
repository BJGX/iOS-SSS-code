////
////  YQNetwork.m
//
////
////  Created by  on 2018/3/16.
////  
////
//
#import "YQNetwork.h"
#import "YQHTTPSessionManager.h"
#import "UUID.h"
#import "MBProgressHUD.h"
#import "VFAES.h"
//#import "vodUploadLib.h"
#include <CommonCrypto/CommonDigest.h>
#define HOSTURL @"https://and.xinghuan0613.com/"

//#define HOSTURL @"http://141.164.39.134:10000/"


#define hostArray @[@"https://and.xinghuan0613.com/",@"https://and.shuanglong0613.com/",@"https://and.cangqiong0613.com/",@"https://and.lingjie0613.com/",@"https://and.feitu0613.com/"]

//#import <sd>

@interface YQNetworkCode: NSObject


@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *Status;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *data;
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSArray *Answer;
@end

@implementation YQNetworkCode



+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"Answer": [self class]
            };
}



- (void)setStatus:(NSString *)status
{
    _status = status;
    self.code = [status integerValue];
}

@end




@interface YQNetwork()
@property (nonatomic, strong) MBProgressHUD *hub;
@property (nonatomic, assign) BOOL isShowView;
@property (nonatomic, strong) NSString * uuidSring;

@property (nonatomic, strong) NSURLSessionDataTask *task;



@property (nonatomic, strong) NSMutableArray *cacheUrls;

@end


@implementation YQNetwork


+ (YQNetwork*)shared{
    static dispatch_once_t pred;
    static YQNetwork *instance;
    dispatch_once(&pred, ^{
        instance = [[YQNetwork alloc] init];
//        instance.showTime = 0.1;
    });
    return instance;
}

- (NSMutableArray *)cacheUrls
{
    if (!_cacheUrls) {
        _cacheUrls = [NSMutableArray array];
        [_cacheUrls addObjectsFromArray:hostArray];
    }
    return _cacheUrls;
}


- (MBProgressHUD *)hub
{
    if (!_hub) {
        
        UIViewController *vc = [YQUtils getCurrentVC];
        if (vc == nil) {
            return nil;
        }
        
        _hub = [[MBProgressHUD alloc] initWithView:vc.view];
        _hub.minShowTime = 30;
        _hub.backgroundView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.4];
        [vc.view addSubview:_hub];
    }
    return _hub;
}

- (NSString *)uuidSring
{
    if (!_uuidSring) {
        _uuidSring =  [UUID getUUID];
//       _uuidSring = [[YQUtils getCurrentTime] stringByAppendingString: [UUID getUUID]];

    }
    return _uuidSring;
}

- (NSMutableArray *)loadUrlArray
{
    if (!_loadUrlArray) {
        _loadUrlArray = [NSMutableArray array];
    }
    return _loadUrlArray;
}


- (void)showHub:(NSString *)text
{
//    if (_hub) {
//        self.hub.label.text = text;
//        return;
//    }
    
    if (self.isShowView == NO) {
        return;
    }
    
    self.hub.label.text = text.localized;
    [self.hub showAnimated:YES];
}


- (void)hiddenHub
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.hub) {
            return;
        }
        [self.hub removeFromSuperview];
        self.hub = nil;
        self.showTime = 0;
        self.isShowView = NO;
    });
}

+ (BOOL)isNotReachable
{
    AFNetworkReachabilityStatus state = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;

    if (state <= 0) {
        return YES;
    }
    return NO;
}


+ (void)StopMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
}

+ (void)ReachabilityChanged:(void(^)(AFNetworkReachabilityStatus status))changedBlock
{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:changedBlock];
}


- (NSString *)hostUrl {
//    return  @"http://141.164.39.134:10000/";
    if (!_hostUrl) {
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"GETHOST"];
        _hostUrl = self.cacheUrls[index];
//        _hostUrl = HOSTURL;
    }
    return  _hostUrl;
}


///文件域名
+ (NSString *)getFileHostUrl
{
//    return @"http://and.wenzero001.com:50000/";
    return [YQNetwork shared].hostUrl;
//    return @"http://141.164.39.134:10000/";
}

//请求域名
+ (NSString *) getHostUrl{
    return  [YQNetwork shared].hostUrl;
}


+ (void)requestMode:(RequestMode)mode
             tailUrl:(NSString *)tailUrl
              params:(id)params
      backMainThread:(BOOL)backMainThread
      showLoadString:(NSString *)string
            andBlock:(myblock)callBackDictionary
{
    
    if ([[YQNetwork shared].loadUrlArray containsObject:tailUrl]) {
        return;
    }
    
//    if ([YQNetwork shared].pingCount > 0) {
//        NSLog(@"正在连接");
//        return;
//    }
    NSLog(@"123 url  === %@",tailUrl);
    
    NSInteger i = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (i == 0) {
        [YQUtils showCenterMessage:@"网络错误, 请检查您的网络"];
        if (callBackDictionary) {
            callBackDictionary(nil, 1001);
        }
        return;
    }
    
    
    
    
    
    
    if (string.length > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [YQNetwork shared].isShowView = YES;
            [[YQNetwork shared] showHub:string];
        });
        
    }
    
    
    
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSDictionary *newParams = [self getCommonParams:params];
    NSDictionary *header = [self getCommonParams:nil];
    NSString *url = [YQNetwork getHostUrl];
    if (![tailUrl containsString:@"http"]) {
        url = [url stringByAppendingString:tailUrl];
    }
    else {
        url = tailUrl;
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (mode == POST){
        
        
//       NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
//        request.timeoutInterval = 30;
//        [request setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:header options:0 error:nil];
//        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSData *body = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:body];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//
//        [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//
//            if (error == nil) {
//                [self returnSuccessData:response responseObject:responseObject backMainThread:backMainThread andBlock:callBackDictionary];
//            }
//            else {
//                [self returnFailureData:response error:error backMainThread:backMainThread andBlock:callBackDictionary];
//            }
//        }] resume];
//        
        [manager POST:url parameters:newParams headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
        }];
        

    }else  if (mode == GET) {

        [manager GET:url parameters:newParams headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
        }];
        

    }
    else if (mode == DELETE){
        [manager DELETE:url parameters:newParams headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
        }];
    }

    else if (mode == PUT) {
        
        [manager PUT:url parameters:newParams headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
        }];
    }
    else{
    }
}

+ (void)requestMode:(RequestMode)mode
            tailUrl:(NSString *)tailUrl
             params:(id)params
     showLoadString:(NSString *)string
           andBlock:(myblock)callBackDictionary
{
    [self requestMode:mode tailUrl:tailUrl params:params backMainThread:YES showLoadString:(NSString *)string andBlock:callBackDictionary];
}


//MARK: - 请求成功统一处理
+(void)returnSuccessData:(id)task
                     url:(NSString *)url
                  params:(NSDictionary *)params
          responseObject:(id)responseObject
          backMainThread:(BOOL)backMainThread
                andBlock: (myblock)callBackDictionary
{
//    NSURLSessionDataTask
    [[YQNetwork shared].loadUrlArray removeObject:url];
    [[YQNetwork shared] hiddenHub];
    NSHTTPURLResponse *response;
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask *responseTask = task;
        response = (NSHTTPURLResponse *)responseTask.response;
    }
    else {
        response = task;
    }
    NSDictionary *dic = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        dic = responseObject;
    }else{
        dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
    }
    
//    NSLog(@"%@",task);
    
    YQNetworkCode *codeModel = [YQNetworkCode mj_objectWithKeyValues:dic];
    LH_AESModel *subModel = [VFAES aesDecrypt2:dic[@"data"]];
    if (subModel.obj) {
        dic = @{
            @"data":subModel.obj
        };
    }
    
    NSInteger code = codeModel.code;
    if (code != 1 && ![url containsString:@"https://doh.pub/dns-query"] && ![url containsString:@"https://myip.ipip.net"]) {
        [YQUtils showCenterMessage:codeModel.message];
        NSLog(@"错误信息 === %@", dic);
        NSString *messgae = [NSString stringWithFormat:@"url:%@\nparams:%@\nDicError:%@",url,[params description],[dic description]];
        [[SimpleLogger sharedLogger] logWithLevel:LogLevelError category:@"NetError" message:messgae];
    }
    
    if (code == -1) {
//        if ([QYSettingConfig shared].showLoginVC) {
//            return;
//        }
//        [QYSettingConfig shared].showLoginVC = YES;
        [YQUserModel logOutSocket];
    }

    
    if (callBackDictionary) {
        if (backMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBackDictionary(dic, code);
            });
        }
        
        else {
            callBackDictionary(dic, code);
        }
    }
    

}
//
//MARK: - 请求失败统一处理
+ (void)returnFailureData:(id)task
                      url:(NSString *)url
                   params:(NSDictionary *)params
                    error:(NSError *)error
           backMainThread:(BOOL)backMainThread
                 andBlock:(myblock)callBackDictionary
{
    
    [[YQNetwork shared].loadUrlArray removeObject:url];
    [[YQNetwork shared] hiddenHub];
    
    
    NSInteger i = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (i == 0) {
        [YQUtils showCenterMessage:@"网络错误, 请检查您的网络"];
        if (callBackDictionary) {
            if (backMainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBackDictionary(nil, 1001);
                });
            }
            
            else {
                callBackDictionary(nil, 1001);
            }
        }
    }
    
    
    NSHTTPURLResponse *response;
    if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSURLSessionDataTask *responseTask = task;
        response = (NSHTTPURLResponse *)responseTask.response;
    }
    else {
        response = task;
    }
    
    
    
    NSInteger code = response.statusCode;
    
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *dic;
    if (errorData) {
        dic = [NSJSONSerialization JSONObjectWithData: errorData options:kNilOptions error:nil];
    }
    
    if (code == 1) {
        code = 999;
    }
    
    NSLog(@"Failure error serialised - %@",dic);
    
    NSString *messgae = [NSString stringWithFormat:@"url:%@\nparams:%@\nDicError:%@\nnetError:%@",url,[params description],[dic description],error.description];
    
    [[SimpleLogger sharedLogger] logWithLevel:LogLevelError category:@"NetError" message:messgae];
    
    
    if (code >= 500 && code < 600) {
        NSString *errorS = [NSString stringWithFormat:@"服务器报错接口\n%@",response.URL];
        NSLog(@"%@", errorS);
        [self testPing:nil];
    }

    else if (code == -1001) {
        NSLog(@"%@", @"请求超时, 请稍候重试");
//        [self testPing:nil];
    }
    
    else if (dic) {
        NSString *msg = dic[@"message"];

        if (msg) {
            [YQUtils showCenterMessage:dic[@"message"]];
        }
    }
    if (error.code == -1005) {
        code = -1005;
    }
    if (callBackDictionary) {
        if (backMainThread) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callBackDictionary(dic, code);
            });
        }
        
        else {
            callBackDictionary(dic, code);
        }
    }
    
    
    
    
}





+ (NSDictionary *)getCommonParams:(NSDictionary *)dic {
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionary];
    if (dic) {
        [newParams addEntriesFromDictionary:dic];
    }
    
    NSString *token = @"";
    if ([[YQUserModel shared].user.token length]) {
        newParams[@"token"] = [YQUserModel shared].user.token;
        token= [YQUserModel shared].user.token;
    }
    
//    if ([[YQUserModel shared].user.token length]) {
//        newParams[@"X-Request-Token"] = [YQUserModel shared].user.token;
//        NSLog(@"token = %@",[YQUserModel shared].user.token);
//    }
//
//    newParams[@"platform"] = @"Android";
//    newParams[@"channel"] = @"10001";
    NSString *platform = @"ios";
    NSString *channel = @"89201";
    if ([DeviceHelper isiPadOnMac]) {
        platform = @"mac";
        channel = [self currentAppChannel];
    }
    newParams[@"platform"] = platform;
    newParams[@"channel"] = channel;
    

    
//    if ([NSProcessInfo processInfo].isiOSAppOnMac) {
//        newParams[@"channel"] = @"90210";
//        newParams[@"platform"] = @"mac";
//    }
    newParams[@"is_ios_data"] = App_Ver;
    newParams[@"if_aes"] = @"1";
    newParams[@"is_version"] = @"3";
    newParams[@"lan"] = [[NPLanguageTool shared].current isEqualToString:@"en"] ? @"en" : @"cn";
//
    if (dic[@"device_id"] == nil) {
        newParams[@"device_id"] = [YQNetwork shared].uuidSring;
    }
    if (dic[@"device"] == nil) {
        newParams[@"device"] = [YQNetwork shared].uuidSring;
    }
    
    NSString *time = [NSString stringWithFormat:@"%ld",[YQUtils currentTimeStamp]];
    NSString *first = [NSString stringWithFormat:@"e2f7c058385541e78778383882115bd8%@",time];
    NSString *first2 = [NSString stringWithFormat:@"%@%@",[YQNetwork shared].uuidSring,time];
    
    NSString *first3 = [NSString stringWithFormat:@"%@%@",token,time];
    
    NSString *firMD5 = [self stringToMD5:first];
    NSString *firMD52 = [self stringToMD5:first2];
    NSString *firMD53 = [self stringToMD5:first3];
    
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",firMD5,firMD52,firMD53];
    
    NSString *signMD5 = [self stringToMD5:sign];
    
    newParams[@"timestamp"] = time;
    newParams[@"sign"] = signMD5;
    
//    NSLog(@"header === %@", newParams);
    return newParams;
    
}

+ (NSString *)currentAppChannel {
//    return @"81001";
    NSString *channel = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"App_Channel"];
    if ([channel isKindOfClass:[NSNumber class]]) {
        channel = [(NSNumber *)channel stringValue];
    }
    if ([channel isKindOfClass:[NSString class]] && channel.length > 0) {
        return channel;
    }
    if ([DeviceHelper isiPadOnMac]) {
        return @"90210";
    }
    return @"89201";
}


+ (NSString *)getAuthString:(NSDictionary *)params
{
    NSArray *keyArray = [params allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[params objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        if (valueArray[i]) {
            [signArray addObject:keyValueStr];
        }
    }
    NSString *params_str = [signArray componentsJoinedByString:@"&"];
    NSString *key = @"af1020a25f48ds4g55r6y.";
    NSString *sign = [params_str stringByAppendingFormat:@"_%@",key];
    return [self stringToMD5:sign];
}


+ (NSString *)stringToMD5:(NSString *)inputStr
{
    const char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];
}




//MARK: - 上传图片
///图片
+ (void)uploadImage:(UIImage *)image
           progress:(void(^)(CGFloat progress))proressblock
           andBlock:(myblock)callBackDictionary
{
    [self uploadImage:image progress:proressblock string:nil andBlock:callBackDictionary];
}
+ (void)uploadImage:(UIImage *)image
           progress:(void(^)(CGFloat progress))proressblock
             string:(NSString *)string
           andBlock:(myblock)callBackDictionary
{
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSDictionary *header = [self getCommonParams:nil];
    
    if (string.length > 0) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [YQNetwork shared].isShowView = YES;
            [[YQNetwork shared] showHub:string];
        });
        
    }
    
    NSString *tailUrl = @"api/en/user/uploadImg";
    NSString *url = [YQNetwork getHostUrl];
    if (![tailUrl containsString:@"http"]) {
        url = [url stringByAppendingString:tailUrl];
    }
    else {
        url = tailUrl;
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:url parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        NSString *md5 = [self getMD5:imageData];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", md5];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat p = uploadProgress.completedUnitCount / 1.0 / uploadProgress.totalUnitCount / 1.0;
        if (proressblock) {
            proressblock(p);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
    }];
}



///视频
+ (void)uploadVideo:(NSString *)path andBlock:(myblock)callBackDictionary

{
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data == nil) {
        callBackDictionary(nil,-200);
        return;
    }
    
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSDictionary *header = [self getCommonParams:nil];
    
    
    NSString *tailUrl = @"edcIpad/file/upload";
    NSString *url = [YQNetwork getHostUrl];
    if (![tailUrl containsString:@"http"]) {
        url = [url stringByAppendingString:tailUrl];
    }
    else {
        url = tailUrl;
    }
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:url parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            
        NSString *md5 = [self getMD5:data];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", md5];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"audio/mp3"];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self returnSuccessData:task url:url params:header responseObject:responseObject backMainThread:YES andBlock:callBackDictionary];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self returnFailureData:task url:url params:header error:error backMainThread:YES andBlock:callBackDictionary];
    }];
    
    
    
    
}


+ (NSString *)getMD5:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}



+ (NSString *)decodeString:(NSString *)string {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSString *decodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return decodeString;
}




+ (NSURLSessionDownloadTask *)downloadMp3:(NSString *)url name:(NSString *)name progress:(void (^)(CGFloat))progress completeBlock:(void (^)(NSString *))completeBlock
{
    NSString *path = [self getMainFilePathWithFileName:name];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//        if (completeBlock) {
//            completeBlock(path);
//        }
//        return nil;
    }
    
    
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSURLRequest *request = [NSURLRequest requestWithURL:imageOfNSURL(url)];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat p = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"正在下载%f",p);
        if (progress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(p);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *url = [NSURL fileURLWithPath:path];
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completeBlock) {
            completeBlock([filePath absoluteString]);
        }
    }] ;
    [task resume];
    return task;
}

+ (void)downloadFile:(NSString *)url
                name:(NSString *)name
            progress:(void(^)(CGFloat progress))progress
       completeBlock:(void(^)(NSString *lrc))completeBlock
{
    NSString *fileName = [NSString stringWithFormat:@"%@.lrc",name];
    NSString *filePath = [self getLrcPathWithFileName:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *lrc = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (completeBlock) {
            completeBlock(lrc);
        }
        return;
    }
    
    
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSURLRequest *request = [NSURLRequest requestWithURL:imageOfNSURL(url)];
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            CGFloat p = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(p);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSString *lrc = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
        if (completeBlock) {
            completeBlock(lrc);
        }
    }] resume];
}


+ (NSString *)getCacheFilePath:(NSString *)name
{
    NSString *filePath = [self getMainFilePathWithFileName:name];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] ? filePath : nil;
}

+ (NSString*)getMainFilePathWithFileName:(NSString *)name
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"MusicData/Music"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:name];
    return path;
}

+ (NSString*)getLrcPathWithFileName:(NSString *)name
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"MusicData/Lrc"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:name];
    return path;
}




+ (void)hiddenProgress
{
    [[YQNetwork shared] hiddenHub];
}


+ (void)showProgressView:(NSString *)info

{
    dispatch_async(dispatch_get_main_queue(), ^{
        [YQNetwork shared].isShowView = YES;
        [[YQNetwork shared] showHub:info];
    });
}


+ (UIWindow *)currentWindow {
    return [YQUtils getKeyWindow];
}

+ (void)testPing:(myblock)block
{

    
    YQHTTPSessionManager *manager= [YQHTTPSessionManager share].manager;

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 50;
    manager.completionQueue = dispatch_get_global_queue(0, 0);
    NSDictionary *newParams = [self getCommonParams:nil];
    NSString *url = [YQNetwork getHostUrl];

    WeakSelf;
    [YQNetwork shared].task = [manager GET:url parameters:newParams headers:newParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *s = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        if (![s containsString:@"加速"]) {
//            NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"GETHOST"];
//            index += 1;
//            if (index >= [YQNetwork shared].cacheUrls.count) {
//                index = 0;
//                [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"GETHOST"];
//            }
//        }

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"GETHOST"];
        index += 1;
        if (index >= [YQNetwork shared].cacheUrls.count) {
            index = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"GETHOST"];
            [YQNetwork shared].hostUrl = nil;
        }
    }];
    
    
}

+ (void)foundHost
{

//    linglunxuntxtjx.com // shuanglongdnstxt.com
    NSString *url = @"https://doh.pub/dns-query?name=shuanglongdnstxt.com&type=txt";
    [YQNetwork requestWithOtherUrl:url host:@"https://doh.pub" andBlock:^(id obj, NSInteger code) {
        YQNetworkCode *model = [YQNetworkCode mj_objectWithKeyValues:obj];
        if ([model.status isEqualToString:@"0"]) {
            YQNetworkCode *objModel = model.Answer.firstObject;
            if (objModel) {
                NSString *urls = [objModel.data stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *array = [urls componentsSeparatedByString:@","];
                [array enumerateObjectsUsingBlock:^(NSString * url, NSUInteger idx, BOOL * _Nonnull stop) {
                    [[YQNetwork shared].cacheUrls addObject:[NSString stringWithFormat:@"%@/",url]];
                }];
            }
        }
    }];
    
}




+ (void)requestWithOtherUrl:(NSString *)url host:(NSString *)host  andBlock:(myblock)callBackDictionary
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    config.connectionProxyDictionary = @{
    };
    AFHTTPSessionManager *_manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:host] sessionConfiguration:config];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    _manager.completionQueue = dispatch_get_global_queue(0, 0);
    
    [_manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response;
        if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            NSURLSessionDataTask *responseTask = task;
            response = (NSHTTPURLResponse *)responseTask.response;
        }
        else {
            response = task;
        }
        NSDictionary *dic = nil;
        NSString *string = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dic = responseObject;
        }else{
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if (dic == nil) {
                string = [responseObject mj_JSONString];
            }
            
        }
        
        
        
        
        if (callBackDictionary) {
            callBackDictionary(dic ?: string, 0);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
    
}


@end
