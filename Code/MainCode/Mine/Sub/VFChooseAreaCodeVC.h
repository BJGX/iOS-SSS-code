//
//  VFChooseAreaCodeVC.h
//  SSSVPN
//
//  Created by yuanqiu on 2025/10/15.
//

#import "YQBaseRefreshTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VFChooseAreaCodeVC : YQBaseRefreshTableViewController
@property (nonatomic, copy) void (^chooseBlock)(NSString *code);
+ (NSDictionary<NSString *, NSString *> *)dialCodeMapByRegionCode;
@end

NS_ASSUME_NONNULL_END
