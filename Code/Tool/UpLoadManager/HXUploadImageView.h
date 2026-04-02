//
//   HXUploadImageView.h
   

#import <UIKit/UIKit.h>
#import "YQUpdataTool.h"

NS_ASSUME_NONNULL_BEGIN



@interface HXUploadImageView : UIImageView
@property (nonatomic, strong) NSString *psid;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) YQUpdataTool *model;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, copy) void(^deleteSelf)(HXUploadImageView *selfView, YQUpdataTool *model);

@end

NS_ASSUME_NONNULL_END
