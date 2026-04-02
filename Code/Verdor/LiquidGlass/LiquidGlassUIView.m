#import "LiquidGlassUIView.h"
#import "BackgroundTextureProvider.h"
#import <Metal/Metal.h>
#import <simd/simd.h>

typedef struct {
    vector_float2 resolution;
    float time;
    float blurScale;
    vector_float2 boxSize;
    float cornerRadius;
    vector_float3 tintColor;
    float tintAlpha;
} Uniforms;

@interface MetalCoordinator : NSObject <MTKViewDelegate>
@property (nonatomic, weak) LiquidGlassUIView *parentView;
@property (nonatomic, strong) BackgroundTextureProvider *backgroundProvider;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CGFloat ycornerRadius;
@property (nonatomic, assign) SnapshotUpdateMode updateMode;
@property (nonatomic, assign) CGFloat blurScale;
@property (nonatomic, strong) UIColor *tintColor;
@end

@implementation MetalCoordinator

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        _device = device;
        _ycornerRadius = 40.0;
        _blurScale = 0.5;
        _tintColor = [UIColor grayColor];
        [self setupMetal];
    }
    return self;
}

- (void)setupMetal {
    _commandQueue = [_device newCommandQueue];
    _startTime = CFAbsoluteTimeGetCurrent();
    
    id<MTLLibrary> library = [_device newDefaultLibrary];
    if (!library) {
        NSLog(@"Failed to create Metal library");
        return;
    }
    
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexPassthrough"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"liquidGlassFragment"];
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = vertexFunction;
    pipelineDescriptor.fragmentFunction = fragmentFunction;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    NSError *error;
    _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (error) {
        NSLog(@"Failed to create render pipeline state: %@", error);
    }
}

- (void)drawInMTKView:(MTKView *)view {
    id<MTLDrawable> drawable = view.currentDrawable;
    MTLRenderPassDescriptor *descriptor = view.currentRenderPassDescriptor;
    if (!drawable || !descriptor || !self.parentView) return;
    
    // 从父视图更新属性
    self.ycornerRadius = self.parentView.ycornerRadius;
    self.blurScale = self.parentView.blurScale;
    self.tintColor = self.parentView.glassTintColor;
    
    // 准备uniforms - 与 Swift 版本保持一致
    Uniforms uniforms;
    
    // 分辨率使用 drawableSize
    uniforms.resolution = (vector_float2){view.drawableSize.width, view.drawableSize.height};
    uniforms.time = CFAbsoluteTimeGetCurrent() - self.startTime;
    uniforms.blurScale = self.blurScale;
    
    // 关键修复：boxSize 使用视图的 bounds 尺寸（点坐标）
    CGSize viewSize = self.parentView.bounds.size;
    uniforms.boxSize = (vector_float2){(float)viewSize.width * 2, (float)viewSize.height * 2};
    
    // 关键修复：圆角半径使用 Swift 版本相同的计算方式
    uniforms.cornerRadius = self.ycornerRadius; // 与 Swift 版本一致
    
    // 颜色解析（保持与 Swift 版本相同）
    const CGFloat *components = CGColorGetComponents(self.tintColor.CGColor);
    size_t componentCount = CGColorGetNumberOfComponents(self.tintColor.CGColor);
    
    CGFloat red = 0;
    if (componentCount > 0) {
        red = components[0];
    }
    
    CGFloat green = 0;
    if (componentCount > 1) {
        green = components[1];
    }
    
    CGFloat blue = 0;
    if (componentCount > 2) {
        blue = components[2];
    } else if (componentCount == 1) {
        blue = 0.5;
    }
    
    CGFloat alpha = 1.0;
    if (componentCount == 2 || componentCount == 4) {
        alpha = components[componentCount - 1];
    }
    
    uniforms.tintColor = (vector_float3){(float)red, (float)green, (float)blue};
    uniforms.tintAlpha = (float)alpha;
    
    // 创建命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:descriptor];
    
    [encoder setRenderPipelineState:self.pipelineState];
    
    // 设置 uniforms
    [encoder setVertexBytes:&uniforms length:sizeof(Uniforms) atIndex:0];
    [encoder setFragmentBytes:&uniforms length:sizeof(Uniforms) atIndex:0];
    
    // 设置纹理和采样器
    id<MTLTexture> snapshotTexture = [self.backgroundProvider currentTextureForView:self.parentView];
    if (snapshotTexture) {
        [encoder setFragmentTexture:snapshotTexture atIndex:0];
    }
    
    MTLSamplerDescriptor *samplerDesc = [[MTLSamplerDescriptor alloc] init];
    id<MTLSamplerState> sampler = [self.device newSamplerStateWithDescriptor:samplerDesc];
    [encoder setFragmentSamplerState:sampler atIndex:0];
    
    // 绘制 6 个顶点（两个三角形）
    [encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
    
    [encoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    // 处理尺寸变化
}

@end



@implementation LiquidGlassUIView {
    MTKView *_metalView;
    MetalCoordinator *_coordinator;
    BackgroundTextureProvider *_backgroundProvider;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.ycornerRadius = 40.0;
    [self setupMetalView];
}

- (void)setupMetalView {
    _metalView = [[MTKView alloc] init];
    _metalView.device = MTLCreateSystemDefaultDevice();
    _metalView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    _metalView.opaque = NO;
    _metalView.layer.opaque = NO;
    _metalView.backgroundColor = [UIColor clearColor];
    _metalView.enableSetNeedsDisplay = YES;
    _metalView.translatesAutoresizingMaskIntoConstraints = NO;
    _metalView.contentScaleFactor = [UIScreen mainScreen].scale;
    [self addSubview:_metalView];
    [NSLayoutConstraint activateConstraints:@[
        [_metalView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_metalView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_metalView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_metalView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    if (!_metalView.device) {
        NSLog(@"Failed to create Metal device");
        return;
    }
    
    _coordinator = [[MetalCoordinator alloc] initWithDevice:_metalView.device];
    _metalView.delegate = _coordinator;
    
    _backgroundProvider = [[BackgroundTextureProvider alloc] initWithDevice:_metalView.device];
    _backgroundProvider.updateMode = self.updateMode;
    _backgroundProvider.updateInterval = self.updateInterval;
    
    __weak typeof(self) weakSelf = self;
    _backgroundProvider.didUpdateTexture = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.metalView setNeedsDisplay];
        });
    };
    
    _coordinator.backgroundProvider = _backgroundProvider;
    _coordinator.parentView = self;
}

- (MTKView *)metalView {
    return _metalView;
}

- (void)setYcornerRadius:(CGFloat)ycornerRadius {
    _ycornerRadius = ycornerRadius;
    self.layer.cornerRadius = ycornerRadius;
    [self setNeedsDisplay];
}

- (void)setUpdateMode:(SnapshotUpdateMode)updateMode {
    _updateMode = updateMode;
    _backgroundProvider.updateMode = updateMode;
}

- (void)setUpdateInterval:(NSTimeInterval)updateInterval {
    _updateInterval = updateInterval;
    _backgroundProvider.updateInterval = updateInterval;
}

- (void)setBlurScale:(CGFloat)blurScale {
    _blurScale = blurScale;
    [_metalView setNeedsDisplay];
}

- (void)setGlassTintColor:(UIColor *)glassTintColor {
    _glassTintColor = glassTintColor;
    [_metalView setNeedsDisplay];
}

- (void)invalidateBackground {
    [_backgroundProvider invalidate];
    [_metalView setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _metalView.frame = self.bounds;
    [_metalView setNeedsDisplay];
}

@end


