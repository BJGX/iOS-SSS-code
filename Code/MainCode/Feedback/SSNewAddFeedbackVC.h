//
//  SSNewAddFeedbackVC.h

//
//  Created by  on 2025/7/14.

//

#import "YQBaseRefreshTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSNewAddFeedbackVC : YQBaseRefreshTableViewController
@property (nonatomic, copy) void (^completeAdd)(void);
@end

NS_ASSUME_NONNULL_END
