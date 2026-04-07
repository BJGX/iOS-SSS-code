//
//  UITextField+AreaCode.h
//  SSSVPN
//
//  Created by yuanqiu on 2025/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (AreaCode)
- (void)addCountryCodePicker;

- (void)remobeCode;

@property (nonatomic, strong) NSString *selectedDialCode;

@end

NS_ASSUME_NONNULL_END
