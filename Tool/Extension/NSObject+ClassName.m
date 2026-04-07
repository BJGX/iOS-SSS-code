//
//  NSObject+ClassName.m
//  MiGuIMP
//
//  Created by jtang on 2017/11/02.
//  Copyright © 2017 MiGu. All rights reserved.
//

#import "NSObject+ClassName.h"

@implementation NSObject (ClassName)

+ (NSString *)className {
  return NSStringFromClass(self);
}

- (NSString *)className {
  return NSStringFromClass(self.class);
}


+ (NSString *)imageUrlString:(NSString *)str withParamStr:(NSString *)pStr {
    NSString *returnStr = nil;
    if ([str containsString:@"?"] && ![str hasSuffix:@"?"]) {  // www.xxx.com?log_at=1&w=100
        
        returnStr = [NSString stringWithFormat:@"%@&%@",str, pStr];
        
    }else if ([str hasSuffix:@"?"]){   // 防止 www.xxx.com?
        returnStr = [NSString stringWithFormat:@"%@%@",str, pStr];
    }else {
        returnStr = [NSString stringWithFormat:@"%@?%@",str, pStr];  // www.xxx.com
    }
    return returnStr;
}


@end
