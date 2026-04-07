//
//  IAPManager.m
//  IAPDemo
//
//  Created by Charles.Yao on 2016/10/31.
//  Copyright © 2016年 com.pico. All rights reserved.
//

#import "IAPManager.h"
#import "SandBoxHelper.h"
#import "NSDate+category.h"
#if !TARGET_OS_MACCATALYST
#import <AdjustSdk/AdjustSdk.h>
#endif
//#import "WXYZ_TopAlertManager.h"

static NSString * const receiptKey = @"receipt_key";
static NSString * const dateKey = @"date_key";
static NSString * const userIdKey = @"userId_key";
static NSString * const appIdKey = @"appId_key";
static NSString * const amountKey = @"amount_key";
static NSString * const currencyKey = @"currency_key";
static NSString * const productTitleKey = @"productTitle_key";
static NSString * const transactionIdKey = @"transactionId_key";

// TODO: 替换为 Adjust 后台创建的“支付成功”事件 token（6 位）。
static NSString * const kAdjustPaymentSuccessEventToken = @"4kmw8a";

dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.apple.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return as_iap_queue;
}

@interface IAPManager ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, assign) BOOL goodsRequestFinished; //判断一次请求是否完成

@property (nonatomic, copy) NSString *receipt; //交易成功后拿到的一个64编码字符串

@property (nonatomic, copy) NSString *date; //交易时间

@property (nonatomic, copy) NSString *productID; //交易时间

@property (nonatomic, copy) NSString *userId; //交易人

@property (nonatomic, copy) NSString *productTitle; //商品标题

@property (nonatomic, copy) NSString *currencyCode; //币种

@property (nonatomic, copy) NSString *amount; //金额

@property (nonatomic, copy) NSString *transactionId; //交易ID

//@property (nonatomic, strong) NSString *couponsId;


@end

@implementation IAPManager

static IAPManager *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (IAPManager *)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/***
 内购支付两个阶段：
 1.app直接向苹果服务器请求商品，支付阶段；
 2.苹果服务器返回凭证，app向公司服务器发送验证，公司再向苹果服务器验证阶段；
 */

/**
 阶段一正在进中,app退出。
 在程序启动时，设置监听，监听是否有未完成订单，有的话恢复订单。
 */

//开启监听
- (void)startManager
{

    dispatch_async(iap_queue(), ^{
       
        self.goodsRequestFinished = YES;
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        [self requestSuccess];
        [self checkIAPFiles];
    });
}

- (void)stopManager
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    });
}

#pragma mark - 开始请求苹果商品
- (void)requestProductWithId:(NSString *)productId
{
    
//    productId = @"200002";
    if (productId.length == 0) {
        return;
    }
    
    if (self.goodsRequestFinished) {
        
        [YQNetwork showProgressView:@"正在连接App Store"];
        if ([SKPaymentQueue canMakePayments]) { //用户允许app内购
            
            if (productId.length) {
                self.productID = productId;
                self.goodsRequestFinished = NO;
                
                if (TEST_ING) {
                    NSMutableDictionary *testPayInfo = [NSMutableDictionary dictionary];
                    NSString *userId = [YQUserModel shared].user.ID ?: @"";
                    NSString *date = [NSDate chindDateFormate:[NSDate date]] ?: @"";
                    if (productId.length) {
                        testPayInfo[appIdKey] = productId;
                    }
                    if (userId.length) {
                        testPayInfo[userIdKey] = userId;
                    }
                    if (date.length) {
                        testPayInfo[dateKey] = date;
                    }
                    testPayInfo[amountKey] = @"10";
                    testPayInfo[currencyKey] = @"CNY";
                    [self trackAdjustPaymentSuccessWithInfo:testPayInfo];
                }
               
                NSArray *product = [[NSArray alloc] initWithObjects:productId, nil];
                NSSet *set = [NSSet setWithArray:product];
                SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
                productRequest.delegate = self;
                [productRequest start];
            
            } else {
                [self filedWithErrorCode:IAP_FILEDCOED_EMPTYGOODS error:nil];
                self.goodsRequestFinished = YES; // 商品信息错误
            }
        
        } else { //用户未允许app内购
            [self filedWithErrorCode:IAP_FILEDCOED_NORIGHT error:nil];
            self.goodsRequestFinished = YES; //
        }
    
    } else { // 正在进行其他交易
        
        [YQUtils showCenterMessage:@"交易中, 请稍后"];
    }
    
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    if (product.count == 0) {
        
        [self filedWithErrorCode:IAP_FILEDCOED_CANNOTGETINFORMATION error:nil];
        self.goodsRequestFinished = YES; //失败，请求完成

    } else {
        //发起购买请求
        SKProduct *selectProduct = product.firstObject;
        self.productID = selectProduct.productIdentifier ?: self.productID;
        self.productTitle = selectProduct.localizedTitle ?: @"";
        self.amount = selectProduct.price.stringValue ?: @"";
        self.currencyCode = [selectProduct.priceLocale objectForKey:NSLocaleCurrencyCode] ?: @"";
        
        SKPayment *payment = [SKPayment paymentWithProduct:selectProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.goodsRequestFinished = YES; //成功，请求完成
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [self filedWithErrorCode:IAP_FILEDCOED_APPLECODE error:[error localizedDescription]];
    self.goodsRequestFinished = YES; //失败，请求完成
}

#pragma mark - 购买操作后的回调
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
       
        switch (transaction.transactionState) {
                
                // 正在交易
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品正在请求中");
                [YQNetwork hiddenProgress];
                [YQNetwork showProgressView:@"商品正在请求中"];
                break;
                
                // 交易完成
            case SKPaymentTransactionStatePurchased: {
                self.transactionId = transaction.transactionIdentifier ?: @"";
                self.productID = transaction.payment.productIdentifier ?: self.productID;
                [self getReceipt];      // 获取交易成功后的购买凭证
                [self saveReceipt];     // 存储交易凭证
                [self checkIAPFiles];   // 发送凭证服务器验证是否有效
                [self completeTransaction:transaction];
            }
                break;

                // 交易失败
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                [self restoreTransaction:transaction];
                break;

                // 已经购买过该商品
            case SKPaymentTransactionStateRestored:
                
                [self restoreTransaction:transaction];
                
                break;
           
            default:
               
                break;
        }
    }
}

