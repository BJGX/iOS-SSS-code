#import "SimpleLogger.h"
//#import <AFNetworking/AFNetworking.h>
#import <CommUtils/CommUtils.h>

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
//#import <AppKit/AppKit.h>
#if TARGET_OS_MACCATALYST || TARGET_OS_OSX
#import <AppKit/AppKit.h> // 用于 macOS Catalyst 和原生 macOS
#else
#import <UIKit/UIKit.h>   // 用于 iOS
#endif


static const CCAlgorithm kAlgorithm = kCCAlgorithmAES;
static const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
static const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
static const NSUInteger kPBKDF2Rounds = 10000; // 迭代次数，增加破解难度

@interface SimpleLogger ()
@property (nonatomic, strong) dispatch_queue_t logQueue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *logDirectory;
@end

@implementation SimpleLogger

+ (instancetype)sharedLogger {
    static SimpleLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 创建串行队列保证线程安全
        _logQueue = dispatch_queue_create("com.yourcompany.logger", DISPATCH_QUEUE_SERIAL);
        
        // 默认日志目录: ~/Documents/AppLogs
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _logDirectory = [AppProfile sharedLogUrl].path;
        
        // 日期格式化器
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        // 确保日志目录存在
        [self createLogDirectoryIfNeeded];
    }
    return self;
}

- (void)configureLogDirectory:(NSString *)directory {
    _logDirectory = [directory copy];
    [self createLogDirectoryIfNeeded];
}

- (void)createLogDirectoryIfNeeded {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    if (![fm fileExistsAtPath:_logDirectory isDirectory:&isDir]) {
        NSError *error;
        [fm createDirectoryAtPath:_logDirectory
      withIntermediateDirectories:YES
                       attributes:nil
                            error:&error];
        
        if (error) {
            NSLog(@"Failed to create log directory: %@", error);
        }
    }
}

- (NSString *)currentLogFilePath {
    // 每天创建新日志文件: Log_2023-07-28.txt
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    
    return [_logDirectory stringByAppendingPathComponent:
            [NSString stringWithFormat:@"Log_%@.txt", dateStr]];
}

- (NSString *)logLevelString:(LogLevel)level {
    switch (level) {
        case LogLevelDebug: return @"DEBUG";
        case LogLevelInfo: return @"INFO";
        case LogLevelWarning: return @"WARNING";
        case LogLevelError: return @"ERROR";
        default: return @"UNKNOWN";
    }
}


//- (NSString *)NetString:(AFNetworkReachabilityStatus)level {
//    switch (level) {
//        case AFNetworkReachabilityStatusUnknown: return @"Unknown";
//        case AFNetworkReachabilityStatusNotReachable: return @"NotReachable";
//        case AFNetworkReachabilityStatusReachableViaWWAN: return @"WWAN";
//        case AFNetworkReachabilityStatusReachableViaWiFi: return @"WIFI";
//        default: return @"UNKNOWN";
//    }
//}



- (void)logWithLevel:(LogLevel)level
            category:(NSString *)category
             message:(NSString *)message {
    
    dispatch_async(_logQueue, ^{
        // 1. 准备日志内容
//        AFNetworkReachabilityStatus i = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
        NSString *timestamp = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString *levelStr = [self logLevelString:level];
        NSData *salt = [SimpleLogger generateSaltWithLength:16]; // 生成16字节的盐
//        NSString *netString = [SimpleLogger encryptAES:message password:@"1234567890!@#$" salt:salt];
        NSString *logEntry = [NSString stringWithFormat:@"\n[%@] [%@] [%@]\n%@",
                              timestamp, levelStr, category, message];
        
        // 2. 获取文件路径
        NSString *filePath = [self currentLogFilePath];
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // 3. 写入文件
        if (![fm fileExistsAtPath:filePath]) {
            [fm createFileAtPath:filePath contents:nil attributes:nil];
        }
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        if (fileHandle) {
            @try {
                [fileHandle seekToEndOfFile];
                [fileHandle writeData:[logEntry dataUsingEncoding:NSUTF8StringEncoding]];
            } @catch (NSException *exception) {
                NSLog(@"Log write failed: %@", exception);
            } @finally {
                [fileHandle closeFile];
            }
        }
    });
}

- (void)clearLogs {
    dispatch_async(_logQueue, ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error;
        
        // 删除整个日志目录
        if ([fm fileExistsAtPath:self.logDirectory]) {
            [fm removeItemAtPath:self.logDirectory error:&error];
        }
        
        // 重新创建目录
        [self createLogDirectoryIfNeeded];
        
        if (error) {
            NSLog(@"Failed to clear logs: %@", error);
        }
    });
}

