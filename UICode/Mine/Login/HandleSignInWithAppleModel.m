//
//  HandleSignInWithAppleModel.m
//  SignInWithApple
//
//  Created by TaoJiang on 2019/10/18.
//  Copyright © 2019 Nicolas. All rights reserved.
//

#import "HandleSignInWithAppleModel.h"

static HandleSignInWithAppleModel  *_instance;
static dispatch_once_t onceToken;

API_AVAILABLE(ios(13.0))
typedef void(^Success)(ASAuthorization *authorization);
typedef void (^Failure)(NSError *err);

API_AVAILABLE(ios(13.0))
@interface HandleSignInWithAppleModel()<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property(nonatomic,strong) Success success;
@property(nonatomic,strong) Failure failure;
@end

@implementation HandleSignInWithAppleModel

+ (HandleSignInWithAppleModel *)defaultSignInWithAppleModel{
    dispatch_once(&onceToken, ^{
        _instance = [[HandleSignInWithAppleModel alloc]init];
    });
    return _instance;
}
//销毁
+ (void)attempDealloc{
    onceToken = 0;
    _instance = nil;
}

+ (void)signInWithAppleWithButtonRect:(CGRect)rect
                          withSupView:(UIView *)superView  success:(void(^)(ASAuthorization *authorization))success
                              failure:(void (^)(NSError *err))failure  API_AVAILABLE(ios(13.0)){
    if (@available(iOS 13.0, *)) {
        HandleSignInWithAppleModel *hsiam = [HandleSignInWithAppleModel defaultSignInWithAppleModel];
        hsiam.success = success;
        hsiam.failure = failure;
        
        ///苹果ID按钮
        ASAuthorizationAppleIDButton *appleIDBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeDefault style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDBtn.frame = rect;
        appleIDBtn.cornerRadius = 8.0f;
        [appleIDBtn addTarget:hsiam action:@selector(handleAuthorizationAppleIDButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:appleIDBtn];
//        [appleIDBtn addDarkGlassView:20 blurDensity:0.1 distance:0];
    }
}
// 处理授权
- (void)handleAuthorizationAppleIDButtonPress{
    if (@available(iOS 13.0, *)) {
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
        // 在用户授权期间请求的联系信息
        appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark - delegate
//@optional 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        
        self.success(authorization);
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {

        self.success(authorization);
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"授权信息均不符"};
        NSError* error = [[NSError alloc]  initWithDomain:@"error" code:105 userInfo:userInfo];
        self.failure(error);
    }
}

// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    // Handle error.
    NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
        default:
            break;
    }
    [YQUtils showCenterMessage:errorMsg];
    self.failure(error);
}

// 告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    // 返回window
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
       if (windowScene.activationState == UISceneActivationStateForegroundActive) {
          UIWindow *window = windowScene.windows.firstObject;
          return window;
       }
    }
    return nil;
//    abort();
}
@end
