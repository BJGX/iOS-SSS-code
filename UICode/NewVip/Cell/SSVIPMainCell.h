//
//  SSVIPMainCell.h

//
//  Created by  on 2025/7/17.

//

#import <UIKit/UIKit.h>
#import "VFVipModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSVIPMainCell : UITableViewCell

@property (nonatomic, strong) VFVipModel *model;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSInteger)type;

@property (nonatomic, copy) void (^selectedModel)(VFVipModel *model);

@end

NS_ASSUME_NONNULL_END
