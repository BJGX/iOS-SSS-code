#import "YQUserModel.h"
#import "YQCache.h"

#import "YQTabBarController.h"
#import "YQNavigationController.h"
#import "VFLoginVC.h"
#import "VFTipsView.h"

CGFloat topHeightIPhoneX = 0;
CGFloat bottomHeightIPhoneX = 0;

@implementation YQUserModel


+ (YQUserModel*)shared{
    static dispatch_once_t pred;
    static YQUserModel *instance;
    dispatch_once(&pred, ^{
        instance = [[YQUserModel alloc] init];
    });
    return instance;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
            @"service": [YQBaseModel class]
            };
}


+ (void)loginOutUser
{
    if ([QYSettingConfig shared].showLoginVC) {
        return;
    }
    [QYSettingConfig shared].showLoginVC = YES;
    [self clearInfo];
    
    VFLoginVC *vc = (VFLoginVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFLoginVC"];
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    UIViewController *pVC = [YQUtils getCurrentVC];
    [pVC presentViewController:nav animated:YES completion:nil];
    
}


+ (void)logOutSocket {
    
    if ([QYSettingConfig shared].showLoginVC) {
        return;
    }
    [QYSettingConfig shared].showLoginVC = YES;
    [self clearInfo];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [VFTipsView showView:@"提示" content:@"登录过期,请重新登录" leftBtn:@"" rightBtn:@"重新登录" block:^(NSInteger code) {
            VFLoginVC *vc = (VFLoginVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFLoginVC"];
            YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
            nav.modalPresentationStyle = UIModalPresentationCustom;
            UIViewController *pVC = [YQUtils getCurrentVC];
            [pVC presentViewController:nav animated:YES completion:nil];
            
        }];
    });
    
    
    
    
    
}

+ (void)clearInfo {
    [YQUserModel shared].user = nil;
    [YQCache clearDataFromPlist:@"SaveUserInfo"];
    
}

+ (void)saveUserInfo {
    [YQUserModel shared].user.isLogin = YES;
    [QYSettingConfig shared].showLoginVC = NO;
    NSDictionary * userDic = [[YQUserModel shared].user mj_keyValues];
    
    if (userDic) {
        [YQCache saveDataToPlist:userDic key:@"SaveUserInfo"];
    }
    else{
        NSLog(@"存储失败");
    }
    [QYSettingConfig shared].showLoginVC = NO;
}


+ (void)getUserInfo {
    NSDictionary *userDic = [YQCache getDataFromPlist:@"SaveUserInfo"];
    if (userDic == nil) {
        userDic = [YQCache getDataFromPlist:@"SaveUserInfo"];
    }
    
    
    if (userDic!= nil) {
        [YQUserModel shared].user = [YQUserModel mj_objectWithKeyValues:userDic];
    }
    else{
        [YQUserModel shared].user = [[YQUserModel alloc] init];
        NSLog(@"获取失败");
    }
    
    
    
    
}


+ (BOOL)showLoginVC {
    BOOL isLogin = [YQUserModel shared].user.isLogin;
    if (isLogin) {
        return isLogin;
    }
    [self loginOutUser];
    return isLogin;
}

+ (BOOL)isLogined:(BOOL)isPushToLoginVC {
    BOOL isLogin = [YQUserModel shared].user.isLogin;
    if (isLogin) {
        return isLogin;
    }
    
    if (isPushToLoginVC) {
        
        
        
//        XSB_LoginViewController *vc = [[XSB_LoginViewController alloc] init];
//
//        [[YQUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
    return isLogin;
}


@end
