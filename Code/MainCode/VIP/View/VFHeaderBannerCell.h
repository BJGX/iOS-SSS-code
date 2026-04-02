//
//  VFHeaderBannerCell.h
//  VFProject
//


//

#import <UIKit/UIKit.h>
#import "VFVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VFHeaderBannerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (nonatomic, copy) void (^buyActionBlock)(VFVipModel *model);

@property (nonatomic, strong) VFVipModel *model;
@end

NS_ASSUME_NONNULL_END
