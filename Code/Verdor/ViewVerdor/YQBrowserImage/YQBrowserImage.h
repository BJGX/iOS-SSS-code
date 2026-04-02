//
//   YQBrowserImage.h
   

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQBrowserImage : NSObject
+ (void)showImageArray:(NSArray *)array current:(NSInteger)current view:(UIView *)view;
+ (void)showLocalArray:(id)array current:(NSInteger)current view:(nonnull UIView *)view;

+ (void)chooseImageView;
@end

NS_ASSUME_NONNULL_END
