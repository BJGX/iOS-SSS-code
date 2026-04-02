//
//   YQPlayModel.m
   

#import "YQPlayModel.h"

@implementation YQPlayModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"list": [self class],
            @"singer": [self class],
            @"rows":[self class]
            };
}

- (void)setCachePath:(NSString *)cachePath
{
    _cachePath = cachePath;
}
- (void)setSinger:(NSArray *)singer
{
    _singer = singer;
    self.songerString = @"";
    if (singer.count > 0) {
        [singer enumerateObjectsUsingBlock:^(YQPlayModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            self.songerString = [NSString stringWithFormat:@"%@%@ · ",self.songerString,obj.name];
        }];
        self.songerString = [self.songerString substringToIndex:self.songerString.length - 3];
    }
}

@end
