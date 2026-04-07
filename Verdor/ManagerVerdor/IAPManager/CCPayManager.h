//
//   CCPayManager.h
   

#import <Foundation/Foundation.h>
//#import <WXApi.h>
#import "WXBuyModel.h"

typedef void(^WXStateBlock)(NSInteger state, NSString * _Nonnull codeString);

NS_ASSUME_NONNULL_BEGIN

@interface CCPayManager : NSObject
//+ (CCPayManager *)shareInstance;
//
///// 1 支付中 2 校验中  0 支付完成
//@property (nonatomic, assign) NSInteger payState;
//
//+ (BOOL)handleOpenUrl:(NSURL *)url;
//
//+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity;
//
//
//+ (void)payWeiXin:(WXBuyModel *)model block:(WXStateBlock)block;
//
//+ (void)loginWXWithBlock:(WXStateBlock)block;
//
//- (void)sureOrderState;

@end

NS_ASSUME_NONNULL_END
