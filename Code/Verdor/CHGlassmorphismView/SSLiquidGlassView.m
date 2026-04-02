//
//  SSLiquidGlassView.m

//
//  Created by  on 2025/7/3.

//

#import "SSLiquidGlassView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSLiquidGlassView
{
    CAGradientLayer *_topHighlightLayer;
    CAGradientLayer *_liquidLayer;
    CAShapeLayer *_liquidMaskLayer;
    CADisplayLink *_displayLink;
    CGFloat _animationPhase;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 默认参数
    _cornerRadius = 8;
    _glassColor = [UIColor colorWithWhite:0.95 alpha:0.7];
    _shadowColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    _shadowIntensity = 0.3;
    _highlightIntensity = 0.6;
    _enableLiquidAnimation = YES;
    
    // 设置基础属性
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
//    
//    // 创建暗阴影层 (右下)
//    _darkShadowLayer = [CALayer layer];
//    _darkShadowLayer.backgroundColor = [UIColor clearColor].CGColor;
//    _darkShadowLayer.shadowColor = _shadowColor.CGColor;
//    _darkShadowLayer.shadowOffset = CGSizeMake(6, 6);
//    _darkShadowLayer.shadowOpacity = _shadowIntensity;
//    _darkShadowLayer.shadowRadius = 12;
//    [self.layer addSublayer:_darkShadowLayer];
//    
//    // 创建亮阴影层 (左上)
//    _lightShadowLayer = [CALayer layer];
//    _lightShadowLayer.backgroundColor = [UIColor clearColor].CGColor;
//    _lightShadowLayer.shadowColor = [UIColor whiteColor].CGColor;
//    _lightShadowLayer.shadowOffset = CGSizeMake(-4, -4);
//    _lightShadowLayer.shadowOpacity = _highlightIntensity;
//    _lightShadowLayer.shadowRadius = 8;
//    [self.layer addSublayer:_lightShadowLayer];
//    
//    // 创建顶部高光层
//    _topHighlightLayer = [CAGradientLayer layer];
//    _topHighlightLayer.colors = @[
//        (id)[UIColor colorWithWhite:1.0 alpha:0.5].CGColor,
//        (id)[UIColor colorWithWhite:1.0 alpha:0.2].CGColor
//    ];
//    _topHighlightLayer.startPoint = CGPointMake(0.5, 0);
//    _topHighlightLayer.endPoint = CGPointMake(0.5, 0.3);
//    _topHighlightLayer.locations = @[@0, @1];
//    [self.layer addSublayer:_topHighlightLayer];
    
    // 创建液态层
    _liquidLayer = [CAGradientLayer layer];
    _liquidLayer.colors = @[
        (id)[UIColor colorWithWhite:1.0 alpha:0.6].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
        (id)[UIColor colorWithWhite:1.0 alpha:0.1].CGColor
    ];
    _liquidLayer.locations = @[@0, @0.5, @1];
    _liquidLayer.startPoint = CGPointMake(0, 0.5);
    _liquidLayer.endPoint = CGPointMake(1, 0.5);
    [self.layer addSublayer:_liquidLayer];
    
    // 液态层遮罩
    _liquidMaskLayer = [CAShapeLayer layer];
    _liquidLayer.mask = _liquidMaskLayer;
    
    // 添加动画
    if (_enableLiquidAnimation) {
        [self startLiquidAnimation];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 更新所有图层
    [self updateLayers];
}

- (void)updateLayers {
//    // 创建圆角路径
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
//    CGFloat y = _cornerRadius;
//    // 更新阴影层
//    _darkShadowLayer.frame = self.bounds;
//    _darkShadowLayer.cornerRadius = 6;
//    _darkShadowLayer.shadowPath = path.CGPath;
//    _darkShadowLayer.shadowRadius = 6;
//    _darkShadowLayer.shadowOffset = CGSizeMake(0, 0);
//    
//    _lightShadowLayer.frame = self.bounds;
//    _lightShadowLayer.cornerRadius = y;
//    _lightShadowLayer.shadowPath = path.CGPath;
//    _darkShadowLayer.shadowRadius = 6;
//    
//    // 更新高光层
//    _topHighlightLayer.frame = self.bounds;
//    _topHighlightLayer.cornerRadius = y;
    
    // 更新液态层
    _liquidLayer.frame = self.bounds;
    _liquidLayer.cornerRadius = _cornerRadius;
    
    // 更新液态层遮罩
    [self updateLiquidMask];
}

- (void)updateLiquidMask {
    // 创建波浪形状的遮罩
    CGRect bounds = self.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, height * 0.7)];
    
    // 波浪参数
    CGFloat amplitude = height * 0.05; // 波浪高度
    CGFloat waveLength = width / 2.0;  // 波浪长度
    CGFloat phase = _animationPhase;   // 动画相位
    
    // 绘制波浪
    for (CGFloat x = 0; x <= width; x += 1.0) {
        CGFloat y = height * 0.7 + amplitude * sin(2 * M_PI * (x / waveLength)) * cos(2 * M_PI * (phase / 10.0));
        [path addLineToPoint:CGPointMake(x, y)];
    }
    
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    [path closePath];
    
    _liquidMaskLayer.path = path.CGPath;
}

