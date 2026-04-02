//
//  ZYProGressView.m
//  ProgressBar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ZYProGressView.h"

@interface ZYProGressView()
{
    UIView *viewTop;
    UIView *viewBottom;
}

@end
@implementation ZYProGressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self buildUI];
        
    }
    return self;
}

- (void)buildUI
{
    
    viewBottom = [[UIView alloc]initWithFrame:self.bounds];
    viewBottom.backgroundColor = [UIColor grayColor];
    viewBottom.layer.cornerRadius = 3;
    viewBottom.layer.masksToBounds = YES;
    [self addSubview:viewBottom];
    
    
    viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, viewBottom.frame.size.height)];
    viewTop.backgroundColor = [UIColor redColor];
    viewTop.layer.cornerRadius = 3;
    viewTop.layer.masksToBounds = YES;
    [viewBottom addSubview:viewTop];
    
}

- (void)setProgressH:(CGFloat)progressH
{
    _progressH = progressH;
    viewTop.layer.cornerRadius = progressH / 2.0;
}


- (void)setTime:(float)time
{
    _time = time;
}
- (void)setProgressValue:(CGFloat)progressValue
{
    if (!_time) {
        _time = 3.0f;
    }
    _progressValue = progressValue;
    [UIView animateWithDuration:_time animations:^{
        
        self->viewTop.frame = CGRectMake(self.progressH / 2.0, (self.frame.size.height -  self.progressH) / 2.0, (self.frame.size.width - self.progressH) *progressValue, self.progressH);
        
    }];
}


- (void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    viewBottom.backgroundColor = bottomColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    viewTop.backgroundColor = progressColor;
}












@end
