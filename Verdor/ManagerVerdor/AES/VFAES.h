

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface LH_AESModel : NSObject
@property (nonatomic, assign) NSInteger now_time;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *svr_info_encrypt;
@property (nonatomic, strong) id obj;
@end


@interface VFAES : NSObject
+ (NSDictionary *)aesDecrypt:(NSString *)secretStr;


+ (LH_AESModel *)aesDecrypt2:(NSDictionary *)dicData;

+ (NSString *)aes_256_cbc_encode:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
