//
//  YQNavigationController.m
//  fuck
//
//  Created by Andrew on 2017/8/11.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "YQNavigationController.h"
#import "UINavigationController+DZM.h"

@interface YQNavigationController () <UINavigationControllerDelegate>

@property (assign, nonatomic) BOOL isSwitching;

@end

@implementation YQNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.delegate = self;
    // 使导航条有效
    [self setNavigationBarHidden:NO];
    
    // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
    [self.navigationBar setHidden:YES];
    
}

- (void)setEnableSlidingBack:(BOOL)enableSlidingBack
{
    _enableSlidingBack = enableSlidingBack;
    self.interactivePopGestureRecognizer.enabled = enableSlidingBack;
}


#pragma mark - private
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0 && !self.isTransition) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];

}



- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}




- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    if (self.enableSlidingBack) {
        self.enableSlidingBack = !isRootVC;
    }
    
    self.isSwitching = NO; // 3. 还原状态
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.interactivePopGestureRecognizer] && self.viewControllers.count > 1 &&
        [self.visibleViewController isEqual:[self.viewControllers lastObject]]) {
        //判断当导航堆栈中存在页面，并且可见视图如果不是导航堆栈中的最后一个视图时，就会屏蔽掉滑动返回的手势。此设置是为了避免页面滑动返回时因动画存在延迟所导致的卡死。
        return YES;
    } else {
        return NO;
    }
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return  UIInterfaceOrientationPortrait;
}

@end
