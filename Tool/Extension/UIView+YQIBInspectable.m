//
//  UIView+IBInspectable.m
//  HTDealApp
//
//  Created by 零度设计 on 2019/8/16.
//  Copyright © 2019 mxkj. All rights reserved.
//

#import "UIView+YQIBInspectable.h"
#import "YQShapeLayer.h"
#import <objc/runtime.h>
static char actionHandlerTapBlockKey;
static char actionHandlerTapGestureKey;
static char actionHandlerLongPressBlockKey;
static char actionHandlerLongPressGestureKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wobjc-property-implementation"

//IB_DESIGNABLE
@implementation UIView (YQIBInspectable)





- (CGFloat)cornerRadius
{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (cornerRadius > 0) {
        
//        CAShapeLayer *mask = [CAShapeLayer new];
//        mask.path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:cornerRadius].CGPath;
//        self.layer.mask = mask;
        
        self.layer.cornerRadius = cornerRadius;
        self.clipsToBounds = YES;
        
    }
}

- (BOOL)avatarCorner{
    return [objc_getAssociatedObject(self, @selector(cornerRadius)) floatValue] > 0;
}

- (void)setAvatarCorner:(BOOL)corner{
    if (corner){
        self.layer.cornerRadius = CGRectGetWidth(self.frame)/2;
        self.layer.masksToBounds = corner;
    }
}

- (CGFloat)borderWidth{
    return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    
    if (borderWidth > 0) {
        self.layer.borderWidth = borderWidth;
        self.layer.masksToBounds = (borderWidth > 0);
    }
    
    
}


- (UIColor *)borderColor{
    return objc_getAssociatedObject(self, @selector(borderColor));
}

- (void)setBorderColor:(UIColor *)borderColor{
    if (borderColor) {
        self.layer.borderColor = borderColor.CGColor;
    }
}


- (CALayer *)shadowLayer
{
    return objc_getAssociatedObject(self, @selector(shadowLayer));
}

- (void)setShadowLayer:(CALayer *)shadowLayer
{
    if (shadowLayer) {
        self.shadowLayer = shadowLayer;
    }
}


- (void)setNewViewForShadowLayerColor:(UIColor *)color
{
    
    NSString *s1 = [NSString stringWithFormat:@"%p",self];
    NSInteger s3 = strtoul(s1.UTF8String, 0, 16);
    
    UIView *newView = [self.superview viewWithTag:s3];
    if (newView == nil) {
        newView = [[UIView alloc] initWithFrame:self.frame];
    }
    newView.frame = self.frame;
    newView.tag = s3;
    [self.superview insertSubview:newView belowSubview:self];
    newView.cornerRadius = self.layer.cornerRadius;
    
}





- (void)shadowLayerColor:(UIColor *)color
             radiusInset:(YQRadiusInset)radiusInset
                  radius:(CGFloat)radius
{
    
    
    YQShapeLayer *layer = [[YQShapeLayer alloc] init];
    
    for (CAShapeLayer *layer2 in self.layer.sublayers) {
        if ([layer2 isKindOfClass:[YQShapeLayer class]]) {
            layer = (YQShapeLayer *)layer2;
            break;
            
        }
        
    }
//    
    
    
    CGRect bounds = self.bounds;
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    CGFloat topLeft = radiusInset.topLeft;
    CGFloat topRight = radiusInset.topRight;
    CGFloat bottomLeft = radiusInset.bottomLeft;
    CGFloat bottomRight = radiusInset.bottomRight;
    
    const CGFloat topLeftCenterX = minX + topLeft;
    const CGFloat topLeftCenterY = minY + topLeft;
    
    const CGFloat topRightCenterX = maxX - topRight;
    const CGFloat topRightCenterY = minY + topRight;
    
    const CGFloat bottomLeftCenterX = minX +  bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX -  bottomRight;
    const CGFloat bottomRightCenterY = maxY - bottomRight;
    
    
    CGMutablePathRef path = CGPathCreateMutable();

    //顶 左
    if (topLeft == 0) {
        CGPathAddLineToPoint(path, NULL, topLeftCenterX, topLeftCenterY);
    }
    else{
        CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY,topLeft, M_PI, 3 * M_PI_2, NO);
    }
    
    
    //顶 右
    if (topRight == 0) {
        CGPathAddLineToPoint(path, NULL, topRightCenterX, topRightCenterY);
    }
    else{
        CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, topRight, 3 * M_PI_2, 0, NO);
    }
    
    
    //底 右
    if (bottomRight == 0) {
        CGPathAddLineToPoint(path, NULL, bottomRightCenterX, bottomRightCenterY);
    }
    else{
        CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, bottomRight,0, M_PI_2, NO);
    }
    
    //底 左
    if (bottomLeft == 0) {
        CGPathAddLineToPoint(path, NULL, bottomLeftCenterX, bottomLeftCenterY);
    }
    else{
        CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, bottomLeft, M_PI_2,M_PI, NO);
    }
    

    CGPathCloseSubpath(path);
    
    layer.frame = self.bounds;
    
    [self.layer insertSublayer:layer atIndex:0];
    if (!layer.layerColor) {
        layer.layerColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
    }

    layer.fillColor = layer.layerColor.CGColor;
    layer.path = path;

    
    CALayer *subLayer = layer;
    subLayer.backgroundColor = [UIColor clearColor].CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,1);
    subLayer.shadowOpacity = 1;//阴影透明度，默认0
    subLayer.shadowRadius = radius;
    subLayer.shadowPath = path;
    
    
    //释放路径
    CGPathRelease(path);
    

}


