//
//   QYCommonFuncation.m
   

#import "QYCommonFuncation.h"
#import "VFAES.h"
#import "VFTipsView.h"



@implementation DeviceHelper

+ (DeviceType)currentDeviceType {
#if TARGET_OS_MACCATALYST
    return DeviceTypeiPadOnMac;
#else
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // 检查是否在 Mac 上运行（iOS 14+）
        if (@available(iOS 14.0, *)) {
            if ([NSProcessInfo processInfo].iOSAppOnMac) {
                return DeviceTypeiPadOnMac;
            }
        }
        return DeviceTypeiPad;
    } else {
        return DeviceTypeiPhone;
    }
#endif
}

+ (CGFloat)returnScreenWidth
{
    return [DeviceHelper isiPadOnMac] ? 800 : [UIScreen mainScreen].bounds.size.width;
}


+ (CGFloat)returnScreenHeight
{
    return [DeviceHelper isiPadOnMac] ? 850 : [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)isiPhone {
    return [self currentDeviceType] == DeviceTypeiPhone;
}

+ (BOOL)isiPad {
    return [self currentDeviceType] == DeviceTypeiPad;
}

+ (BOOL)isiPadOnMac {
    return [self currentDeviceType] == DeviceTypeiPadOnMac;
}

+ (BOOL)isRunningOnMac {
#if TARGET_OS_MACCATALYST
    return YES;
#else
    if (@available(iOS 14.0, *)) {
        return [NSProcessInfo processInfo].iOSAppOnMac;
    }
    return NO;
#endif
}

+ (NSString *)deviceTypeString {
    switch ([self currentDeviceType]) {
        case DeviceTypeiPhone:
            return @"iPhone";
        case DeviceTypeiPad:
            return @"iPad";
        case DeviceTypeiPadOnMac:
            return @"iPad on Mac";
    }
}

@end

@implementation QYCommonFuncation

+ (void)loginWithTourist:(stateBlock)block
{
    if (![YQUserModel shared].user.isLogin) {
        return;
    }
    
    NSString *url = @"api/en/user/tourist";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:@"正在配置" andBlock:^(id obj, NSInteger code) {
        
        if (code == 1) {
            YQUserModel *user= [YQUserModel shared].user;
            if (user == nil) {
                user = [[YQUserModel alloc] init];
            }
            user.token = obj[@"data"][@"token"];
            user.isLogin = YES;
            [YQUserModel shared].user = user;
//            [self getUserInfo:block];
        }
        
    }];
}

+ (void)shouKefu
{
    NSString *url = @"api/en/mine/kefu";
    [YQNetwork requestMode:GET tailUrl:url params:nil showLoadString:@"正在获取" andBlock:^(id obj, NSInteger code) {
        if ( code == 1) {
            NSString *ip = obj[@"data"][@"ip"];
            NSString *url = obj[@"data"][@"zxkf"];
            NSString *uid = [[YQUserModel shared].user.ID length] ? [YQUserModel shared].user.ID : ip;
            url = [url stringByAppendingFormat:@"visiter_id=%@&visiter_name=fc-%@",uid,uid];
            [YQUtils openUrl:url];
        }
    }];
}


+ (void)getUserInfoWithString:(NSString *)string block:(stateBlock)block
{
    
    if (![YQUserModel shared].user.isLogin) {
        return;
    }
    NSLog(@"用户信息");
    NSString *url = @"api/en/v3/user/details";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:string andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            LH_AESModel *AESModel = [VFAES aesDecrypt2:obj[@"data"]];
            YQUserModel *model = [YQUserModel mj_objectWithKeyValues:AESModel.obj];
            model.token = [YQUserModel shared].user.token;
            [YQUserModel shared].user = model;
            [YQUserModel saveUserInfo];
            if (block) {
                block(code);
            }

        }
        
    }];
}



+ (void)getUserInfo:(stateBlock)block
{
    
    [self getUserInfoWithString:nil block:block];
}


