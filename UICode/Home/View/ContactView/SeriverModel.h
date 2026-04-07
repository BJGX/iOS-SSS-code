//
//  SeriverModel.h
//  VFProjectModel
//


//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeriverModel : NSObject
@property (nonatomic, strong) NSString *authscheme;//用户ID
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *obfs;
@property (nonatomic, strong) NSString *obfs_param;
@property (nonatomic, strong) NSString *ot_domain;
@property (nonatomic, strong) NSString *ot_path;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSString *protocol_param;

@property (nonatomic, assign) NSInteger ota;
@property (nonatomic, assign) NSInteger ot_enable;
@property (nonatomic, assign) NSInteger port;
@end

NS_ASSUME_NONNULL_END
