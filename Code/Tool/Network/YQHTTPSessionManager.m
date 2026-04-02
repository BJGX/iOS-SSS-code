//
//  YQHTTPSessionManager.m

//
//  Created by  on 2018/3/16.
//  
//

#import "YQHTTPSessionManager.h"
#import "NSURLSession+VFChange.h"

@implementation YQHTTPSessionManager
+(instancetype)share {
    static YQHTTPSessionManager * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//        config.connectionProxyDictionary = @{
//        };
        _manager = [[YQHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:nil];
        _manager.requestSerializer.timeoutInterval = 30;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _manager;
}


-(YQHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [YQHTTPSessionManager share];
    }
    [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _manager.requestSerializer.timeoutInterval = 30;
    [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return _manager;
}

@end
