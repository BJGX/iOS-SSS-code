//
//  VFHomeVC.m
//  VFProject
//


//

#import "VFHomeVC.h"
#import "VFContactView.h"
#import "VFMineVC.h"
#import "VFMainServiceVC.h"
#import "VFGiftView.h"
#import <SDCycleScrollView.h>
#import "ZScrollLabel.h"
#import "VFTipsView.h"
#import "VFMainFeedBcakVC.h"
#import "VFHotVC.h"
#import "IAPManager.h"
//#import "LiquidGlassView.h"
//#import "UIView+LiquidGlass.h"
//#import "SSSVPN-Swift.h"
#import "CHGlassmorphismView.h"

@interface VFHomeVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *ipNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (nonatomic, strong) SDCycleScrollView *adView;

@property (nonatomic, strong) VFContactView *contactBtn;

@property (nonatomic, strong) UILabel *tipsLabel;

///定时任务
@property (nonatomic, strong) NSTimer *reloadTimer;

//@property (nonatomic, strong) LiquidGlassView *liquidGlassView;

@end

@implementation VFHomeVC



- (NSTimer *)reloadTimer {
    if (!_reloadTimer) {
        _reloadTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_reloadTimer forMode:NSRunLoopCommonModes];
    }
    return _reloadTimer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavigationBar:YES];
    
    [self.typeBtn setImage:[[UIImage imageNamed:@"icon_setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.typeBtn setTintColor:[UIColor whiteColor]];
    
    
    self.contactBtn = [VFContactView initView];
     
    CGFloat y = ScreenHeight <= 667 ? 0 : 30;
    self.contactBtn.frame = CGRectMake(0, CGRectGetMaxY(self.ipNameLabel.superview.frame)+y, ScreenWidth * 0.5, ScreenWidth * 0.5 + 50);
    self.contactBtn.centerX = ScreenWidth/2.0;
    WeakSelf;
    [self.contactBtn setStartAction:^{
        [weakSelf showHotView];
    }];
    [self.view addSubview:self.contactBtn];
    
    self.giftBtn.hidden = YES;
    if (![YQUserModel shared].user.isLogin) {
        [QYCommonFuncation loginWithTourist:^(NSInteger code) {
            [self LoginSuccesss];
            [self getUserData];
        }];
        
    }
    else{
        [self getUserData];
        [[IAPManager shared] startManager];
        [self getNoticeData];
        [self getBannerData];
        [self getNoticePop];
    }
    
    
    
    BOOL isFirstLoad = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstAppLoad"];
    if (!isFirstLoad) {
        [YQNetwork ReachabilityChanged:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
                [QYCommonFuncation loginWithTourist:^(NSInteger code) {
                    [self LoginSuccesss];
                    [self getUserData];
                }];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstAppLoad"];
            }
        }];
    }
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChooseModel) name:@"ChooseXianLu" object:nil];
    
    if ([QYSettingConfig shared].isPacType == 1) {
        [self.typeBtn setTitle:@" 智能加速".localized forState:0];
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.reloadTimer setFireDate:[NSDate distantPast]];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"LoginSuccesss" object:nil];
    
    
//    [self.contactBtn addLightGlassView:20 blurDensity:0.5 distance:0];
    
//    [[IAPManager shared] startManager];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[IAPManager shared] requestProductWithId:@"100100100"];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self liquidViewUI];
//    });
    
//    [self.contactBtn addLiquidGlassBackgroundWithYcornerRadius:20  blurScale:0 tintColor:[[UIColor systemGrayColor] colorWithAlphaComponent:0.2]];
//    
    
//    [self.contactBtn addLiquidGlassBackgroundWithYcornerRadius:20 updateMode:SnapshotUpdateModeContinuous continuousInterval:0.01 blurScale:0 tintColor:[[UIColor systemGrayColor] colorWithAlphaComponent:1]];
    
//    [self.contactBtn addLiquidGlassBackgroundWithYcornerRadius:20 updateMode:SnapshotUpdateModeContinuous continuousInterval:0.01 blurScale:0 tintColor:[UIColor systemGrayColor]];
//    UILabel *label = [UILabel ]
    
