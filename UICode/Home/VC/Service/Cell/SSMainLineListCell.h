//
//  SSMainLineListCell.h

//
//  Created by  on 2025/7/4.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSMainLineListCell : UITableViewCell
@property (nonatomic, strong) YQBaseModel *model;
@property (nonatomic, copy) void (^unfoldBlock)(void);
@end

NS_ASSUME_NONNULL_END
