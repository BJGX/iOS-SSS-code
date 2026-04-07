//
//  UIView+HD.m
//  djBI
//
//  Created by MQ on 2/24/16.
//  Copyright © 2016 abnerh. All rights reserved.
//

#import "UIView+MQ.h"
#import <objc/runtime.h>

@implementation UIView (MQ)



+ (__kindof UIView *)MQLoadNibView{
    NSString *className = NSStringFromClass([self class]);
    return [[[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:self options:nil] lastObject];
}


-(void)MQViewSetCornerRadius:(CGFloat)radius{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}
-(void)MQSetViewCircleWithBorderWidth:(CGFloat) width andColor:(UIColor *)borColor{
    [self MQViewSetCornerRadius:(self.frame.size.height/2)];
    self.layer.borderWidth=width;
    self.layer.borderColor=[borColor CGColor];
}

@end
