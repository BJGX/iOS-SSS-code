//
//   YQCurveView.h
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQCurveView : UIView
@property (nonatomic, assign) CGFloat waveHeight;
@property (nonatomic, assign) CGFloat waveX;
@property (nonatomic, assign) CGFloat waveWidth;
@property (nonatomic, strong) UIColor *color;

- (void)start;
@end

NS_ASSUME_NONNULL_END
