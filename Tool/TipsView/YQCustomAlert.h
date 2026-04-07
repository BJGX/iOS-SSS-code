//
//   YQCustomAlert.h
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQCustomAlert : UIView
+ (void)showAlert:(NSString *)title
         subTitle:(NSString *)subTitle
             type:(NSInteger)type
             icon:(NSString *)icon
      actionArray:(NSArray *)actionArray
         complete:(stateBlock)complete;
@end

NS_ASSUME_NONNULL_END
