//
//  VFOrderListCell.h
//  VFProject
//


//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

NS_ASSUME_NONNULL_END
