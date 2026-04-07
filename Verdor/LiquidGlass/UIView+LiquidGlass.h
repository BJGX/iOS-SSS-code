//
//  UIView+LiquidGlass.h

//
//  Created by  on 2025/6/29.

//

#import <UIKit/UIKit.h>
#import "LiquidGlassUIView.h"
#import "BackgroundTextureProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LiquidGlass)
- (LiquidGlassUIView *)addLiquidGlassBackgroundWithYcornerRadius:(CGFloat)ycornerRadius
                                                      updateMode:(SnapshotUpdateMode)updateMode
                                                continuousInterval:(NSTimeInterval)interval
                                                       blurScale:(CGFloat)blurScale
                                                       tintColor:(UIColor *)tintColor;

- (LiquidGlassUIView *)addLiquidGlassBackgroundWithFrame:(CGRect)frame
                                          ycornerRadius:(CGFloat)ycornerRadius
                                             updateMode:(SnapshotUpdateMode)updateMode
                                       continuousInterval:(NSTimeInterval)interval
                                              blurScale:(CGFloat)blurScale
                                              tintColor:(UIColor *)tintColor;

- (void)removeLiquidGlassBackgrounds;
- (nullable LiquidGlassUIView *)liquidGlassBackground;
- (NSArray<LiquidGlassUIView *> *)liquidGlassBackgrounds;
@end

NS_ASSUME_NONNULL_END
