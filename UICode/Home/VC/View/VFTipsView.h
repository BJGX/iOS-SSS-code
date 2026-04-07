//
//  VFTipsView.h
//  VFProject
//


//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFTipsView : UIView
+ (void)showView:(NSString *)title
         content:(NSString *)content
         leftBtn:(NSString *)leftBtn
        rightBtn:(NSString *)rightBtn
           block:(stateBlock)block;
@end

NS_ASSUME_NONNULL_END
