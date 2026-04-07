//
//  SSConnectBtn.h

//
//  Created by  on 2025/6/30.

//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSConnectBtn : UIView
@property (nonatomic, strong) YQBaseModel *model;
@property (nonatomic, assign) CGFloat touchAreaScale;
@property (nonatomic, copy) void (^startAction)(void);
@end

NS_ASSUME_NONNULL_END