// 获取交易成功后的购买凭证
- (void)getReceipt
{
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    self.receipt = [receiptData base64EncodedStringWithOptions:0];
}



- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled) {
        // 交易失败
        dispatch_async(dispatch_get_main_queue(), ^{
            [self filedWithErrorCode:IAP_FILEDCOED_BUYFILED error:nil];
        });
        
    } else {
        // 取消交易
        [self filedWithErrorCode:IAP_FILEDCOED_USERCANCEL error:nil];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.goodsRequestFinished = YES; //失败，请求完成
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    self.goodsRequestFinished = YES; //恢复购买，请求完成
}

#pragma mark 将购买凭证存储到本地，验证凭证失败时，App再次启动后会重新验证购买凭证
- (void)saveReceipt
{
    self.date = [NSDate chindDateFormate:[NSDate date]];
    NSString *fileName = @"savePayData";
    self.userId = [YQUserModel shared].user.ID;
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", [SandBoxHelper iapReceiptPath], fileName];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.receipt.length) {
        dic[receiptKey] = self.receipt;
    }
    if (self.date.length) {
        dic[dateKey] = self.date;
    }
    if (self.userId.length) {
        dic[userIdKey] = self.userId;
    }
    if (self.productID.length) {
        dic[appIdKey] = self.productID;
    }
    if (self.amount.length) {
        dic[amountKey] = self.amount;
    }
    if (self.currencyCode.length) {
        dic[currencyKey] = self.currencyCode;
    }
    if (self.productTitle.length) {
        dic[productTitleKey] = self.productTitle;
    }
    if (self.transactionId.length) {
        dic[transactionIdKey] = self.transactionId;
    }
    [dic writeToFile:savedPath atomically:YES];
}

- (void)checkIAPFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
   
    // 搜索该目录下的所有文件和目录
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:[SandBoxHelper iapReceiptPath] error:&error];
    if (error == nil) {
        for (NSString *name in cacheFileNameArray) {
            if ([name hasSuffix:@".plist"]){
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [SandBoxHelper iapReceiptPath], name];
                [self sendAppStoreRequestBuyPlist:filePath];
            }
        }
    } else {
        // 获取本地存储的购买凭证失败
        [self.delegate filedWithErrorCode:IAP_FILEDCOED_APPLECODE andError:error.description];
    }
}

// 验证支付凭证
- (void)sendAppStoreRequestBuyPlist:(NSString *)plistPath
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    //这里的参数请根据自己公司后台服务器接口定制，但是必须发送的是持久化保存购买凭证
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [dic objectForKey:receiptKey],          receiptKey,
                                   [dic objectForKey:dateKey],             dateKey,
                                   [dic objectForKey:userIdKey],           userIdKey,
                                   [dic objectForKey:appIdKey],           appIdKey,
                                   nil];
    if ([dic objectForKey:amountKey]) {
        params[amountKey] = [dic objectForKey:amountKey];
    }
    if ([dic objectForKey:currencyKey]) {
        params[currencyKey] = [dic objectForKey:currencyKey];
    }
    if ([dic objectForKey:productTitleKey]) {
        params[productTitleKey] = [dic objectForKey:productTitleKey];
    }
    if ([dic objectForKey:transactionIdKey]) {
        params[transactionIdKey] = [dic objectForKey:transactionIdKey];
    }
    
//    if (![[params objectForKey:userIdKey] isEqualToString:[YQUserModel shared].user.ID]) {
//        return;
//    }
//
    // 发送购买凭证至服务器
//    [self requestSuccess];
//    return;
    if ([params objectForKey:receiptKey]) {
//        self.couponsId = [params objectForKey:@"couponsId"];
        [self applePayBackRequest:[params objectForKey:receiptKey] payInfo:params];
    } else {
        [self.delegate filedWithErrorCode:IAP_FILEDCOED_APPLECODE andError:@"支付凭证验证失败!"];
    }
    
}

