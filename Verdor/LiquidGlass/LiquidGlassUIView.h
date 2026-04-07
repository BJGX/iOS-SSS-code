//
//  LiquidGlassUIView.h

//
//  Created by  on 2025/6/29.

//

#import <UIKit/UIKit.h>
#import "BackgroundTextureProvider.h"
#import <MetalKit/MetalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiquidGlassUIView : UIView

@property (nonatomic, assign) CGFloat ycornerRadius;
@property (nonatomic, assign) SnapshotUpdateMode updateMode;
@property (nonatomic, assign) NSTimeInterval updateInterval;
@property (nonatomic, assign) CGFloat blurScale;
@property (nonatomic, strong) UIColor *glassTintColor;

- (void)invalidateBackground;

@end

NS_ASSUME_NONNULL_END
