//
//   YQCurveView.m
   

#import "YQCurveView.h"

@interface YQCurveView()

{
    CGFloat _offset;
}
//帧刷新器
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) CAShapeLayer *wavelayer;
@property (nonatomic, assign) BOOL isLoad;
@end


@implementation YQCurveView


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(beginShow) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}


- (CAShapeLayer *)wavelayer
{
    if (!_wavelayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = [self getFrame];
        _wavelayer = layer;
    }
    return _wavelayer;
}

- (CGRect)getFrame
{
    CGRect frame = self.bounds;
    frame.origin.y = 0;
    frame.size.height = self.waveHeight;
    return frame;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.wavelayer];
    }
    return self;
}

- (void)start
{
    
    self.isLoad = NO;
    
    [self.timer setFireDate:[NSDate distantPast]];
    
}







- (void)beginShow
{
    _offset += 1;
    
    [self drawWave:self.waveX width:self.waveWidth offset:_offset];
    if (_offset >= self.waveHeight) {
        
        
//        ;
        
        if (self.isLoad) {
            [self.timer invalidate];
            self.timer = nil;
            _offset = 0;
            return;
        }
        _offset = 10;
        self.isLoad = YES;
        
        
    }
    
}




//- (void)drawWave:(CGFloat)x width:(CGFloat)width offset:(CGFloat)offset
//{
//
//    CGFloat newWidth = width/3.0;
//
//    CGFloat height = self.frame.size.height;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = 1;
//    path.lineCapStyle = kCGLineCapRound;
//    [path moveToPoint:CGPointMake(0, self.frame.size.height)];
//    [path addLineToPoint:CGPointMake(x, height)];
//    [path addCurveToPoint:CGPointMake(x + width, height) controlPoint1:CGPointMake(x + newWidth, offset) controlPoint2:CGPointMake(x + 2 * newWidth, offset)];
//    [path addLineToPoint:CGPointMake(self.frame.size.width, height)];
//    [path stroke];
//
//
//
//    self.wavelayer.path = path.CGPath;
//    self.wavelayer.strokeColor = self.color.CGColor;
//    self.wavelayer.fillColor = [UIColor whiteColor].CGColor;
//}

//创建浪
- (void)drawWave:(CGFloat)x width:(CGFloat)width offset:(CGFloat)offset
{
    //创建浪的路径
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGFloat height = self.waveHeight;
    CGFloat newWidth = width/3.0;
    
    CGFloat frameH = self.frame.size.height;
    CGPathMoveToPoint(wavePath, NULL, -1, frameH);
    
    
    CGPathAddLineToPoint(wavePath, NULL, -1, height);
    CGPathAddLineToPoint(wavePath, NULL, x, height);
    if (offset > 0) {
        CGPathAddCurveToPoint(wavePath, NULL, x + newWidth, height - offset, x + newWidth * 2, height - offset, x + width, height);
    }
    CGPathAddLineToPoint(wavePath, NULL, self.frame.size.width, height);
    CGPathAddLineToPoint(wavePath, NULL, self.frame.size.width, frameH);

    //用路径创建浪
    self.wavelayer.path = wavePath;
    self.wavelayer.strokeColor = self.color.CGColor;
    self.wavelayer.fillColor = [UIColor whiteColor].CGColor;
    //释放浪路径
    CGPathRelease(wavePath);
}




@end
