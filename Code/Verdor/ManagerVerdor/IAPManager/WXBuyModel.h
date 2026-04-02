//
//   WXBuyModel.h
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXBuyModel : NSObject

@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *package1;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *paySign;
@property (nonatomic, strong) NSString *outTradeNo;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, strong) NSString *travelId;
@end

NS_ASSUME_NONNULL_END
