//
//  NSObject+ClassName.h
//  MiGuIMP
//
//  Created by jtang on 2017/11/02.
//  Copyright © 2017 MiGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ClassName)

+ (NSString *)className;

- (NSString *)className;
+ (NSString *)imageUrlString:(NSString *)str withParamStr:(NSString *)pStr;

@end
