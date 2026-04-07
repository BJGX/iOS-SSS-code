//
//  VFContactView.h
//  VFProject
//


//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VFContactView : UIView

+ (instancetype)initView;

+ (void)closeVPN;

- (void)closeVF;

- (void)contactActionVF;

/// 0 未连接 1 连接中  2 已链接
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, strong) YQBaseModel *model;

@property (nonatomic, copy) void (^startAction)(void);

@end

NS_ASSUME_NONNULL_END
