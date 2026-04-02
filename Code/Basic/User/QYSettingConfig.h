//
//   QYSettingConfig.h
   

#import <Foundation/Foundation.h>
#import "YQBaseModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface QYSettingConfig : NSObject


+ (QYSettingConfig*)shared;

@property (nonatomic, strong) NSString *collectString;

///是否在审核中
@property (nonatomic, assign) BOOL isReview;


///是否在审核中
@property (nonatomic, assign) BOOL isUpdate;

///是否已经显示了登录界面
@property (nonatomic, assign) BOOL showLoginVC;

@property (nonatomic, assign) CGFloat statusBarHeight;;


///倒计时
@property (nonatomic, assign) int countDown;
@property (nonatomic, copy) void(^blockCountDown)(int count);

- (void)stopTimer;


/**  夜间版颜色切换 */
@property (nonatomic, assign) BOOL inNightMode;


///加速模式 YES  智能加速
@property (nonatomic, assign) NSInteger isPacType;

/// 提示
@property (nonatomic, assign) NSInteger openTipsType;


- (NSString *)openString;

- (BOOL)isShowTipsView;


@end

NS_ASSUME_NONNULL_END
