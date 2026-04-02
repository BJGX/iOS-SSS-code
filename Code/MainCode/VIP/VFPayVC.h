//
//  VFPayVC.h
//  VFProject
//


//

#import "YQBaseViewController.h"
#import "VFVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VFPayVC : YQBaseViewController
@property (nonatomic, strong) VFVipModel *model;
@property (nonatomic, strong) NSString *wxts;
@end

NS_ASSUME_NONNULL_END
