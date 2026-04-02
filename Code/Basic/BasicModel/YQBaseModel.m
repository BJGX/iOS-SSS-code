//
//   YQBaseModel.m
   

#import "YQBaseModel.h"

@implementation YQBaseModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"banner": [self class],
            @"service": [self class]
            };
}







@end
