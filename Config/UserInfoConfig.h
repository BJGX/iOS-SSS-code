//
//  UserInfoConfig.h
//  WXReader
//
//  Created by Andrew on 2018/5/15.
//  Copyright © 2018年 Andrew. All rights reserved.
//

// 软件版本 v3.1.1

#ifndef UserInfoConfig_h
#define UserInfoConfig_h


#define DebugBySimulator 1



#define imageOfNSURL(url) [YQUtils getURL_byHost:url]


#define Apple_ID @"6752233558" //https://itunes.apple.com/cn/app/id6752233558?mt=8

// App版本
#define App_Ver [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]


// App Bundle版本
#define App_Bundle [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]

// App名称
#define App_Name [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]

// 用户信息存储key
#define WX_USER_INFO @"wx_user_info_WX81818181"




// 好评页跳转地址
#define WX_EvaluationAddress @"https://apps.apple.com/app/sss-vpn-safe-speed-stable/id6752233558"

/*
 modular
 */




#ifdef DEBUG
    #define TEST_ING YES
#else
    #define TEST_ING NO
#endif

#endif /* UserInfoConfig_h */
