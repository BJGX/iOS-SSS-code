//
//  UIView+CHGlassmorphismView.m

//
//  Created by  on 2025/6/29.

//

#import "UIView+CHGlassmorphismView.h"
#import "CHGlassmorphismView.h"
#import "SSLiquidGlassView.h"

@implementation UIView (CHGlassmorphismView)



- (void)addLiquidGlassView:(CGFloat)cornerRadius
           shadowIntensity:(CGFloat )shadowIntensity
        highlightIntensity:(CGFloat )highlightIntensity
{
    SSLiquidGlassView *view = [[SSLiquidGlassView alloc] initWithFrame:self.bounds];
    view.userInteractionEnabled = NO;
    [self insertSubview:view atIndex:0];
    view.glassColor = [UIColor colorWithWhite:0.97 alpha:0.8];;
    view.shadowColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:0.3];;
    view.shadowIntensity = shadowIntensity;
    view.darkShadowLayer.shadowOpacity = shadowIntensity;
    view.highlightIntensity = highlightIntensity;
    view.lightShadowLayer.shadowOpacity = highlightIntensity;
    view.cornerRadius = cornerRadius;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];

   
    
}



- (void)addLiquidGlassView:(CGFloat)cornerRadius
                glassColor:(UIColor *)glassColor
               shadowColor:(UIColor *)shadowColor
{
    SSLiquidGlassView *view = [[SSLiquidGlassView alloc] initWithFrame:self.bounds];
    view.userInteractionEnabled = NO;
    [self insertSubview:view atIndex:0];
    view.glassColor = glassColor;
    view.shadowColor = shadowColor;
    view.darkShadowLayer.shadowOpacity = 0.5;
    view.lightShadowLayer.shadowOpacity = 0.5;
    view.cornerRadius = cornerRadius;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];

   
    
}

- (void)addLightGlassView:(CGFloat)cornerRadius
              blurDensity:(CGFloat)blurDensity
                 distance:(CGFloat)distance
{
    CHGlassmorphismView *view = [[CHGlassmorphismView alloc] init];
    view.userInteractionEnabled = NO;
    [self insertSubview:view atIndex:0];
    [view setBlurDensityWithDensity:blurDensity];
    [view setCornerRadius:cornerRadius];
    [view setDistance:distance];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];

   
    
}



- (void)addDarkGlassView:(CGFloat)cornerRadius
              blurDensity:(CGFloat)blurDensity
                 distance:(CGFloat)distance
{
    CHGlassmorphismView *view = [[CHGlassmorphismView alloc] init];
    [self insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [view makeGlassmorphismEffectWithTheme:CHThemeDark density:blurDensity cornerRadius:cornerRadius distance:distance];
    
}





@end
