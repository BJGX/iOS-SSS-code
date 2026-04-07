//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionView.h"
#import "TAPageControl.h"

static NSString *const kAppVersion = @"appVersion";

@interface LaunchIntroductionView ()<UIScrollViewDelegate>{
    UIScrollView  *launchScrollView;
    TAPageControl *page;
}

@end

@implementation LaunchIntroductionView
NSArray *images;
BOOL isScrollOut;//在最后一页再次滑动是否隐藏引导页
CGRect enterBtnFrame;
NSString *enterBtnImage;
static LaunchIntroductionView *launch = nil;
NSString *storyboard;
#pragma mark - 创建对象-->>不带button
+ (instancetype)sharedWithImages:(NSArray *)imageNames{
    images = imageNames;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 创建对象-->>带button
+ (instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，不带button
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames {
    images = imageNames;
    storyboard = storyboardName;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboard:(NSString *)storyboardName images:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    storyboard = storyboardName;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            [self addImages];
        }else{
            [self removeFromSuperview];
        }
    }
    return self;
}
#pragma mark - 判断是不是首次登录或者版本更新
- (BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion2 = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion2]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion2 forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        [self showLoginVC];
        return NO;
    }
}
#pragma mark - 添加引导页图片
- (void)addImages{
    [self createScrollView];
}
#pragma mark - 创建滚动视图
- (void)createScrollView{
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreen_width * images.count, kScreen_height);
    [self addSubview:launchScrollView];
    for (int i = 0; i < images.count; i ++) {
        NSString * imagePath = [[NSBundle mainBundle]pathForResource:images[i] ofType:nil];
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, kScreen_width,kScreen_height)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView.backgroundColor = [UIColor whiteColor];
        [launchScrollView addSubview:imageView];
        if (i == images.count - 1) {
            //判断要不要添加button
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideGuide)];
            [imageView addGestureRecognizer:tap];
        }
    }
    page = [[TAPageControl alloc] initWithFrame:CGRectMake(0, kScreen_height - 50, kScreen_width, 10)];
    page.numberOfPages = images.count;
    page.backgroundColor = [UIColor clearColor];
    page.currentPage = 0;
    page.dotImage = [UIImage imageNamed:@"img_tiaoman_qiehuan"];
    page.currentDotImage = [UIImage imageNamed:@"img_tiaoman_current"];
    page.dotSize = CGSizeMake(9, 9);
    [self addSubview:page];
}

- (void)hideGuide {
    [self hideGuidView];
}
#pragma mark - 进入按钮
- (void)enterBtnClick{
    [self hideGuidView];
}
#pragma mark - 隐藏引导页
- (void)hideGuidView{
    [self showLoginVC];
    [UIView animateWithDuration:0.5 animations:^{
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            
        });
    }];
}


- (void)showLoginVC
{
    if (![YQUserModel shared].user.isLogin) {
//        TBLoginMobileVC *vc = [[UIStoryboard storyboardWithName:@"TBLogin" bundle:nil] instantiateInitialViewController];
//        YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
//        [[YQUtils getCurrentVC] presentViewController:nav animated:YES completion:nil];
    }
}


#pragma mark - scrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
    if (cuttentIndex == images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        page.currentPage = cuttentIndex;
    }
}
#pragma mark - 判断滚动方向
- (BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - KVO监测值的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
        page.tintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
        page.dotColor = self.nomalColor;
    }
}

@end
