//
//  ColorConfig.h
//  WXReader
//
//  Created by Andrew on 2018/5/15.
//  Copyright © 2018年 Andrew. All rights reserved.
//

#ifndef ColorConfig_h
#define ColorConfig_h

/*
 颜色获取方法
 */
#define kColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kColorRGB(r,g,b) kColorRGBA(r,g,b,1)

#define rgba(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//  随机色
#define kRandomColor kColorRGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1)

#define kColorXRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]  //十六进制颜色(不带透明度)

/*
 色调值 命名方式 k+颜色+Color
 */

// 主色调
#define kMainColorMagicAlpha(x) kColorRGBA(0, 0, 0, x)

#define kMainColor rgba(25, 200, 115, 1)




// 颜色管理

#define kOrangeColor kColorRGBA(246, 122, 89, 1)

#define kBlueColor kColorRGBA(53, 199, 255, 1)

#define kYellowColor kColorRGBA(235, 210, 32, 1)

#define kBlackColor kColorRGBA(16, 16, 20, 1)

#define kWhiteColor kColorRGBA(255, 255, 255, 1)

#define kRedColor kColorRGBA(231, 85, 79, 1)

#define kGrayLineColor kColorRGBA(247, 248, 249, 1)

#define kGrayViewColor kColorRGBA(250, 250, 250, 1)

#define kGrayDeepViewColor kColorRGBA(241, 242, 241, 1)

#define kGrayTextColor kColorRGBA(176, 176, 176, 1)

#define kGrayTextLightColor kColorRGBA(153, 153, 153, 1)

#define kGrayTextDeepColor kColorRGBA(77, 77, 75, 1)


#define kLineColor kColorRGBA(245, 245, 245, 1)

#define normalBackgroundColor kColorRGBA(249, 249, 249, 1)




#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]


#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define mainColor rgba(121, 203, 31, 1)
#define mainGreenColor rgba(56, 112, 65, 1)


#define HoldImage [UIImage imageNamed:@"holdImage.png"]

#define HoldUserAvatar \
(\
{\
UIImage *userAvatar = [UIImage imageNamed:@"hold_user_avatar_boy.png"];\
if ([[[YQUserInfoManager shareManager] getUserInfoWithKey:USER_GENDER] isEqualToString:@"1"]) {\
userAvatar = [UIImage imageNamed:@"hold_user_avatar_girl.png"];\
}\
(userAvatar);\
}\
)

#endif /* ColorConfig_h */