- (void)shadowLayerColor:(UIColor *)color backColor:(UIColor *)backColor
{
    CALayer *subLayer = self.layer;
    subLayer.backgroundColor = backColor.CGColor;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,1);
    subLayer.shadowOpacity = 1;//阴影透明度，默认0
    subLayer.shadowRadius = 4;//阴影半径，默认3
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:subLayer.shadowRadius cornerRadii:CGSizeMake(0, 0)];
    subLayer.shadowPath = path.CGPath;
}

- (void)shadowLayerColor:(UIColor *)color
{

    [self shadowLayerColor:color backColor:[UIColor whiteColor]];
    
    
}

- (void)shadowBottomLayerColor:(UIColor *)color offset:(CGFloat)offset
{
    CALayer *subLayer = self.superview.layer;
    subLayer.masksToBounds = NO;
    subLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,4);
    subLayer.shadowOpacity = 1;//阴影透明度，默认0
    subLayer.shadowRadius = 5;
    CGRect f = self.frame;
    f.origin.x += offset;
    f.size.width -= offset*2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:f byRoundingCorners:subLayer.shadowRadius cornerRadii:CGSizeMake(0, 0)];
    subLayer.shadowPath = path.CGPath;
}


    
- (void)shadowLayerColor:(UIColor *)color radius:(CGFloat)radius
{
    [self shadowLayerColor:color radiusInset:YQRadiusInsetMake(radius, radius, radius, radius) radius:radius];
}
    
    
    

- (void)setCenterX:(CGFloat)centerX {

    self.center = CGPointMake(centerX, self.center.y);
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}



/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(gestureActionBlock)block{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &actionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &actionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &actionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        gestureActionBlock block = objc_getAssociatedObject(self, &actionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}




/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionWithBlock:(gestureActionBlock)block{
   UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &actionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &actionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &actionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        gestureActionBlock block = objc_getAssociatedObject(self, &actionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}



+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *__nullable)backgroundColor
                    superView:(UIView *__nullable)superView
                  layoutBlock:(void (^ __nullable)(UIView * view))layoutBlock {
    UIView *view = [[self alloc]initWithFrame:frame];
    view.frame = frame;
    view.backgroundColor = backgroundColor;
    if (superView) {
        [superView addSubview:view];
    }
    if (layoutBlock) {
        layoutBlock(view);
    }
    return view;
}

+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                    superView:(UIView *)superView {
    return [self viewWithFrame:frame backgroundColor:backgroundColor superView:superView layoutBlock:nil];
}
+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor {
  return [self viewWithFrame:frame backgroundColor:backgroundColor superView:nil layoutBlock:nil];
}


- (void)shapeLayerCornerRadius:(CGFloat )radius
{
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}


@end

#pragma clang diagnostic pop
