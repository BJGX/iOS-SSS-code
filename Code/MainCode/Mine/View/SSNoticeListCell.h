//
//  SSNoticeListCell.h

//
//  Created by  on 2025/7/21.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSNoticeListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