// 验证成功，移除本地记录的购买凭证
- (void)removeReceipt
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[SandBoxHelper iapReceiptPath]]) {
        [fileManager removeItemAtPath:[SandBoxHelper iapReceiptPath] error:nil];
    }
}

#pragma mark - 苹果凭证验证
- (void)applePayBackRequest:(NSString *)receipt payInfo:(NSDictionary *)payInfo
{
    
    if ([YQUserModel shared].user.isLogin == NO) {
        return;
    }
    
    NSString *url = @"api/en/pay/actionsApplepay";
    
    NSDictionary *dic = @{@"receipt_data": receipt,
                          @"user_id":[YQUserModel shared].user.ID,
                          @"apple_id":[payInfo objectForKey:appIdKey] ?: @"",
                          @"is_test":TEST_ING ? @"1" :@"2"
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在请求" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [self trackAdjustPaymentSuccessWithInfo:payInfo];
            [[YQUtils getCurrentVC].navigationController popViewControllerAnimated:YES];
            [YQUtils showCenterMessage:@"购买成功"];
            [self requestSuccess];
        }
    }];
    


}

- (void)trackAdjustPaymentSuccessWithInfo:(NSDictionary *)payInfo
{
    
#if !TARGET_OS_MACCATALYST

    if (kAdjustPaymentSuccessEventToken.length != 6) {
        NSLog(@"Adjust payment success event token is not configured.");
        return;
    }
    
    ADJEvent *event = [[ADJEvent alloc] initWithEventToken:kAdjustPaymentSuccessEventToken];
    if (!event || !event.isValid) {
        NSLog(@"Adjust payment success event is invalid.");
        return;
    }
    
    NSString *amount = [payInfo objectForKey:amountKey];
    NSString *currency = [payInfo objectForKey:currencyKey];
    if (amount.length && currency.length) {
        [event setRevenue:amount.doubleValue currency:currency];
        [event addCallbackParameter:@"amount" value:amount];
        [event addCallbackParameter:@"currency" value:currency];
    }
    
    NSString *transactionId = [payInfo objectForKey:transactionIdKey];
    if (transactionId.length) {
        [event setTransactionId:transactionId];
        [event setDeduplicationId:transactionId];
        [event setCallbackId:transactionId];
        [event addCallbackParameter:@"transaction_id" value:transactionId];
    }
    
    NSString *productId = [payInfo objectForKey:appIdKey];
    if (productId.length) {
        [event setProductId:productId];
        [event addCallbackParameter:@"apple_id" value:productId];
    }
    
    NSString *userId = [payInfo objectForKey:userIdKey] ?: [YQUserModel shared].user.ID;
    if (userId.length) {
        [event addCallbackParameter:@"user_id" value:userId];
    }
    
    NSString *productTitle = [payInfo objectForKey:productTitleKey];
    if (productTitle.length) {
        [event addCallbackParameter:@"product_title" value:productTitle];
    }
    
    NSString *payDate = [payInfo objectForKey:dateKey];
    if (payDate.length) {
        [event addCallbackParameter:@"pay_time" value:payDate];
    }
    
    [Adjust trackEvent:event];
    
#endif
}

#pragma mark 错误信息反馈

- (void)requestSuccess
{
    [self removeReceipt];
    
//    [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeSuccess alertTitle:@"支付成功"];
//
    // 发送全局购买成功通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Recharge_Success object:nil];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSuccess)]) {
        [self.delegate requestSuccess];
    }
}

- (void)filedWithErrorCode:(NSInteger)code error:(NSString *)error
{
    [YQNetwork hiddenProgress];
    switch (code) {
        case IAP_FILEDCOED_APPLECODE:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:error];
            [YQUtils showCenterMessage:error];
            break;
            
        case IAP_FILEDCOED_NORIGHT:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"请您开启内购支付"];
            [YQUtils showCenterMessage:@"请您开启内购支付"];
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"商品获取出错"];
            [YQUtils showCenterMessage:@"商品获取出错"];
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"商品获取出错"];
            [YQUtils showCenterMessage:@"商品获取出错"];
            break;
            
            
        case IAP_FILEDCOED_USERCANCEL:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"您已取消交易"];
            [YQUtils showCenterMessage:@"您已取消交易"];
            break;
            
        case IAP_FILEDCOED_BUYING:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"交易正在进行"];
            [YQUtils showCenterMessage:@"交易正在进行"];
            break;
        case IAP_FILEDCOED_NOTLOGGEDIN:
            break;
            
        default:
//            [WXYZ_TopAlertManager showAlertWithType:WXYZ_TopAlertTypeError alertTitle:@"支付失败，请稍后重试"];
            [YQUtils showCenterMessage:@"支付失败，请稍后重试"];
            break;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(filedWithErrorCode:andError:)]) {
        [self.delegate filedWithErrorCode:code andError:error];
    }
}

@end
