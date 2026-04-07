//
//   UIColor+YQCategoryColor.h
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YQCategoryColor)
+ (UIColor *)yq_lightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;
///layer层color变换
+ (UIColor *)yq_layerColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

+ (UIColor *)backGroundColor;


+ (UIColor *)navBackgroundColor;

+ (UIColor *)mainTextColor;

+ (UIColor *)subTextColor;

+ (UIColor *)tableBackgroundColor;

+ (UIColor *)tabBarBackgroundColor;

+ (UIColor *)inputTextBackcolor;

+ (UIColor *)appThemeColor;

+ (UIColor *)subBackgroundColor;

@end

NS_ASSUME_NONNULL_END
