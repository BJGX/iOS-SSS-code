#import "BackgroundTextureProvider.h"
#import <MetalKit/MetalKit.h>

@interface BackgroundTextureProvider ()
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) MTKTextureLoader *textureLoader;
@property (nonatomic, weak) UIView *timerTarget;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) id<MTLTexture> cachedTexture;
@property (nonatomic, assign) CFAbsoluteTime lastCaptureTime;
@property (nonatomic, assign) BOOL isCapturingSnapshot;
@end

@implementation BackgroundTextureProvider

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        _textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
        _updateMode = SnapshotUpdateModeContinuous;
        _updateInterval = 0.01;
        [self resetTimer];
    }
    return self;
}

- (void)setUpdateMode:(SnapshotUpdateMode)updateMode {
    _updateMode = updateMode;
    [self resetTimer];
}

- (void)invalidate {
    self.cachedTexture = nil;
    self.lastCaptureTime = 0;
}

- (nullable id<MTLTexture>)currentTextureForView:(UIView *)view {
    if (self.timerTarget != view) {
        self.timerTarget = view;
    }
    
    if (self.cachedTexture) {
        return self.cachedTexture;
    }
    
    [view.layer displayIfNeeded];
    self.cachedTexture = [self makeSnapshotTextureFromView:view];
    self.lastCaptureTime = CFAbsoluteTimeGetCurrent();
    return self.cachedTexture;
}

- (void)resetTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.updateMode == SnapshotUpdateModeContinuous) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval
                                                     target:self
                                                   selector:@selector(updateTexture:)
                                                   userInfo:nil
                                                    repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateTexture:(NSTimer *)timer {
    if (!self.timerTarget) return;
    
    [self.timerTarget.layer displayIfNeeded];
    self.cachedTexture = [self makeSnapshotTextureFromView:self.timerTarget];
    self.lastCaptureTime = CFAbsoluteTimeGetCurrent();
}

- (nullable id<MTLTexture>)makeSnapshotTextureFromView:(UIView *)view {
    if (self.isCapturingSnapshot) return self.cachedTexture;
    self.isCapturingSnapshot = YES;
    
    CGImageRef cgImage = [self snapshotBehindView:view];
    if (!cgImage) {
        self.isCapturingSnapshot = NO;
        return nil;
    }
    
    NSError *error;
    id<MTLTexture> texture = [self.textureLoader newTextureWithCGImage:cgImage
                                                              options:@{MTKTextureLoaderOptionSRGB: @NO}
                                                                error:&error];
    CGImageRelease(cgImage);
    
    self.isCapturingSnapshot = NO;
    return texture;
}

- (nullable CGImageRef)snapshotBehindView:(UIView *)glass {
    UIWindow *window = glass.window;
    if (!window) return NULL;
    
    CGRect rect = [glass convertRect:glass.bounds toView:window];
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:rect.size];
    
    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef ctx = rendererContext.CGContext;
        CGContextTranslateCTM(ctx, -rect.origin.x, -rect.origin.y);
        
        UIColor *bgColor = window.backgroundColor ?: [UIColor systemBackgroundColor];
        CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
        CGContextFillRect(ctx, window.bounds);
        
        if (window.rootViewController.view) {
            CGContextSaveGState(ctx);
            [window.rootViewController.view.layer renderInContext:ctx];
            CGContextRestoreGState(ctx);
        }
        
        NSMutableArray<CALayer *> *layers = [NSMutableArray array];
        CALayer *layer = glass.layer;
        while (layer && layer != window.layer && layer.superlayer) {
            [layers addObject:layer];
            layer = layer.superlayer;
        }
        
        NSArray *reversedLayers = [[layers reverseObjectEnumerator] allObjects];
        [layers removeAllObjects];
        [layers addObjectsFromArray:reversedLayers];
        CALayer *parentLayer = window.layer;
        
        for (CALayer *wanted in layers) {
            NSInteger idx = [parentLayer.sublayers indexOfObject:wanted];
            if (idx == NSNotFound) break;
            
            for (NSInteger i = 0; i < idx; i++) {
                CALayer *sib = parentLayer.sublayers[i];
                if (!sib) continue;
                
                if ([sib.delegate isKindOfClass:[UIView class]]) {
                    UIView *sibView = (UIView *)sib.delegate;
                    CGRect f = [sibView convertRect:sibView.bounds toView:window];
                    CGContextSaveGState(ctx);
                    CGContextTranslateCTM(ctx, f.origin.x, f.origin.y);
                    [sib renderInContext:ctx];
                    CGContextRestoreGState(ctx);
                } else {
                    [sib renderInContext:ctx];
                }
            }
            
            if ([wanted.delegate isKindOfClass:[UIView class]]) {
                UIView *wantedView = (UIView *)wanted.delegate;
                CGContextTranslateCTM(ctx, wantedView.frame.origin.x, wantedView.frame.origin.y);
            }
            parentLayer = wanted;
        }
    }];
    
    return CGImageRetain(image.CGImage);
}

@end
