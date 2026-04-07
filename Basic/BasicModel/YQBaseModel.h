//
//   YQBaseModel.h
   

#import <Foundation/Foundation.h>
#import "YQPlayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YQBaseModel : NSObject


@property (nonatomic, assign) int msgNum;

@property (nonatomic, assign) NSInteger pro;
@property (nonatomic, assign) NSInteger vip;

///-1 测试速度
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *speedString;


@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *link;

@property (nonatomic, strong) NSString *encryption;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString *password_encrypt;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *plugin;
@property (nonatomic, strong) NSString *plugin_options;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *service_str_encrypt;
@property (nonatomic, strong) NSString *service_str;
@property (nonatomic, strong) NSArray *service;

@property (nonatomic, strong) NSDictionary *param_s;

@property (nonatomic, assign) BOOL unFold;
@property (nonatomic, assign) BOOL isCollect;

@property (nonatomic, assign) CGFloat cellHeight;



@end

NS_ASSUME_NONNULL_END