//    CHGlassmorphismView *testView = [[CHGlassmorphismView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
//    [testView setCornerRadius:20];
//    [testView setBlurDensityWithDensity:0.1];
//    [self.view addSubview:testView];
    
}


- (void)liquidViewUI
{
    // 创建背景视图 (内容会被折射)
//    ExampleViewController *vc = [[ExampleViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

}

// 按压手势响应
- (void)handlePress:(UILongPressGestureRecognizer *)gesture {
    
    
    
    
}

- (void)LoginSuccesss
{
    [[IAPManager shared] stopManager];
    [[IAPManager shared] startManager];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getNoticeData];
        [self getBannerData];
        [self getNoticePop];
    });
}


- (void)reloadChooseModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ipNameLabel.text = [YQUserModel shared].chooseModel.name;
        self.iconView.image = [VFHomeModel getFlagImage:[YQUserModel shared].chooseModel.name];
    });
    
    
}



- (void)getUserData
{
    
    if (![YQUserModel shared].user.isLogin) {

        return;
        
    }
    
    WeakSelf;
    [QYCommonFuncation getUserInfoWithString:@"正在加载" block:^(NSInteger code) {
        if (code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadUI];
            });
        }
    }];
}

- (void)reloadUI
{
    YQUserModel *user = [YQUserModel shared].user;

    if (user.vip < 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"剩余%ld分钟", user.vip];
    }
    else if (user.vip < 60*24) {
        self.timeLabel.text = [NSString stringWithFormat:@"剩余%ld小时%ld分钟", user.vip/60, user.vip%60];
    }
    else{
        self.timeLabel.text = [NSString stringWithFormat:@"剩余%ld天%ld小时", user.vip/60/24, user.vip/60%24];
    }
    
    if ([YQUserModel shared].chooseModel == nil && [user.service.name length]) {
        self.ipNameLabel.text = user.service.name;
        self.iconView.image = [VFHomeModel getFlagImage:user.service.name];
        [QYCommonFuncation getServiceData:user.service.ID mainThird:NO];
    }
    
    if (user.vip <= 0) {
        [self.contactBtn closeVF];
    }
    
    
    self.giftBtn.hidden = NO;
    switch (user.gift_status) {
        case 1:
            self.giftBtn.enabled = YES;
            break;
        case 2:
            self.giftBtn.enabled = NO;
            break;
        default:
//            self.giftBtn.hidden = YES;
            break;
    }
}




//MARK: - Actions
//MARK: - 设置
- (IBAction)settingAction:(UIButton *)sender {
    
    
    VFMineVC *vc = [[VFMineVC alloc] init];
    YQNavigationController *nav = [[YQNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:nav animated:NO completion:nil];
}

//MARK: - 反馈
- (IBAction)feedbackAction:(UIButton *)sender {
    VFMainFeedBcakVC *vc = [VFMainFeedBcakVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK: - 切换模式
- (IBAction)typeAction:(UIButton *)sender {
    NSInteger oldIndex = [QYSettingConfig shared].isPacType;
    [YQAlert alertSheetViewController:nil sub:nil actionNames:@[@"全局加速",@"智能加速"] vc:self block:^(int index) {
        if (index == oldIndex) {
            return;
        }
        [QYSettingConfig shared].isPacType = index;
        if (index == 0) {
            [sender setTitle:@" 全局加速" forState:0];
        }
        else{
            [sender setTitle:@" 智能加速" forState:0];
        }
        
        if (self.contactBtn.type > 0) {
            [self.contactBtn closeVF];
            [self.contactBtn contactActionVF];
        }
        
        
        
    }];
}

//MARK: - 刷新
- (IBAction)refreshAction:(UIButton *)sender {

    
    if (![YQUserModel shared].user.isLogin) {

        return;
        
    }
//    sender.userInteractionEnabled = NO;
    
    WeakSelf;
    [QYCommonFuncation getUserInfoWithString:@"正在刷新" block:^(NSInteger code) {
        if (code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reloadUI];
//                sender.userInteractionEnabled = YES;
            });
        }
    }];
}

