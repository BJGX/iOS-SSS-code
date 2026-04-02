//
//  SystemConfig.h
//  WXReader
//
//  Created by Andrew on 2018/5/15.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#ifndef SystemConfig_h
#define SystemConfig_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define WeakSelf __weak typeof(self) weakSelf = self;
#define SS(strongSelf)__strong __typeof(weakSelf)strongSelf = weakSelf;

//  AppDelegate
#define KAppDelegate ((AppDelegate*)[UIApplication sharedApplication].delegate)

//系统版本
#define is_ios7  [[[UIDevice currentDevice]systemVersion] floatValue] >= 7
#define is_ios8  [[[UIDevice currentDevice]systemVersion] floatValue] >= 8
#define is_ios9  [[[UIDevice currentDevice] systemVersion] floatValue] >= 9
#define is_ios10 [[[UIDevice currentDevice] systemVersion] floatValue] >= 10
#define is_ios11 [[[UIDevice currentDevice] systemVersion] floatValue] >= 11
#define is_ios13 [[[UIDevice currentDevice] systemVersion] floatValue] >= 13

//手机型号
#define is_iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define is_iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define is_iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define is_iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
#define is_iPhone6P ([UIScreen mainScreen].bounds.size.height == 1104)
#define is_KiPhoneX ((([[UIScreen mainScreen] bounds].size.width == 375.0 && \
[[UIScreen mainScreen] bounds].size.height == 812.0) || \
([[UIScreen mainScreen] bounds].size.width == 414.0 && \
[[UIScreen mainScreen] bounds].size.height == 896.0)) ? YES : NO)
#define is_KiPhoneX_Max ((([[UIScreen mainScreen] bounds].size.width == 414.0 && \
[[UIScreen mainScreen] bounds].size.height == 896.0)) ? YES : NO)

#define statusRectH [QYSettingConfig shared].statusBarHeight
#define SafeBottomSpace (statusRectH > 20 ? 34 : 0)
#define SafeTopSpace (statusRectH > 20 ? 24.0f:0.0f)

//主窗口
#define kMainWindow (is_ios13?[[[UIApplication sharedApplication] windows] objectAtIndex:0]:[[UIApplication sharedApplication] keyWindow])


/***
 *   颜色--16进制 && 透明度
 ***/
#define RGB_COLOR_HEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define RGB_COLOR_ALPHA(r,g,b,a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

/**
 *   版本号version
 **/
#define CurrentSystemVersion [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]


#define KNormalPlaceHoldImage [UIImage imageNamed:@"icon_placeholder"]
#define KPlaceHoldImage [UIImage new]
#define KAvatarPlaceHoldImage [UIImage imageNamed:@"icon_placeholder"]

#if __LP64__
#define MZNSI @"ld"
#define MZNSU @"lu"
#else
#define MZNSI @"d"
#define MZNSU @"u"
#endif //__LP64__

#endif /* SystemConfig_h */
