//
//  YQCache.h

//
//  Created by  on 2018/3/19.
//  
//

#import <Foundation/Foundation.h>


@interface YQCache : NSObject


+ (void)saveCache:(id) obj key: (NSString *)key;

+ (id)getCache: (NSString *)key;


+ (void)clearSaveDataForKey: (NSString *)key;

+ (void)saveDataToPlist: (id) obj key: (NSString *)key;
+ (id)getDataFromPlist: (NSString *)key;
+ (void)clearDataFromPlist: (NSString *)key;






@end