//MARK: - 礼物
- (IBAction)giftAction:(UIButton *)sender {
    [VFGiftView showView:^(NSInteger code) {
        if (code == 1) {
            [self getUserData];
//            sender.enabled = NO;
        }
    }];
}

//MARK: - 切换线路
- (IBAction)chooseIpAction:(UIButton *)sender {
    
    
    if (self.contactBtn.type > 0) {
        WeakSelf;
        [VFTipsView showView:@"已连接" content:@"如需切换线路, 请先断开当前连接" leftBtn:@"取消" rightBtn:@"断开后切换" block:^(NSInteger code) {
            if (code == 1) {
                [weakSelf.contactBtn closeVF];
                VFMainServiceVC *vc = [VFMainServiceVC new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    
    VFMainServiceVC *vc = [VFMainServiceVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)getNoticeData
{
    NSString *url = @"api/en/mine/notice";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            NSDictionary *dic = obj[@"data"];
            if ([dic isKindOfClass: [NSNull class]]) {
                return;
            }
            
            CGFloat y = ScreenHeight <= 667 ? 0 : 20;
            ZScrollLabel *z = [[ZScrollLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contactBtn.frame) +  y, ScreenWidth - 40, 30)];
            [self.view addSubview:z];
            z.textColor = [UIColor redColor];
            z.font = Font(15);
            z.scrollDuration = 13;
            z.text = obj[@"data"][@"content"];
        }
    }];

}

- (void)getNoticePop
{
    NSString *url = @"api/en/mine/notice-pop";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            VFHomeModel *model = [VFHomeModel mj_objectWithKeyValues:obj[@"data"]];
            if (model.times > 0) {
                [VFTipsView showView:model.title content:model.content leftBtn:nil rightBtn:@"我知道了" block:nil];
            }
        }
    }];

}


- (void)getBannerData
{
    NSString *url = @"api/en/mine/advertList";
    
    NSDictionary *dic = [YQCache getCache:url];
    if (dic) {
        VFHomeModel *model = [VFHomeModel mj_objectWithKeyValues:dic[@"data"]];
        [self reloadBannerUI:model];
    }
    
    
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [YQCache saveCache:obj key:@"api/en/mine/advertList"];
            VFHomeModel *model = [VFHomeModel mj_objectWithKeyValues:obj[@"data"]];
            [self reloadBannerUI:model];
        }
    }];
}

- (void)reloadBannerUI:(VFHomeModel *)model
{
    
    if (self.adView == nil) {
        self.adView = [SDCycleScrollView cycleScrollViewWithFrame:self.bannerView.bounds delegate:nil placeholderImage:[UIImage new]];
        self.adView.backgroundColor = [UIColor clearColor];
        [self.bannerView addSubview:self.adView];
        self.bannerView.cornerRadius = 10;
        
    }
    
    NSMutableArray *array = [NSMutableArray new];
    [model.banner enumerateObjectsUsingBlock:^(VFHomeModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.img];
    }];
    self.adView.imageURLStringsGroup = array;
    
    WeakSelf;
    [self.adView setClickItemOperationBlock:^(NSInteger currentIndex) {
        VFHomeModel *subModel = model.banner[currentIndex];
        if ([subModel.url isEqualToString:@"fengchi://m.booster.com/vip/vip"]) {
            weakSelf.tabBarController.selectedIndex = 1;
        }
        else if ([subModel.url isEqualToString:@"fengchi://m.booster.com/share/shareQr"]) {
            weakSelf.tabBarController.selectedIndex = 2;
        }
        else{
            [YQUtils openUrl:subModel.url];
        }
        
    }];
    
}




- (void)showHotView
{
 
//    if ([QYSettingConfig shared].isReview) {
//        return;
//    }
    
    if ([[QYSettingConfig shared] isShowTipsView] && [YQUserModel shared].user.hot_switch == 1) {
        VFHotVC *vc = [VFHotVC new];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }
}



@end
