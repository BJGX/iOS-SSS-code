//


#import "NSURLSession+VFChange.h"

@implementation NSURLSession (VFChange)
//+(void)load{
//    Method oldMethod = class_getClassMethod(self, @selector(sessionWithConfiguration:delegate:delegateQueue:));
//    Method newMethod = class_getClassMethod(self, @selector(newSessionWithConfiguration:delegate:NSURLSessiondelegateQueue:));
//    
//    Method oldMethod1 = class_getClassMethod(self, @selector(sessionWithConfiguration:));
//    Method newMethod1 = class_getClassMethod(self, @selector(newSessionWithConfiguration:));
//      
//     method_exchangeImplementations(oldMethod1, newMethod1);
//     method_exchangeImplementations(oldMethod, newMethod);
//}
//+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration{
//    configuration=[self newConfiguration:configuration];
//    NSURLSession *section=
//       [self newSessionWithConfiguration:configuration];
//       return section;
//}
//+ (NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id <NSURLSessionDelegate>)delegate NSURLSessiondelegateQueue:(nullable NSOperationQueue *)queue{
//    configuration=[self newConfiguration:configuration];
//    NSURLSession *section=
//    [self newSessionWithConfiguration:configuration delegate:delegate NSURLSessiondelegateQueue:queue];
//    return section;
//}
//
//
//+(NSURLSessionConfiguration *)newConfiguration:(NSURLSessionConfiguration *)configuration{
//////通过服务器配置HTTPS代理
////    NSString *proxy=@"";
////    NSInteger port=;
////    configuration.connectionProxyDictionary = @{
////          @"HTTPEnable":@YES,
////          @"HTTPProxy":proxy,
////          @"HTTPPort":@(port),
////          @"HTTPSEnable":@YES,
////          @"HTTPSProxy":proxy,
////          @"HTTPSPort":@(port),
////      };
////    NSString *user=@"";
////    NSString *password=@"";
////    NSString* proxyIDPasswd = [NSString stringWithFormat:@"%@:%@",user,password];
////    NSData* proxyoriginData = [proxyIDPasswd dataUsingEncoding:NSUTF8StringEncoding];
////    NSString *base64EncodedCredential = [proxyoriginData base64EncodedStringWithOptions:0];
////    NSString *authString = [NSString stringWithFormat:@"Basic: %@", base64EncodedCredential];
//    configuration.connectionProxyDictionary = @{};
//    return configuration;
//}

@end
