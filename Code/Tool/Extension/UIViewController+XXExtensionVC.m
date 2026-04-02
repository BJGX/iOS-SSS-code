//
//  UIViewController+XXExtensionVC.m

//
//  Created by  on 2018/3/28.
//  
//

#import "UIViewController+XXExtensionVC.h"

@implementation UIViewController (XXExtensionVC)


- (void)reloadViewWithIOS11 {
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)reloadViewWithIOS11Nerver {
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [UIView setAnimationsEnabled:YES]; 
}


- (void)superDealloc {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
