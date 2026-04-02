//
//   YQBaseViewController.m
   

#import "YQBaseViewController.h"
#import "YQCache.h"

@interface YQBaseViewController ()
{
    BOOL hiddenHomeIndicator;
}

@property (nonatomic, assign) UIStatusBarStyle style;

@end

@implementation YQBaseViewController




- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    [_navigationBar setNavigationBarTitle:navTitle.localized];
}





#pragma mark - 控件
- (YQBasicNavBarView *)navigationBar
{
    if (!_navigationBar) {
        
        CGFloat top = 0;
        
//        if (![DeviceHelper isiPhone]) {
//            top = 40;
//        }
        
        _navigationBar = [[YQBasicNavBarView alloc] initWithFrame:CGRectMake(0.0f, top, ScreenWidth, PUB_NAVBAR_HEIGHT)];
        _navigationBar.navCurrentController = self;
        _navigationBar.backgroundColor = [UIColor navBackgroundColor];
        [_navigationBar setSmallSeparator];
    }
    return _navigationBar;
}





#pragma mark - 公共方法
// 返回上一页
- (void)popViewController
{
    [self.navigationBar popViewController];
}

// 是否可右滑返回
- (void)navigationCanSlidingBack:(BOOL)canSlidingBack;
{
    if (self.navigationController) {
        ((YQNavigationController *)(self.navigationController)).enableSlidingBack = canSlidingBack;
    }
}




- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [self superDealloc];
    }
}


#pragma mark - 导航栏设置

- (void)hiddenNavigationBar:(BOOL)hidden
{
    _navigationBar.hidden = hidden;
    
    if (hidden) {
        [self hiddenSeparator];
    }
}

- (void)setNavigationBarBackgroundColor:(UIColor *)color
{
    [_navigationBar setBackgroundColor:color];
}

- (void)setNavigationBarTitle:(NSString *)title
{
    [_navigationBar setNavigationBarTitle:title];
}

- (void)setNavigationBarTitleTextAlignment:(NSTextAlignment)textAlignment {
    self.navigationBar.navTitleLabel.textAlignment = textAlignment;
}

- (void)setNavigationBarTintColor:(UIColor *)tintColor
{
    [_navigationBar setNavigationBarTintColor:tintColor];
}

- (void)hiddenNavigationBarLeftButton
{
    [_navigationBar hiddenLeftBarButton];
}

- (void)showNavigationBarLeftButton {
    [_navigationBar showLeftBarButton];
}

- (void)setNavigationBarRightButton:(UIButton *)rightButton
{
    [_navigationBar setRightBarButton:rightButton];
}

// 设置导航栏左侧按钮
- (void)setNavigationBarLeftButton:(UIButton *)leftButton
{
    [_navigationBar setLeftBarButton:leftButton];
}

- (void)hiddenSeparator
{
    [_navigationBar hiddenSeparator];
}

- (void)setNavSmallSeparator
{
    [_navigationBar setSmallSeparator];
}

- (void)setNavLargeSeparator
{
    [_navigationBar setLargeSeparator];
}

#pragma mark - 状态栏设置

- (void)setStatusBarLightContentStyle
{
    self.style = UIStatusBarStyleLightContent;
//    [UIApplication sharedApplication].windows[0].windowScene.statusBarManager.statusBarStyle
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarDefaultStyle {
    
    if (@available(iOS 13.0, *)) {
        self.style = UIStatusBarStyleDefault;
    } else {
        self.style = UIStatusBarStyleDefault;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.style;
}



// 隐藏home条
- (void)hiddenHomeIndicator
{
    if (is_KiPhoneX) {
        if (@available(iOS 11.0, *)) {
            hiddenHomeIndicator = YES;
            [self prefersHomeIndicatorAutoHidden];
        } else {
            // Fallback on earlier versions
        }
    }
}

// 显示home条
- (void)showHomeIndicator
{
    if (is_KiPhoneX) {
        if (@available(iOS 11.0, *)) {
            hiddenHomeIndicator = NO;
            [self prefersHomeIndicatorAutoHidden];
        } else {
            // Fallback on earlier versions
        }
    }
}

#pragma mark - 接口数据缓存
- (void)asyncCacheNetworkWithURLString:(NSString *)URLString response:(NSDictionary *)response
{
    [YQCache saveCache:response key:URLString];
}

- (NSDictionary *)getCacheWithURLString:(NSString *)URLString
{
    NSDictionary *dic = [YQCache getCache:URLString];
    return dic;
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.style = UIStatusBarStyleDefault;
    [self setStatusBarLightContentStyle];
    self.view.backgroundColor = [UIColor backGroundColor];
    
    [self.view addSubview:self.navigationBar];
    [self hiddenSeparator];
    [self.navigationBar hiddenBackgroundView:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTabbar) name:@"reloadTabbar" object:nil];

}





- (void)reloadTabbar
{
    [self appThemeChanged];
}

- (void)appThemeChanged
{
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationBar && !self.navigationBar.hidden) {
        [self.view bringSubviewToFront:self.navigationBar];
    }
    if ([self.navigationController isKindOfClass:[YQNavigationController class]]) {
        ((YQNavigationController *)(self.navigationController)).enableSlidingBack = YES;
    }
    
    if (((YQNavigationController *)(self.navigationController)).canShowMusicView == NO) {
        return;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self setStatusBarLightContentStyle];
    

}


- (BOOL)prefersHomeIndicatorAutoHidden
{
    return hiddenHomeIndicator;
}

- (void)setNavigationBarTintColorsetNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    [_navigationBar setNavigationBarTitle:navTitle];
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


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if ([DeviceHelper isiPad]) {
            [self updateLayoutForNewSize];
            self.navigationBar.mj_w = ScreenWidth;
        }
        
    }];
}


- (void)updateLayoutForNewSize{
    
}

@end
