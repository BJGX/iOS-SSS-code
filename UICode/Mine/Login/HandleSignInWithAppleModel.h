//
//  HandleSignInWithAppleModel.h
//  SignInWithApple
//
//  Created by TaoJiang on 2019/10/18.
//  Copyright © 2019 Nicolas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface HandleSignInWithAppleModel : NSObject

+ (HandleSignInWithAppleModel *)defaultSignInWithAppleModel;

+ (void)attempDealloc;

+ (void)signInWithAppleWithButtonRect:(CGRect)rect
                          withSupView:(UIView *)superView
                              success:(void(^)(ASAuthorization *authorization))success
                              failure:(void (^)(NSError *err))failure API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
