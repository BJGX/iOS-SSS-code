//
//   UIColor+YQCategoryColor.m
   

#import "UIColor+YQCategoryColor.h"

@implementation UIColor (YQCategoryColor)
+ (UIColor *)yq_lightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor
{
    
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            } else {
                return lightColor;
            }
        }];
    } else {
        return [QYSettingConfig shared].inNightMode ? darkColor : lightColor;
    }
}

+ (UIColor *)navBackgroundColor
{
//    return [self yq_lightColor:rgba(243, 245, 246, 1) darkColor:kBlackColor];
    return [UIColor whiteColor];
}

+ (UIColor *)backGroundColor
{
//    return [self yq_lightColor:[UIColor whiteColor] darkColor:kBlackColor];
    return [UIColor whiteColor];
}

+ (UIColor *)subBackgroundColor
{
//    return [self yq_lightColor:[UIColor whiteColor] darkColor:kBlackColor];
    return rgb(245, 245, 245);
}



+ (UIColor *)mainTextColor
{
//    return [self yq_lightColor:rgb(50, 52, 51) darkColor:[UIColor whiteColor]];
    return rgba(32, 32, 32, 1);
}

+ (UIColor *)subTextColor
{
    return rgba(153, 153, 153, 1);
}


+ (UIColor *)tableBackgroundColor
{

    return rgb(245, 245, 245);
}

+ (UIColor *)tabBarBackgroundColor
{

    return [UIColor whiteColor];
}


+ (UIColor *)inputTextBackcolor
{
    return [self yq_lightColor:rgb(242, 243, 243) darkColor:rgba(42, 42, 61, 1)];
}

+ (UIColor *)appThemeColor
{
    return rgba(254, 156, 143, 1);
}


+ (UIColor *)yq_layerColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor{
    return [QYSettingConfig shared].inNightMode ? darkColor : lightColor;
}



@end
