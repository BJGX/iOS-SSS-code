//
//   TBTabBar.h
   

#import <UIKit/UIKit.h>
#import "YQCurveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBTabBar : UITabBar
//@property (nonatomic, strong) YQCurveView *curveView;
@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, assign) NSInteger selectIndex;


//@property (nonatomic, copy) void(^didSelectedTabbar)(NSInteger index, NSString *title);

@end

NS_ASSUME_NONNULL_END
