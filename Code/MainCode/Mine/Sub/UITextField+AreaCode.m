//
//  UITextField+AreaCode.m
//  SSSVPN
//
//  Created by yuanqiu on 2025/10/15.
//

#import "UITextField+AreaCode.h"
#import <objc/runtime.h>
#import "VFChooseAreaCodeVC.h"
static void *kSelectedCountryKey = &kSelectedCountryKey;

static NSString *VFExtractRegionCodeFromLocaleIdentifier(NSString *localeIdentifier) {
    if (localeIdentifier.length == 0) {
        return nil;
    }
    NSString *countryCode = [NSLocale componentsFromLocaleIdentifier:localeIdentifier][NSLocaleCountryCode];
    return countryCode.uppercaseString;
}

@implementation UITextField (AreaCode)

- (void)setSelectedDialCode:(NSString *)selectedDialCode {
    objc_setAssociatedObject(self, kSelectedCountryKey, selectedDialCode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)selectedDialCode{
    return objc_getAssociatedObject(self, kSelectedCountryKey);
}
- (void)addCountryCodePicker
{
    [self setupLeftView];
}


- (void)remobeCode
{
    UIView *leftView = [UIView viewWithFrame:CGRectMake(0, 0, 20, 45) backgroundColor:[UIColor clearColor]];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setupLeftView {
    // 创建按钮
    NSString *defaultDialCode = self.selectedDialCode.length > 0 ? self.selectedDialCode : [self currentRegionDialCode];
    UIView *leftView = [UIView viewWithFrame:CGRectMake(0, 0, 80, 45) backgroundColor:[UIColor clearColor]];
    WeakSelf;
    UIButton *button = [UIButton buttonWithTitle:defaultDialCode titleColor:self.textColor font:self.font backgroundColor:[UIColor clearColor] superView:leftView btnClick:^(UIButton *btn) {
        VFChooseAreaCodeVC *vc = [VFChooseAreaCodeVC new];
        [vc setChooseBlock:^(NSString * _Nonnull code) {
            weakSelf.selectedDialCode = code;
            [btn setTitle:code forState:UIControlStateNormal];
        }];
        [[YQUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    }];
    button.frame = CGRectMake(0, 0, 80, 45);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, 12, 12)];
    arrow.image = [UIImage imageNamed:@"chevron-down2"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    arrow.center = CGPointMake(arrow.center.x, CGRectGetHeight(button.frame) / 2);
    [leftView addSubview:arrow];
    
    [UIView viewWithFrame:CGRectMake(75, 15, 1, 15) backgroundColor:[UIColor subTextColor] superView:leftView];
    
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.selectedDialCode = defaultDialCode;
}

- (NSString *)currentRegionDialCode
{
    NSString *regionCode = [self currentRegionCode];
    NSString *dialCode = [VFChooseAreaCodeVC dialCodeMapByRegionCode][regionCode];
    return dialCode.length > 0 ? dialCode : @"+86";
}

- (NSString *)currentRegionCode
{
    NSString *countryCode = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];
    countryCode = countryCode.uppercaseString;
    if (countryCode.length > 0) {
        return countryCode;
    }
    countryCode = VFExtractRegionCodeFromLocaleIdentifier([[NSLocale autoupdatingCurrentLocale] localeIdentifier]);
    if (countryCode.length > 0) {
        return countryCode;
    }
    return VFExtractRegionCodeFromLocaleIdentifier(NSLocale.preferredLanguages.firstObject);
}


@end
