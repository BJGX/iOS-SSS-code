//
//  YQHTTPSessionManager.h

//
//  Created by  on 2018/3/16.
//  
//

#import <AFNetworking/AFNetworking.h>

@interface YQHTTPSessionManager : AFHTTPSessionManager
+(instancetype) share;
@property(nonatomic,strong)YQHTTPSessionManager * manager;
@end
