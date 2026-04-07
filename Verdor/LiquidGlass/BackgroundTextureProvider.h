//
//  BackgroundTextureProvider.h

//
//  Created by  on 2025/6/29.

//

#import <Foundation/Foundation.h>
#import <MetalKit/MetalKit.h>

typedef NS_ENUM(NSUInteger, SnapshotUpdateMode) {
    SnapshotUpdateModeOnce,
    SnapshotUpdateModeManual,
    SnapshotUpdateModeContinuous
};

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundTextureProvider : NSObject
@property (nonatomic, assign) SnapshotUpdateMode updateMode;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, copy, nullable) void (^didUpdateTexture)(void);

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)invalidate;
- (nullable id<MTLTexture>)currentTextureForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
