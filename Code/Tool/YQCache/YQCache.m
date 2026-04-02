//
//  YQCache.m

//
//  Created by  on 2018/3/19.
//  
//

#import "YQCache.h"
//#import <YYCache.h>
#import <YYCache/YYCache.h>

@implementation YQCache


+ (void)saveCache:(id)obj key:(NSString *)key{
    NSString *key2 = key;
    if (!obj) {
        return;
    }
    
    YYCache *cache = [YYCache cacheWithName:@"Cache"];
    [cache setObject:obj forKey:key2];
    
}

+ (id)getCache:(NSString *)key {
    NSString *key2 = key;
    YYCache *cache = [YYCache cacheWithName:@"Cache"];
    id object = [cache objectForKey:key2];
    return object;
    
}

+ (void)clearSaveDataForKey:(NSString *)key {
    YYCache *cache = [YYCache cacheWithName:@"Cache"];
    [cache removeObjectForKey:key];
}

+ (void)saveDataToPlist:(id)obj key:(NSString *)key {
    
    if (obj == nil || key == nil) {
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:obj forKey:key];
    [user synchronize];
}

+(id)getDataFromPlist:(NSString *)key {
    if (key == nil) {
        return nil;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    id obj = [user objectForKey:key];
    return obj;
}

+ (void)clearDataFromPlist:(NSString *)key {
    if (key == nil) {
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:key];
    [user synchronize];
}



+ (void)saveChapterList:(NSDictionary *)dic bookID:(NSString *)bookID
{
    NSString *key = [NSString stringWithFormat:@"saveChapterList_ID_%@",bookID];
    [YQCache saveCache:dic key:key];
}

+ (id)getChapterListWithBookID:(NSString *)bookID{
    NSString *key = [NSString stringWithFormat:@"saveChapterList_ID_%@",bookID];
    return  [YQCache getCache:key];;
}


@end
