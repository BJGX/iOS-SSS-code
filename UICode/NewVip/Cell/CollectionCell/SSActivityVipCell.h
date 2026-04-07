//
//  SSActivityVipCell.h

//


//

#import <UIKit/UIKit.h>
#import "VFVipModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SSActivityVipCell : UICollectionViewCell
@property (nonatomic, strong) VFVipModel *model;
@property (nonatomic, assign) BOOL highlightedStyle;
@end

NS_ASSUME_NONNULL_END
