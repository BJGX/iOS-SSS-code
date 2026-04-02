//
//  SSLiquidGlassView.h

//
//  Created by  on 2025/7/3.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSLiquidGlassView : UIView
// 可配置参数
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *glassColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowIntensity;
@property (nonatomic, assign) CGFloat highlightIntensity;
@property (nonatomic, assign) BOOL enableLiquidAnimation;
@property (nonatomic, strong) CALayer *lightShadowLayer;
@property (nonatomic, strong) CALayer *darkShadowLayer;
@end

NS_ASSUME_NONNULL_END
