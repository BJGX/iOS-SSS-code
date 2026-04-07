//
//  UIView+CHGlassmorphismView.h

//
//  Created by  on 2025/6/29.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CHGlassmorphismView)

- (void)addLiquidGlassView:(CGFloat)cornerRadius
           shadowIntensity:(CGFloat )shadowIntensity
        highlightIntensity:(CGFloat )highlightIntensity;
- (void)addLightGlassView:(CGFloat)cornerRadius
              blurDensity:(CGFloat)blurDensity
                 distance:(CGFloat)distance;


- (void)addLiquidGlassView:(CGFloat)cornerRadius
                glassColor:(UIColor *)glassColor
               shadowColor:(UIColor *)shadowColor;

- (void)addDarkGlassView:(CGFloat)cornerRadius
              blurDensity:(CGFloat)blurDensity
                distance:(CGFloat)distance;

@end

NS_ASSUME_NONNULL_END
