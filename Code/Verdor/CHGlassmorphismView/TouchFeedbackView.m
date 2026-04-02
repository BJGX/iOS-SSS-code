#import "TouchFeedbackView.h"

// 动画图层类（用于显示触摸效果）
@interface TouchAnimationLayer : CALayer
@property (nonatomic, assign) CGFloat animationProgress;
@end

@implementation TouchAnimationLayer

@dynamic animationProgress; // 声明为动态属性以实现自定义动画

// 告诉Core Animation该属性需要动画支持
+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"animationProgress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

// 绘制动画效果
- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.bounds.size.width / 2 * 0.8;
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    // 根据动画进度计算当前状态
    CGFloat progress = self.animationProgress;
    CGFloat currentRadius = radius * progress;
    CGFloat alpha = 1 - progress;
    
    // 设置圆形路径
    CGContextSetFillColorWithColor(ctx, [[UIColor appThemeColor] colorWithAlphaComponent:0.1].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor appThemeColor] colorWithAlphaComponent:0.5].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    // 绘制圆形
    CGContextAddArc(ctx, centerX, centerY, currentRadius, 0, M_PI * 2, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

// 主触摸反馈视图实现
@implementation TouchFeedbackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO; // 不拦截触摸事件
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

// 显示触摸动画
- (void)showTouchAtPoint:(CGPoint)point {
    // 创建动画图层
    TouchAnimationLayer *animationLayer = [TouchAnimationLayer layer];
    animationLayer.frame = CGRectMake(0, 0, 60, 60);
    animationLayer.position = point;
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"animationProgress"];
    animation.duration = 0.5;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 设置动画完成后的处理
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    // 添加动画
    [animationLayer addAnimation:animation forKey:@"touchAnimation"];
    
    // 动画完成后移除图层
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animation.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
    });
    
    // 添加到视图
    [self.layer addSublayer:animationLayer];
}

@end
