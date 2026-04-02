//
//  YQUtils.h
//  YQBaseProject
//
//  Created by Cjml on 2020/1/1.
//  Copyright © 2020 Cjml. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface YQUtils : NSObject




+ (UIWindow *)getKeyWindow;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


+ (void)createNewContentView:(UIView *)view;

+ (void)clipViewWithRounded:(UIView *)view
                    topLeft:(CGFloat)topLeft
                   topRight:(CGFloat)topRight
                 bottomLeft:(CGFloat)bottomLeft
                bottomRight:(CGFloat)bottomRight;


+ (void)viewGradientBorder:(UIView *)view
                 locations:(NSArray *)locations
                    colors:(NSArray *)colors
                startPoint:(CGPoint)startPoint
                  endPoint:(CGPoint)endPoint
              cornerRadius:(CGFloat)cornerRadius;

+ (CAGradientLayer *)viewGradientLayer:(UIView *)view
                locations:(NSArray *)locations
                   colors:(NSArray *)colors
               startPoint:(CGPoint)startPoint
                 endPoint:(CGPoint)endPoint;


+(NSInteger)currentTimeStamp;

+ (NSString *)getTimeFromTimestamp:(NSString *)timeStr;

+ (void)openWeChat;
+ (BOOL)openUrl:(NSString *)urlString;


+ (void)copyStringToPasteboard:(NSString *)string;

///view抖动
+ (void)shakeView:(UIView*)viewToShake;


+ (void)saveImageToLib:(UIImage *)image;

+ (NSString *)formatStringWithInteger:(NSUInteger)interger;


+ (NSString *)getCurrentTime;

+ (UIImage *)screenShot: (UIView *)view;


+ (NSURL *)getURL_byHost:(NSString *)url;


///16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)color;

///图标拉伸
+(UIImage *)imageOfStretchByImage: (UIImage *)image;

+(UIImage *)imageOfStretchByName: (NSString *)name;


+ (void)setAttentionBackImage:(UIButton *)sender is_fans:(int)is_fans;
+ (void)setAttenBtn: (UIButton *)sender is_fans:(int)is_fans;

+ (UIFont *)systemMediumFontOfSize: (CGFloat)size;

+ (UIFont *)systemSemiboldFontOfSize: (CGFloat)size;



// 显示底部提示
+ (void)showCenterMessage:(NSString *)title;

+ (void)setRightNavItemArray:(NSArray *)array
              viewController:(UIViewController *)vc
                isTitleArray:(BOOL)isTitle
                      action:(void(^)(NSInteger index))actionBlock;
+ (void)setLeftNavItemArray:(NSArray *)array
             viewController:(UIViewController *)vc
               isTitleArray:(BOOL)isTitle
                     action:(void(^)(NSInteger index))actionBlock;


// 对一个图形切割指定的圆角
+ (void)clipTheViewCornerWithCorner:(UIRectCorner)corner andView:(UIView *)view andCornerRadius:(CGFloat)radius;


+ (void)sendNotificationWithGame: (CGFloat)y;

///压缩头像
+ (UIImage *)scaleAvatarImage: (UIImage *)image;

+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

//+ (CGFloat)YQ0;
//
//+ (CGFloat)YQ0;

+ (UIViewController *)returnStoryboardVC: (NSString *)stroyboardName vcName: (NSString *)vcName;

/// 底部阴影
+ (void)shadowLayer:(CALayer *)viewLayer color:(UIColor*)color cornerRadius: (CGFloat)cornerRadius;

+ (UIViewController *)getCurrentVC;

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;


//根据高度得到宽度
+ (CGSize)sizeWithText:(NSString *)textstr Font:(UIFont *)font maxH:(CGFloat)maxH;
//根据高度得到宽度
+ (CGSize)sizeWithText:(NSString *)textstr Font:(UIFont *)font maxW:(CGFloat)maxW;

/** iOS11 适配 */
+ (void)adjustTableView:(UITableView *)tableViews viewController:(UIViewController *)view;
@end

