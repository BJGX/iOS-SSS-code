//
//  CHGlassmorphismView.h

//
//  Created by  on 2025/6/29.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CHTheme) {
    CHThemeLight,
    CHThemeDark
};

IB_DESIGNABLE
@interface CHGlassmorphismView : UIView

// MARK: - Public Methods
- (void)makeGlassmorphismEffectWithTheme:(CHTheme)theme
                                density:(CGFloat)density
                            cornerRadius:(CGFloat)cornerRadius
                                distance:(CGFloat)distance;

- (void)setTheme:(CHTheme)theme;
- (void)setBlurDensityWithDensity:(CGFloat)density;
- (void)setCornerRadius:(CGFloat)value;
- (void)setDistance:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