+ (void)loginOut:(stateBlock)block
{
    NSString *url = @"/SC_Mobile_Service/logout";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:@"正在退出" andBlock:^(id obj, NSInteger code) {
        if (block) {
            block(code);
        }
    }];
}








+ (void)getServiceData:(NSString *)ID mainThird:(BOOL)mainThird
{
    if (ID.length == 0) {
        return;
    }
    NSString *url = @"api/en/v2/mine/serviceDetail";
    NSDictionary *dic = @{@"id":ID,@"is_ios_data":App_Ver};
    NSString *tips = mainThird ? @"正在设置" : nil;
    
    [YQNetwork requestMode:POST tailUrl:url params:dic backMainThread:YES showLoadString:tips andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            
            
            LH_AESModel *subModel = [VFAES aesDecrypt2:obj[@"data"]];
            if (subModel == nil) {
                [YQUtils showCenterMessage:@"请求失败"];
                return;
            }
            
            
            YQBaseModel *model = [YQBaseModel mj_objectWithKeyValues:subModel.obj];
            model.service_str = [model.service_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            model.service_str = [model.service_str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            
//            model.service_str = @"ssr://ZGUxdjMuZHNqc2FwaS5jb206NDQzOm9yaWdpbjpub25lOnBsYWluOlEyeE1jVXAwVTJoM1NFMXcvP29iZnNwYXJhbT0mcHJvdG9wYXJhbT0mcmVtYXJrcz1aR1V4ZGpNdVpITnFjMkZ3YVM1amIyMCZncm91cD0mb3RfZW5hYmxlPTEmb3RfZG9tYWluPVpHVXhkak11WkhOcWMyRndhUzVqYjIwJm90X3BhdGg9V1ZSb1JIVlZlbkIwUTBKNE9GVlNOMWR4ZGpr";
            
//            model.param_s = [VFAES aesDecrypt:model.service_str];
//            NSLog(@"pass = %@\n dic = %@", model.param_s, obj);
//            if (model.param_s == nil) {
//                [YQUtils showCenterMessage:@"该路线不支持"];
//                return;
//            }
//            
            
            [YQUserModel shared].chooseModel = model;
//            NSDictionary *saveDic = [model mj_JSONObject];
//            [YQCache saveCache:saveDic key:@"ChooseXianLu"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseXianLu" object:nil];
            
            
            if (mainThird) {
                [[YQUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
    
}


 + (void)upldateApp
 {
     if ([YQNetwork isNotReachable]) {
         return;
     }
     
     
     if ([QYSettingConfig shared].isUpdate) {
         return;
     }
     
     
     
     [QYSettingConfig shared].isReview = YES;
     NSString *url = @"api/en/mine/edition";
     [QYSettingConfig shared].isUpdate = YES;
     [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
         [QYSettingConfig shared].isUpdate = NO;
         if (code == 1) {
             NSDictionary *dic = obj[@"data"];
             if (dic == nil || dic == [NSNull null]) {
                 [QYSettingConfig shared].isReview = YES;
                 return;
             }
             
             NSInteger code = [dic[@"version_code"] integerValue];
             
             NSInteger force_update = [dic[@"force_update"] integerValue];
             
             NSInteger appcode = [[App_Ver stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
             
             if (appcode > code) {
                 [QYSettingConfig shared].isReview = YES;
             }
             
             
             else if (appcode == code) {
                 [QYSettingConfig shared].isReview = NO;
             }
             else{
                 [QYSettingConfig shared].isReview = NO;
                 NSString *info = dic[@"description"];
                 
                 NSString *url = dic[@"url"];
                 
                 [VFTipsView showView:@"新版本更新" content:info leftBtn:force_update == 0 ? @"取消" : nil rightBtn:@"更新" block:^(NSInteger code) {
                     if (code == 1) {
                         [YQUtils openUrl:url ?: WX_EvaluationAddress];
                     }
                 }];

             }
             

         }
     }];
 }
@end
