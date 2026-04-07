//
//  UIView+HD.h
//  djBI
//
//  Created by MQ on 2/24/16.
//  Copyright © 2016 abnerh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MQ)

+ (__kindof UIView *)MQLoadNibView;
- (void)MQSetViewCircleWithBorderWidth:(CGFloat) width andColor:(UIColor *)borColor;
- (void)MQViewSetCornerRadius:(CGFloat)radius;

@end
