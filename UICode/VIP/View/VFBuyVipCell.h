//
//  VFBuyVipCell.h
//  VFProject
//


//

#import <UIKit/UIKit.h>
#import "VFVipModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VFBuyVipCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;


@property (nonatomic, copy) void (^buyActionBlock)(VFVipModel *model);

@property (nonatomic, strong) VFVipModel *model;
@end

NS_ASSUME_NONNULL_END
