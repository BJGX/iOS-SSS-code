//
//  UIView+IBInspectable.h
//  HTDealApp
//
//  Created by 零度设计 on 2019/8/16.
//  Copyright © 2019 mxkj. All rights reserved.
//

#import <UIKit/UIKit.h>

struct YQRadiusInset {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
};


typedef struct YQRadiusInset YQRadiusInset;

CG_INLINE YQRadiusInset
YQRadiusInsetMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight)
{
    YQRadiusInset radiusInset;
    radiusInset.topLeft = topLeft;
    radiusInset.topRight = topRight;
    radiusInset.bottomLeft = bottomLeft;
    radiusInset.bottomRight = bottomRight;
    return radiusInset;
};



typedef void (^gestureActionBlock)(UIGestureRecognizer * _Nullable sender);


NS_ASSUME_NONNULL_BEGIN



//IB_DESIGNABLE
@interface UIView (YQIBInspectable)
/** 设置边框颜色可视化 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;




@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat centerX;


/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(gestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionWithBlock:(gestureActionBlock)block;



+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *__nullable)backgroundColor
                    superView:(UIView *__nullable)superView
                  layoutBlock:(void (^ __nullable)(UIView * view))layoutBlock;
+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor
                    superView:(UIView *)superView;
+ (instancetype)viewWithFrame:(CGRect)frame
              backgroundColor:(UIColor *)backgroundColor;


- (void)setNewViewForShadowLayerColor:(UIColor *)color;


- (void)shadowLayerColor:(UIColor*)color;

- (void)shadowLayerColor:(UIColor*)color
                    radius:(CGFloat)radius;

- (void)shadowLayerColor:(UIColor *)color backColor:(UIColor *)backColor;

- (void)shadowLayerColor:(UIColor *)color
             radiusInset:(YQRadiusInset)radiusInset
            radius:(CGFloat)radius;



- (void)shadowBottomLayerColor:(UIColor *)color offset:(CGFloat)offset;


- (void)shapeLayerCornerRadius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
