//
//   YQBaseViewController.h
   

#import <UIKit/UIKit.h>
#import "YQBasicNavBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YQBaseViewController : UIViewController



#pragma mark - 导航栏设置

@property (nonatomic, strong) YQBasicNavBarView *navigationBar;

@property (nonatomic, copy) NSString *navTitle;

// 隐藏导航条
- (void)hiddenNavigationBar:(BOOL)hidden;

// 设置导航条背景色
- (void)setNavigationBarBackgroundColor:(UIColor *)color;

// 设置导航条标题
- (void)setNavigationBarTitle:(NSString *)title;

// 设置导航条方向
- (void)setNavigationBarTitleTextAlignment:(NSTextAlignment)textAlignment;

// 设置导航条标题颜色
- (void)setNavigationBarTintColor:(UIColor *)tintColor;

// 隐藏返回按钮
- (void)hiddenNavigationBarLeftButton;

// 显示返回按钮
- (void)showNavigationBarLeftButton;

// 设置导航栏右侧按钮
- (void)setNavigationBarRightButton:(UIButton *)rightButton;

// 设置导航栏左侧按钮
- (void)setNavigationBarLeftButton:(UIButton *)leftButton;

// 设置导航栏线条 - 无
- (void)hiddenSeparator;

// 设置导航栏线条 - 细
- (void)setNavSmallSeparator;

// 设置导航栏线条 - 粗
- (void)setNavLargeSeparator;

// 隐藏home条
- (void)hiddenHomeIndicator;

// 显示home条
- (void)showHomeIndicator;


#pragma mark - 状态栏设置
/// 状态条白色
- (void)setStatusBarLightContentStyle;

/// 设置状态条黑色
- (void)setStatusBarDefaultStyle;


// 是否可右滑返回
- (void)navigationCanSlidingBack:(BOOL)canSlidingBack;



#pragma mark - 接口数据缓存
- (void)asyncCacheNetworkWithURLString:(NSString *)URLString response:(NSDictionary *)response;

- (NSDictionary *)getCacheWithURLString:(NSString *)URLString;


- (void)appThemeChanged;


///
@property (nonatomic, assign) NSInteger showPlayViewType;


- (void)updateLayoutForNewSize;

@end

NS_ASSUME_NONNULL_END
