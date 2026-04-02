//
//  FCVPNManager.h
//  ssrMac
//
//  Created by  on 2025/8/14.
//  Copyright © 2025 ssrLive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FCVPNStatusOff = 0,
    FCVPNStatusConnecting,
    FCVPNStatusON,
    FCVPNStatusdDsconnecting
} FCVPNStatus;


@interface FCVPNManager : NSObject


+ (instancetype)sharedManager;

@property (nonatomic, assign) FCVPNStatus vpnStatus;


//- (void)setDefaultConfigGroupWithParam:(NSDictionary *)param proxy:(BOOL)proxy;
//- (void)regenerateConfigFiles:(NSDictionary *)param proxy:(BOOL)proxy;
//- (void)startVPN:(NSDictionary *)options completeBlock:(void(^)(NSError *error))completeBlock;
- (void)stopVPN;

+ (void)stopVPN;
- (void)setup;
- (void)setDefaultConfigGroupWithParam:(NSDictionary *)param proxy:(BOOL)proxy;
- (void)switchVPN;
- (void)removeManager;


//- (void)initSelf;
@end

NS_ASSUME_NONNULL_END
