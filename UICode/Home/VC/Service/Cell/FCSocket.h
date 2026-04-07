//
//  FCSocket.h
//  ssrMac
//
//  Created by mac on 11/04/2023.
//  Copyright © 2023 ssrLive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCSocket : NSObject

+ (void)contact:(NSString *)addr2 port:(int)port block:(void(^)(NSString *string,NSInteger type))block;
+ (NSString *)getIp:(NSString *)addr;
@end

NS_ASSUME_NONNULL_END
