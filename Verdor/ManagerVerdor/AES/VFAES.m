

#import "VFAES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


const NSString *AESKey = @"HqY6yU8f4nO8AeBkq1fcrSOlZmg9h49X";
const NSString *IVString = @"K9bvEyQzBQt3gCPT";
const NSString *md5Str = @"RAqI9YtmUY1d1V7JJ4fVZB4cvdEiUsBI";


@implementation LH_AESModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"svr_info_encrypt":@[@"svr_info_encrypt",@"encrypted_string"],
             @"sign":@[@"sign",@"signature"],
             @"cur_sec":@[@"cur_sec",@"now_time"]};
}

@end

@implementation VFAES



+ (LH_AESModel *)aesDecrypt2:(NSDictionary *)dicData{
    LH_AESModel *model = [LH_AESModel mj_objectWithKeyValues:dicData];
    if (model.svr_info_encrypt.length == 0) {
        return nil;
    }

    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:model.svr_info_encrypt options:NSDataBase64DecodingIgnoreUnknownCharacters];

    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [AESKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [IVString getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [decodeData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [decodeData bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *md5 = [result stringByAppendingFormat:@"%@",md5Str];
        
        NSString *sign = [VFAES stringToMD5:md5];
        
        if (![sign isEqualToString:model.sign]) {
//            [FCUtils showCenterMessage:@""]
            return nil;
        }
        
        NSDictionary *dic = [data mj_JSONObject];
        model.obj = dic;
        if ([model.obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *subDic = model.obj;
            if (subDic[@"cur_sec"] != nil) {
                model.now_time = [subDic[@"cur_sec"] integerValue];
            }
        }

        
        NSInteger current = [YQUtils currentTimeStamp] / 1000;
        NSInteger cha = labs(current - model.now_time);
        if (cha >120)
        {
            return nil;
        }
        
//        NSDictionary *dic = [self returnModelWith:result];
        return model;
    } else {
        free(buffer);
        return nil;
    }

}


+ (NSString *)stringToMD5:(NSString *)inputStr
{
    const char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];
}


+ (NSDictionary *)returnModelWith:(NSString *)result
{
    
    if ([result containsString:@"ssr://"]) {
        //ssrr.chilines.me:443:auth_aes128_md5:chacha20-ietf-poly1305:tls1.2_ticket_auth:WnBRYUdiM3RyUEhyY050Zw/?obfsparam=&protoparam=&remarks=dGVzdA&group=&ot_enable=1&ot_domain=c3Nyci5jaGlsaW5lcy5tZQ&ot_path=LzVtaGs4TFBPelh2amxBdXQv
        NSString*string = [result stringByReplacingOccurrencesOfString:@"ssr://" withString:@""];
        NSString *ssrString = [self decodeBase64:string];
        NSArray *array = [ssrString componentsSeparatedByString:@"?"];
        if (array.count != 2) {
            return nil;
        }
        
        
 
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *paramArray = [array[0] componentsSeparatedByString:@":"];
        
        dic[@"host"] = paramArray.firstObject;
        dic[@"port"] = paramArray[1];
        dic[@"protocol"] = paramArray[2];
        dic[@"authscheme"] = paramArray[3];
        dic[@"obfs"] = paramArray[4];
        dic[@"password"] = [self decodeBase64:[paramArray.lastObject stringByReplacingOccurrencesOfString:@"/" withString:@""]];
        
        NSArray *subArray = [array[1] componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
        for (NSString *obj in subArray) {
            NSArray *p = [obj componentsSeparatedByString:@"="];
            subDic[p.firstObject] = [self decodeBase64:p.lastObject];
        }
        

        
        
        dic[@"ot_enable"] = @(1);
        dic[@"ota"] = @(0);
        dic[@"obfs_param"] = subDic[@"obfsparam"];
        dic[@"protocol_param"] = subDic[@"protoparam"];
        dic[@"ot_domain"] = subDic[@"ot_domain"];
        dic[@"ot_path"] = subDic[@"ot_path"];
        
        return dic;
        
    }
    
    if ([result containsString:@"ss://"]) {
        //ssrr.chilines.me:443:auth_aes128_md5:chacha20-ietf-poly1305:tls1.2_ticket_auth:WnBRYUdiM3RyUEhyY050Zw/?obfsparam=&protoparam=&remarks=dGVzdA&group=&ot_enable=1&ot_domain=c3Nyci5jaGlsaW5lcy5tZQ&ot_path=LzVtaGs4TFBPelh2amxBdXQv
        NSString*string = [result stringByReplacingOccurrencesOfString:@"ss://" withString:@""];
        NSString *ssrString = [self decodeBase64:string];
        NSArray *array = [ssrString componentsSeparatedByString:@"?"];
        if (array.count != 2) {
            return nil;
        }
        
        
 
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSArray *paramArray = [array[0] componentsSeparatedByString:@":"];
        
        dic[@"host"] = paramArray.firstObject;
        dic[@"port"] = paramArray[1];
        dic[@"protocol"] = paramArray[2];
        dic[@"authscheme"] = paramArray[3];
        dic[@"obfs"] = paramArray[4];
        dic[@"password"] = [self decodeBase64:[paramArray.lastObject stringByReplacingOccurrencesOfString:@"/" withString:@""]];
        
        NSArray *subArray = [array[1] componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
        for (NSString *obj in subArray) {
            NSArray *p = [obj componentsSeparatedByString:@"="];
            subDic[p.firstObject] = [self decodeBase64:p.lastObject];
        }
        

        
        
        dic[@"ot_enable"] = @(0);
        dic[@"ota"] = @(0);
        dic[@"obfs_param"] = subDic[@"obfsparam"] ?: @"";
        dic[@"protocol_param"] = subDic[@"protoparam"] ?: @"";
        dic[@"ot_domain"] = subDic[@"ot_domain"] ?: @"";
        dic[@"ot_path"] = subDic[@"ot_path"] ?: @"";
        
        return dic;
        
    }
    return  nil;

}



+ (NSDictionary *)aesDecrypt:(NSString *)secretStr{
    if (!secretStr) {
        return nil;
    }
    
    return [self returnModelWith:secretStr];

    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:secretStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [AESKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSString *iv = @"1238389483762837";
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [decodeData length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          [decodeData bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [self returnModelWith:result];
        return dic;
    } else {
        free(buffer);
        return nil;
    }

}



+ (NSString *)decodeBase64:(NSString *)string
{
    string = [[string stringByReplacingOccurrencesOfString:@"-" withString:@"+"] stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSInteger padding = string.length + (string.length % 4 != 0 ? (4 - string.length % 4) : 0);
    string = [string stringByPaddingToLength:padding withString:@"=" startingAtIndex:0];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}




@end
