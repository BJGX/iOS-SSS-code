#import "UIView+LiquidGlass.h"

@implementation UIView (LiquidGlass)

- (LiquidGlassUIView *)addLiquidGlassBackgroundWithYcornerRadius:(CGFloat)ycornerRadius
                                                     updateMode:(SnapshotUpdateMode)updateMode
                                               continuousInterval:(NSTimeInterval)interval
                                                      blurScale:(CGFloat)blurScale
                                                      tintColor:(UIColor *)tintColor {
    LiquidGlassUIView *glassView = [[LiquidGlassUIView alloc] init];
    glassView.ycornerRadius = ycornerRadius;
    glassView.updateMode = updateMode;
    glassView.updateInterval = interval;
    glassView.blurScale = blurScale;
    glassView.glassTintColor = tintColor;
    
    glassView.translatesAutoresizingMaskIntoConstraints = NO;
    [self insertSubview:glassView atIndex:0];
    
    
    [NSLayoutConstraint activateConstraints:@[
        [glassView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [glassView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [glassView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [glassView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    return glassView;
}

- (LiquidGlassUIView *)addLiquidGlassBackgroundWithFrame:(CGRect)frame
                                          ycornerRadius:(CGFloat)ycornerRadius
                                             updateMode:(SnapshotUpdateMode)updateMode
                                       continuousInterval:(NSTimeInterval)interval
                                              blurScale:(CGFloat)blurScale
                                              tintColor:(UIColor *)tintColor {
    LiquidGlassUIView *glassView = [[LiquidGlassUIView alloc] initWithFrame:frame];
    glassView.ycornerRadius = ycornerRadius;
    glassView.updateMode = updateMode;
    glassView.updateInterval = interval;
    glassView.blurScale = blurScale;
    glassView.glassTintColor = tintColor;
    
    [self insertSubview:glassView atIndex:0];
    return glassView;
}

- (void)removeLiquidGlassBackgrounds {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[LiquidGlassUIView class]]) {
            [subview removeFromSuperview];
        }
    }
}

- (nullable LiquidGlassUIView *)liquidGlassBackground {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[LiquidGlassUIView class]]) {
            return (LiquidGlassUIView *)subview;
        }
    }
    return nil;
}

- (NSArray<LiquidGlassUIView *> *)liquidGlassBackgrounds {
    NSMutableArray *results = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[LiquidGlassUIView class]]) {
            [results addObject:subview];
        }
    }
    return [results copy];
}

@end
