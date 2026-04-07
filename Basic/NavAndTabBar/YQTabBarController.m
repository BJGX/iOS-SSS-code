//
//  YQTabBarController.m

//
//  Created by  on 2018/3/16.
//  
//

#import "YQTabBarController.h"
#import "YQNavigationController.h"
#import <SDAutoLayout.h>

#import "YYFPSLabel.h"
#import "VFHomeVC.h"
#import "VFMainSharedVC.h"
#import "VFMainVipVC.h"
#import "SSMainHomeView.h"
#import "SSNewVIPVC.h"
#import "VFMineVC.h"
#if !TARGET_OS_MACCATALYST
#import <AdjustSdk/AdjustSdk.h>
#endif

@interface YQTabBarModel: NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *selectedImage;

@end

@implementation YQTabBarModel
@end


@interface YQTabBarController ()<UITabBarControllerDelegate, UITabBarDelegate,UIViewControllerAnimatedTransitioning>


@property (nonatomic, strong) UIButton *kfOpenBtn;
@property (nonatomic, strong) UIButton *gwOpenBtn;


@end

@implementation YQTabBarController



- (void)requestPermissionIfNeeded
{
#if !TARGET_OS_MACCATALYST
    [Adjust requestAppTrackingAuthorizationWithCompletionHandler:^(NSUInteger status) {
        NSLog(@"requestAppTrackingAuthorizationWithCompletionHandler = %ld", status);
    }];
    ADJConfig *adjustConfig = [[ADJConfig alloc] initWithAppToken:@"hza4cpubp1q8"  environment:ADJEnvironmentSandbox];
   [adjustConfig setAttConsentWaitingInterval:30];
   [Adjust initSdk:adjustConfig];
    
    [Adjust idfaWithCompletionHandler:^(NSString * _Nullable idfa) {
        NSLog(@"idfa = %@",idfa);
    }];
    [Adjust idfvWithCompletionHandler:^(NSString * _Nullable idfv) {
        NSLog(@"idfv = %@",idfv);
    }];
#endif
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NPLanguageTool shared] initUserLanguage];
    
//    self.delegate = self;
    WeakSelf;
    [YQNetwork ReachabilityChanged:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [weakSelf loginWithApple:nil];
                [QYCommonFuncation upldateApp];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf requestPermissionIfNeeded];
                });
                
                
            });
        }
//        [YQUserModel ];
    }];
    self.delegate = self;
    [self setUI];
    [QYSettingConfig shared].isReview = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutUser) name:@"loginOutUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTabbarIndex:) name:@"selectedTabbarIndex" object:nil];
    
    [self loginWithApple:nil];
    [self setScreenBtn];
    
}

- (void)selectedTabbarIndex:(NSNotification *)sender
{
    if ([self isIOS26]) {
        return;
    }
    self.myTabBar.selectIndex = [sender.object integerValue];

}



- (void)loginWithApple:(NSString *)uid
{
    if ([YQNetwork isNotReachable]) {
        return;
    }
    
    if ([YQUserModel shared].user.isLogin == YES) {
        return;
    }
    NSString *url = @"api/en/user/tourist";
    NSDictionary *dic;
    if ([uid length]) {
        dic = @{@"device_id": uid};
    }
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在登录" andBlock:^(id obj, NSInteger code) {
        
        if (code == 1) {
            
            
            
            YQUserModel *user= [YQUserModel shared].user;
            if (user == nil) {
                user = [[YQUserModel alloc] init];
            }
            user.token = obj[@"data"][@"token"];
            user.isLogin = YES;
            [YQUserModel shared].user = user;
//            [QYCommonFuncation getUserInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
            [YQNetwork StopMonitoring];
//            [self isOpenShare];
        }
        
    }];
}

- (void)loginOutUser
{
    if ([self isIOS26]) {
        return;
    }
    self.myTabBar.selectIndex = 0;
}





- (void)setUI {
//    self.hidesBottomBarWhenPushed = YES;
    
//    self.titleArray = [NSMutableArray new];
    
    
    
    
    
    
    
//    

//    
//    MLMineVC *mineVC = [[MLMineVC alloc] init];
//    [self setRootTabbar:@"我的" imageName:@"icon_tabbar_4" selectedImageName:@"icon_tabbar_4-1" rootVC:mineVC];
//    
    
    
    
    
//    [self setRootTabbar:@"首页" rootVC:firstVC];
////
//    HXCacheListVC *practiceVC = [[HXCacheListVC alloc] initWithStyle:NO];
//    [self setRootTabbar:@"地图" rootVC:practiceVC];
//
//    HXMainUploadVC *mineVC = [[HXMainUploadVC alloc] init];
//    [self setRootTabbar:@"我的" rootVC:mineVC];
    [self loginSuccess];
    
    
    
    if ([self isIOS26] ||  [DeviceHelper isiPadOnMac]) {
        self.tabBar.tintColor = [UIColor appThemeColor];
//        self.tabBar.tintColor =
        self.tabBar.unselectedItemTintColor = [UIColor mainTextColor];
        
        return;
    }
    
    
    self.myTabBar = [[TBTabBar alloc] init];
    [self setValue:self.myTabBar forKeyPath:@"tabBar"];
    self.myTabBar.tintColor = [UIColor whiteColor];
    self.myTabBar.unselectedItemTintColor = [UIColor mainTextColor];
    self.myTabBar.backgroundColor = [UIColor backGroundColor];
//
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LoginSuccess" object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTabBar.selectIndex = 0;
    });

    
}

