////
////   CCPayManager.m
//
//
#import "CCPayManager.h"
//
//@interface CCPayManager()<WXApiDelegate>
//@property (nonatomic, copy) WXStateBlock stateBlock;
//@property (nonatomic, strong) WXBuyModel *model;
//
//@end
//
//
@implementation CCPayManager
//
//
//+ (CCPayManager *)shareInstance {
//    static CCPayManager *weChatPayInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        weChatPayInstance = [[CCPayManager alloc] init];
//    });
//    return weChatPayInstance;
//}
//
////+ (BOOL)handleOpenUniversalLink:(NSUserActivity *)userActivity
////{
////    return [WXApi handleOpenUniversalLink:userActivity delegate:[CCPayManager shareInstance]];
////}
////
////+ (BOOL)handleOpenUrl:(NSURL *)url {
////    return [WXApi handleOpenURL:url delegate:[CCPayManager shareInstance]];
////}
//
/////微信支付
////+ (void)payWeiXin:(WXBuyModel *)model block:(WXStateBlock)block
////{
////    PayReq *req = [[PayReq alloc] init];
////    req.openID = model.appid;
////    req.partnerId = model.partnerid;
////    req.prepayId = model.prepayid;
////    req.nonceStr = model.noncestr;
////    req.package = model.package1;
////    req.sign = model.paySign;
////    req.timeStamp = [model.timestamp intValue];
////    [WXApi sendReq:req completion:^(BOOL success) {
////        if (success) {
////            [CCPayManager shareInstance].payState = 1;
////        }
////    }];
////    [CCPayManager shareInstance].stateBlock = block;
////    [CCPayManager shareInstance].model = model;
////
////}
//
//
//
//+ (void)loginWXWithBlock:(WXStateBlock)block
//{
//    SendAuthReq *req = [[SendAuthReq alloc] init];
//    req.scope = @"snsapi_userinfo";
//    req.state = @"wx_oauth_authorization_state";
//    [WXApi sendAuthReq:req viewController:[YQUtils getCurrentVC] delegate:nil completion:^(BOOL success) {
//
//    }];
//    [CCPayManager shareInstance].stateBlock = block;
//}
//
//- (void)onResp:(BaseResp *)resp {
//
//
//
//    if ([resp isKindOfClass: [SendAuthResp class]]) {
//        SendAuthResp* authResp = (SendAuthResp*)resp;
//
//        if (authResp.errCode == 0) {
//            if (self.stateBlock) {
//                self.stateBlock(1, authResp.code);
//            }
//        } else {
//            if (self.stateBlock) {
//                self.stateBlock(-1, @"取消登录");
//            }
//        }
//        return;
//    }
//
//
//
//    if ([resp isKindOfClass:[PayResp class]]) {
//        /*
//         enum  WXErrCode {
//         WXSuccess           = 0,    < 成功
//         WXErrCodeCommon     = -1,  < 普通错误类型
//         WXErrCodeUserCancel = -2,   < 用户点击取消并返回
//         WXErrCodeSentFail   = -3,   < 发送失败
//         WXErrCodeAuthDeny   = -4,   < 授权失败
//         WXErrCodeUnsupport  = -5,   < 微信不支持
//         };
//         */
//
//
//
//
//
//        PayResp *response = (PayResp*)resp;
//        switch (response.errCode) {
//            case WXSuccess: {
//                [YQUtils showCenterMessage:@"支付成功"];
////                [self finishOrder];
//
//            break;
//            }
//            case WXErrCodeCommon: {
//                [YQUtils showCenterMessage:@"支付异常"];
//                break;
//            }
//            case WXErrCodeUserCancel: {
//                [YQUtils showCenterMessage:@"取消支付"];
//                break;
//            }
//            case WXErrCodeSentFail: {
//                NSLog(@"微信回调发送支付信息失败");
//                [YQUtils showCenterMessage:@"发送支付信息失败"];
//                break;
//            }
//            case WXErrCodeAuthDeny: {
//                NSLog(@"微信回调授权失败");
//                [YQUtils showCenterMessage:@"授权失败"];
//                break;
//            }
//            case WXErrCodeUnsupport: {
//                [YQUtils showCenterMessage:@"微信版本暂不支持"];
//                break;
//            }
//            default: {
//                break;
//            }
//        }
//
//
//
//    }
//}
//
//
//- (void)sureOrderState
//{
//
//    if (![self.model.outTradeNo length] || self.payState == 2) {
//        return;
//    }
//    self.payState = 2;
//    NSString *url = [NSString stringWithFormat:@"/find-order-result/%@",self.model.outTradeNo];
//    [YQNetwork requestMode:GET tailUrl:url params:nil showLoadString:@"正在确定订单状态" andBlock:^(id obj, NSInteger code) {
//        if (code == 1 && [obj[@"data"] isEqualToString:@"SUCCESS"]) {
//            if (self.stateBlock) {
//                self.stateBlock(code, self.model.outTradeNo);
//            }
////            [self finishOrder];
//        }
//
//    }];
//}
//
//- (void)finishOrder
//{
//
//    if (self.payState == 3) {
//        return;
//    }
//    self.payState = 3;
//
//
//    NSString *url = @"/complete-payment-sub-order";
//    NSDictionary *dic = @{@"amount":@(self.model.amount),
//                          @"outTradeNo":self.model.outTradeNo,
//                          @"travelId":self.model.travelId
//    };
//    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:nil andBlock:^(id obj, NSInteger code) {
//        if (code == 1) {
//            self.payState = 0;
//        }
//    }];
//}
//
//
@end
