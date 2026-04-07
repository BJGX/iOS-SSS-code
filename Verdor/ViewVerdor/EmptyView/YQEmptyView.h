//
//   YQEmptyView.h
   

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface YQEmptyView : UIView


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, copy) void (^block)(void);

+ (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
