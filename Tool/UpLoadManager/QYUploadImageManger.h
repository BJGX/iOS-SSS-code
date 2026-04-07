

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYUploadImageManger : UIView

@property (nonatomic, strong) NSString *addImage;

@property (nonatomic, assign) CGFloat lineSpace;

@property (nonatomic, assign) CGFloat itemHeight;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSInteger lineCount;


@property (nonatomic, copy) void(^headerFrameChanged)(QYUploadImageManger *view);


- (void)showView:(BOOL)showAdd;

- (NSString *)getImages;

@end

NS_ASSUME_NONNULL_END
