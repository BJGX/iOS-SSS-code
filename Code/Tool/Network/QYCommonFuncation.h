//
//   QYCommonFuncation.h
   

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeiPhone,
    DeviceTypeiPad,
    DeviceTypeiPadOnMac
};


///code ==1 成功
typedef void(^stateBlock)(NSInteger code);
typedef void(^userInofBlock)(NSInteger code, NSArray * _Nullable bannerArray);

NS_ASSUME_NONNULL_BEGIN



@interface QYCommonFuncation : NSObject

+ (void)loginWithTourist:(stateBlock)block;


+ (void)getUserInfo:(stateBlock)block;

+ (void)getUserInfoWithString:(NSString *)string block:(stateBlock)block;

+ (void)shouKefu;


+ (void)getServiceData:(NSString *)ID mainThird:(BOOL)mainThird;


+ (void)upldateApp;


@end


@interface DeviceHelper : NSObject

/// 获取当前设备类型
+ (DeviceType)currentDeviceType;

/// 便捷判断方法
+ (BOOL)isiPhone;
+ (BOOL)isiPad;
+ (BOOL)isiPadOnMac;
+ (BOOL)isRunningOnMac;

/// 设备类型描述
+ (NSString *)deviceTypeString;

+ (CGFloat)returnScreenWidth;

+ (CGFloat)returnScreenHeight;

@end

NS_ASSUME_NONNULL_END
