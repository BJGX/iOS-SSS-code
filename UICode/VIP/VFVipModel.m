//
//  VFVipModel.m
//  VFProject
//


//

#import "VFVipModel.h"

@implementation VFVipModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"vip": [self class],
            @"activity": [self class]
            };
}

@end
