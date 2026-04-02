#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LogLevel) {
    LogLevelDebug,
    LogLevelInfo,
    LogLevelWarning,
    LogLevelError
};

@interface SimpleLogger : NSObject

// 单例实例
+ (instancetype)sharedLogger;

// 配置日志路径 (默认: ~/Documents/AppLogs)
- (void)configureLogDirectory:(NSString *)directory;

// 核心日志方法
- (void)logWithLevel:(LogLevel)level 
            category:(NSString *)category 
             message:(NSString *)message;

// 清空日志
- (void)clearLogs;

- (NSURL *)openLogsFolder;

@end