- (BOOL)isIOS26 {
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *versionComponents = [systemVersion componentsSeparatedByString:@"."];
    NSInteger majorVersion = [[versionComponents firstObject] integerValue];
    
    return majorVersion >= 26;
}



- (void)reloadTabBarUI:(BOOL)isReview
{
    
    
//    VFHomeVC *firstVC = (VFHomeVC *)[YQUtils returnStoryboardVC:@"Home" vcName:nil];
//    [self setRootTabbar:@"首页" imageName:@"icon_tabbar_1" selectedImageName:@"icon_tabbar_1_1" rootVC:firstVC];
    
    
    SSMainHomeView *firstVC = [SSMainHomeView new];
    [self setRootTabbar:@"首页".localized imageName:@"icon_tabbar_1" selectedImageName:@"icon_tabbar_1_1" rootVC:firstVC];
    
    

    SSNewVIPVC *chatVC = [[SSNewVIPVC alloc] init];
    [self setRootTabbar:@"商城".localized imageName:@"icon_tabbar_3" selectedImageName:@"icon_tabbar_3_1" rootVC:chatVC];
    
    
    
    VFMainSharedVC *dynamicVC = [[VFMainSharedVC alloc] initWithNibName:@"VFMainSharedVC" bundle:nil];
    [self setRootTabbar:@"分享".localized imageName:@"icon_tabbar_2" selectedImageName:@"icon_tabbar_2_1" rootVC:dynamicVC];

    
    
    VFMineVC *mineVC = [[VFMineVC alloc] init];
    [self setRootTabbar:@"我的".localized imageName:@"icon_tabbar_4" selectedImageName:@"icon_tabbar_4_1" rootVC:mineVC];
    
    
    
    [UITabBar appearance].tintColor = [UIColor appThemeColor];
    
}


- (void)loginSuccess
{
    
}



- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setRootTabbar: (NSString *) title
            imageName: (NSString *)imageName
    selectedImageName: (NSString *)selectedImageName
               rootVC: (UIViewController *)rootVC {
    rootVC.tabBarItem.title = title;
    rootVC.tabBarItem.image = [[UIImage  imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    if ([NSProcessInfo processInfo].isiOSAppOnMac || [self isIOS26]) {
        
        rootVC.tabBarItem.selectedImage = [UIImage  imageNamed:selectedImageName];
    }
    else {
        rootVC.tabBarItem.selectedImage = [[UIImage  imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
//    rootVC.tabBarItem

    
    if ([NSProcessInfo processInfo].isiOSAppOnMac && ![self isIOS26]) {
        [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor appThemeColor]} forState:UIControlStateSelected];
    }
    else {
        [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    }
   
    [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainTextColor]} forState:UIControlStateNormal];
    
    
    
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:rootVC];
    nav.canShowMusicView = YES;
    nav.view.backgroundColor = [UIColor subBackgroundColor];
    [self addChildViewController:nav];
    YQTabBarModel *model = [YQTabBarModel new];
    model.title = title;
    model.normalImage = imageName;
    model.selectedImage = selectedImageName;
//    [self.titleArray addObject:model];
}

- (YQNavigationController *)addRootTabbar: (NSString *) title
            imageName: (NSString *)imageName
    selectedImageName: (NSString *)selectedImageName
               rootVC: (UIViewController *)rootVC
{
    rootVC.tabBarItem.title = title;
    rootVC.tabBarItem.image = [[UIImage  imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    rootVC.tabBarItem.selectedImage = [[UIImage  imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [rootVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor mainTextColor]} forState:UIControlStateNormal];
    
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:rootVC];
    
    
    YQTabBarModel *model = [YQTabBarModel new];
    model.title = title;
    model.normalImage = imageName;
    model.selectedImage = selectedImageName;
//    [self.titleArray addObject:model];
//    [self addChildViewController:nav];
    return nav;
//    [self addChildViewController:nav];
    
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
   
}






///去掉iOS18动画
- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [transitionContext.containerView addSubview:toView];
    [transitionContext completeTransition:YES];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([self isIOS26]) {
        return;
    }
    self.myTabBar.selectIndex = self.selectedIndex;
    [self setAnaimationWithTabBarController:tabBarController selectViewController:viewController];
}

- (void)setAnaimationWithTabBarController:(UITabBarController *)tabBarController selectViewController:(UIViewController *)viewController {
    
    //1.
    NSInteger index = [tabBarController.viewControllers indexOfObject:viewController];
    __block NSMutableArray <UIView *>*tabBarSwappableImageViews = [NSMutableArray arrayWithCapacity:2];
    //2.
    for (UIView *tempView in tabBarController.tabBar.subviews) {
        if ([tempView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            for (UIImageView *tempImageView in tempView.subviews) {
                if ([tempImageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                    [tabBarSwappableImageViews addObject:tempImageView];
                }
            }
        }
    }
    //3.
    __block UIView *currentTabBarSwappableImageView = tabBarSwappableImageViews[index];
    //动画01-带重力效果的弹跳
//    [AnimationHelper gravityAnimation:currentTabBarSwappableImageView];
    //动画02-先放大，再缩小
    [self zoominTozoomoutAnimation:currentTabBarSwappableImageView];
    
    //动画03-Z轴旋转
//    [AnimationHelper zaxleRotationAnimation:currentTabBarSwappableImageView];
    //动画04-Y轴位移
//    [AnimationHelper yaxleMovementAnimation:currentTabBarSwappableImageView];
    //动画05-放大并保持
//    [AnimationHelper zoominKeepEffectAnimation:tabBarSwappableImageViews index:index];
    //动画06-Lottie动画
//    [AnimationHelper lottieAnimation:currentTabBarSwappableImageView index:index];

}

/// 先放大，再缩小动画
/// @param animationView 动画视图
- (void)zoominTozoomoutAnimation:(UIView *)animationView {
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.2;       //执行时间
    animation.repeatCount = 1;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:0.7];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
    [animationView.layer addAnimation:animation forKey:nil];
}




- (void)setScreenBtn
{
    
    self.kfOpenBtn = [UIButton buttonWithNormalImage:@"icon_mine_2" selectedImage:@"icon_mine_2" superView:self.view btnClick:^(UIButton *btn) {
        [QYCommonFuncation shouKefu];
    }];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.kfOpenBtn addGestureRecognizer:panGes];
    self.kfOpenBtn.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 200, 40, 40);
    self.kfOpenBtn.cornerRadius = 20;
    self.kfOpenBtn.backgroundColor = [[UIColor appThemeColor] colorWithAlphaComponent:0.1];
    self.kfOpenBtn.borderColor = [ UIColor appThemeColor];
    self.kfOpenBtn.borderWidth = 1;
    
    
    
    self.gwOpenBtn = [UIButton buttonWithNormalImage:@"icon_mine_4" selectedImage:@"icon_mine_4" superView:self.view btnClick:^(UIButton *btn) {
        [YQUtils openUrl:[YQUserModel shared].user.web];
    }];
    
    UIPanGestureRecognizer *panGes2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.gwOpenBtn addGestureRecognizer:panGes2];
    self.gwOpenBtn.frame = CGRectMake(ScreenWidth - 50, ScreenHeight - 250, 40, 40);
    self.gwOpenBtn.cornerRadius = 20;
    self.gwOpenBtn.backgroundColor = [[UIColor appThemeColor] colorWithAlphaComponent:0.1];
    self.gwOpenBtn.borderColor = [ UIColor appThemeColor];
    self.gwOpenBtn.borderWidth = 1;
    
    
}





- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint trans = [sender translationInView:self.view];
        UIView *view = sender.view;
        CGFloat y = view.center.y+trans.y;
        if (y < PUB_NAVBAR_HEIGHT + 70) {
            y = PUB_NAVBAR_HEIGHT + 70;
        }
        
        if (y > ScreenHeight- PUB_TABBAR_HEIGHT - 30) {
            y = ScreenHeight- PUB_TABBAR_HEIGHT - 30;
        }
        CGFloat x = view.center.x+trans.x;

        view.center = CGPointMake(x,y);
        [sender setTranslation:CGPointZero inView:view];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded){
        
        CGPoint trans = [sender translationInView:self.view];
        UIView *view = sender.view;
        CGFloat y = view.center.y+trans.y;
        if (y < PUB_NAVBAR_HEIGHT + 70) {
            y = PUB_NAVBAR_HEIGHT + 70;
        }
        
        if (y > ScreenHeight- PUB_TABBAR_HEIGHT - 30) {
            y = ScreenHeight- PUB_TABBAR_HEIGHT - 30;
        }
        CGFloat x = view.center.x+trans.x;
        if (x >= ScreenWidth / 2.0){
            x = ScreenWidth - 30;
        }
        
        if (x < ScreenWidth / 2.0){
            x = 30;
        }

        view.center = CGPointMake(x,y);
        [sender setTranslation:CGPointZero inView:view];
        
    }
    
}



@end