- (NSURL *)openLogsFolder {
    [self createLogDirectoryIfNeeded];
    

    // 获取日志目录的 URL
    
    NSString *path = [self currentLogFilePath];
    
    NSURL *folderURL = [NSURL fileURLWithPath:path isDirectory:NO];

    
    return folderURL;
    // 使用 NSWorkspace 打开文件夹
//    [[NSWorkspace sharedWorkspace] openURL:folderURL];
}


+ (NSString *)encryptAES:(NSString *)plainText password:(NSString *)password salt:(NSData *)salt {
    if (!plainText.length || !password.length || !salt.length) return nil;
    
    // 1. 使用PBKDF2从密码和盐派生密钥[citation:3]
    NSData *keyData = [self _derivedKeyFromPassword:password salt:salt keySize:kAlgorithmKeySize];
    if (!keyData) return nil;
    
    // 2. 准备明文数据
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    // 3. 生成随机的初始化向量(IV)，CBC模式必须使用
    NSMutableData *ivData = [NSMutableData dataWithLength:kAlgorithmBlockSize];
    int result = SecRandomCopyBytes(kSecRandomDefault, kAlgorithmBlockSize, ivData.mutableBytes);
    if (result != errSecSuccess) return nil;
    
    // 4. 执行AES加密
    NSData *cipherData = [self _doCipher:plainData
                                     key:keyData
                                      iv:ivData
                                operation:kCCEncrypt];
    if (!cipherData) return nil;
    
    // 5. 将IV前置到密文，便于存储和传输
    NSMutableData *completeData = [NSMutableData dataWithData:ivData];
    [completeData appendData:cipherData];
    
    // 6. 返回Base64字符串
    return [completeData base64EncodedStringWithOptions:0];
}


+ (NSString *)decryptAES:(NSString *)cipherText password:(NSString *)password salt:(NSData *)salt {
    if (!cipherText.length || !password.length || !salt.length) return nil;
    
    // 1. 解码Base64，还原完整数据（IV+密文）
    NSData *completeData = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    if (completeData.length < kAlgorithmBlockSize) return nil;
    
    // 2. 分离出IV和密文
    NSData *ivData = [completeData subdataWithRange:NSMakeRange(0, kAlgorithmBlockSize)];
    NSData *cipherData = [completeData subdataWithRange:NSMakeRange(kAlgorithmBlockSize, completeData.length - kAlgorithmBlockSize)];
    
    // 3. 使用相同的PBKDF2过程派生密钥[citation:3]
    NSData *keyData = [self _derivedKeyFromPassword:password salt:salt keySize:kAlgorithmKeySize];
    if (!keyData) return nil;
    
    // 4. 执行AES解密
    NSData *plainData = [self _doCipher:cipherData
                                    key:keyData
                                     iv:ivData
                               operation:kCCDecrypt];
    if (!plainData) return nil;
    
    // 5. 将数据转为字符串
    return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
}

+ (NSData *)generateSaltWithLength:(NSUInteger)length {
    NSMutableData *salt = [NSMutableData dataWithLength:length];
    int result = SecRandomCopyBytes(kSecRandomDefault, length, salt.mutableBytes);
    return (result == errSecSuccess) ? [salt copy] : nil;
}

#pragma mark - 私有辅助方法

// 使用PBKDF2从密码和盐派生密钥[citation:3]
+ (NSData *)_derivedKeyFromPassword:(NSString *)password salt:(NSData *)salt keySize:(NSUInteger)keySize {
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *derivedKey = [NSMutableData dataWithLength:keySize];
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      passwordData.bytes,
                                      passwordData.length,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA256, // 使用SHA-256哈希算法[citation:3]
                                      kPBKDF2Rounds,
                                      derivedKey.mutableBytes,
                                      derivedKey.length);
    return (result == kCCSuccess) ? [derivedKey copy] : nil;
}

// 执行AES加密/解密的通用函数
+ (NSData *)_doCipher:(NSData *)data key:(NSData *)key iv:(NSData *)iv operation:(CCOperation)operation {
    size_t bufferSize = data.length + kAlgorithmBlockSize;
    void *buffer = malloc(bufferSize);
    
    if (!buffer) return nil;
    
    size_t outLength = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kAlgorithm,
                                          kCCOptionPKCS7Padding, // 使用标准填充模式[citation:4]
                                          key.bytes,
                                          key.length,
                                          iv.bytes,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          bufferSize,
                                          &outLength);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytes:buffer length:outLength];
    }
    free(buffer);
    return result;
}



@end