- (void)startLiquidAnimation {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAnimation)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopLiquidAnimation {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)updateAnimation {
    // 更新动画相位
    _animationPhase += 0.05;
    if (_animationPhase > 100) _animationPhase = 0;
    
    // 更新液态遮罩
    [self updateLiquidMask];
    
    
    // 轻微改变液态层颜色以模拟流动
    CGFloat variation = sin(_animationPhase) * 0.1;
    _liquidLayer.colors = @[
        (id)self.shadowColor.CGColor,
        (id)self.shadowColor.CGColor,
        (id)self.shadowColor.CGColor,
//        (id)[self.shadowColor colorWithAlphaComponent:0.6 + variation].CGColor,
//        (id)[self.shadowColor colorWithAlphaComponent:0.3].CGColor,
//        (id)[self.shadowColor colorWithAlphaComponent:0.1 - variation].CGColor,
        
//        (id)[UIColor colorWithWhite:1.0 alpha:0.6 + variation].CGColor,
//        (id)[UIColor colorWithWhite:1.0 alpha:0.3].CGColor,
//        (id)[UIColor colorWithWhite:1.0 alpha:0.1 - variation].CGColor
    ];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 绘制玻璃背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius];
    
    // 填充玻璃颜色
    CGContextAddPath(context, path.CGPath);
    CGContextSetFillColorWithColor(context, _glassColor.CGColor);
    CGContextFillPath(context);
    
    // 添加内部高光
    CGContextSaveGState(context);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    // 顶部高光
    CGGradientRef topGradient;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0, 0.3};
    CGFloat components[8] = {
        1.0, 1.0, 1.0, _highlightIntensity * 0.7,  // 起始颜色
        1.0, 1.0, 1.0, 0.0                          // 结束颜色
    };
    
    topGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    CGContextDrawLinearGradient(context, topGradient,
                                CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)),
                                CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect) * 0.3),
                                0);
    CGGradientRelease(topGradient);
    
    // 左侧高光
    CGFloat leftComponents[8] = {
        1.0, 1.0, 1.0, _highlightIntensity * 0.5,  // 起始颜色
        1.0, 1.0, 1.0, 0.0                          // 结束颜色
    };
    CGGradientRef leftGradient = CGGradientCreateWithColorComponents(colorSpace, leftComponents, locations, 2);
    CGContextDrawLinearGradient(context, leftGradient,
                                CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect)),
                                CGPointMake(CGRectGetMaxX(rect) * 0.2, CGRectGetMidY(rect)),
                                0);
    CGGradientRelease(leftGradient);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
}

- (void)dealloc {
    [self stopLiquidAnimation];
}

@end
