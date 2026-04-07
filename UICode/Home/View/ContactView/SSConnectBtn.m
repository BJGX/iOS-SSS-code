//
//  SSConnectBtn.m

//
//  Created by  on 2025/6/30.

//

#import "SSConnectBtn.h"
//#import <PotatsoLibrary/PotatsoLibrary-Swift.h>

#import "UIImageView+MXYImageView.h"
#import "VFGiftView.h"
#import "VFTipsView.h"
#import "UIView+CHGlassmorphismView.h"
#import "VFMainServiceVC.h"
#import "SSMainLineListVC.h"
#import "SeriverModel.h"
#import "FCSocket.h"

@interface SSConnectBtn()<SGPageTitleViewDelegate>
/// 连接相关
@property (weak, nonatomic) IBOutlet UIView *progressBackView;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

///背景图相关
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView3;

@property (weak, nonatomic) IBOutlet UIButton *globalBtn;
@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *seriverView;

@property (nonatomic, strong) SGPageTitleView *pageTitleView ;


///定时任务
@property (nonatomic, strong) NSTimer *reloadTimer;


@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) BOOL isGlobal;

@end


@implementation SSConnectBtn


- (NSTimer *)reloadTimer {
    if (!_reloadTimer) {
        _reloadTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadUserData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_reloadTimer forMode:NSRunLoopCommonModes];
    }
    return _reloadTimer;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVPNStatusChanged:) name:FCVPNManagerStatusDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChooseModel) name:@"ChooseXianLu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:@"LoginSuccesss" object:nil];
    self.isGlobal = YES;
//    [self initUI];
    
//    [self.progressBackView addLiquidGlassView:100 shadowIntensity:0.6 highlightIntensity:0.6];
    
    [self.progressBackView addLiquidGlassView:100 glassColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1] shadowColor:[[UIColor appThemeColor] colorWithAlphaComponent:0.1]];
    [self setTitleViewUI];
    [self getUserData];
    [self.reloadTimer setFireDate:[NSDate distantPast]];
    
    [[FCVPNManager sharedManager] setup];
    
    WeakSelf;
    [self.progressBackView addTapActionWithBlock:^(UIGestureRecognizer * _Nullable sender) {
        [weakSelf connectAction:nil];
    }];
    
    if ([FCVPNManager sharedManager].vpnStatus != FCVPNStatusOff) {
        [self reloadBtnStatus:[FCVPNManager sharedManager].vpnStatus];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVPNError:) name:FCVPNManagerErrorNotification object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.giftBtn removeFromSuperview];
        [self.superview addSubview:self.giftBtn];
        [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.superview);
            make.right.mas_equalTo(self.superview);
        }];
    });
}

- (void)onVPNError:(NSNotification *)sedner
{
    NSDictionary *dic = sedner.userInfo;
    NSError *error = dic[FCVPNManagerErrorKey];
    NSLog(@"onVPNError:%@", error);
    if (![error isKindOfClass:[NSError class]]) {
        [YQUtils showCenterMessage:@"VPN启动失败".localized];
        return;
    }

    NSString *message = error.localizedDescription.length > 0 ? error.localizedDescription : @"VPN启动失败".localized;
    [YQUtils showCenterMessage:message];
}

- (void)initUI
{
    BOOL isFirstLoad = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstAppLoad"];
    if (!isFirstLoad) {
        [YQNetwork ReachabilityChanged:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
                [QYCommonFuncation loginWithTourist:^(NSInteger code) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
                    [self getUserData];
                }];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstAppLoad"];
            }
        }];
    }
}



- (void)saveProxyData
{

    
    
    NSInteger time = [YQUtils currentTimeStamp] / 1000 + [YQUserModel shared].user.vip * 60;
    BOOL success = [[FCVPNManager sharedManager] setDefaultConfigWithURL: [YQUserModel shared].chooseModel.service_str time:time proxy:!self.isGlobal];
    
    if (success == NO) {
        [YQUtils showCenterMessage:@"该路线不支持"];
    }
    

}


- (void)reloadChooseModel
{
    dispatch_async(dispatch_get_main_queue(), ^{
                
        [self.serviceBtn setTitle:[YQUserModel shared].chooseModel.name forState:0] ;
        self.countryImageView.image = [VFHomeModel getFlagImage:[YQUserModel shared].chooseModel.name];
    });
    
    

    
    
}



- (void)getUserData
{
    
    if (![YQUserModel shared].user.isLogin) {

        return;
        
    }
    
    WeakSelf;
    [QYCommonFuncation getUserInfoWithString:@"正在加载".localized block:^(NSInteger code) {
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
        NSString *string = [NSString stringWithFormat:@"%@ % ld%@",@"剩余".localized,user.vip,@"分钟".localized];
        self.timeLabel.text = string;
    }
    else if (user.vip < 60*24) {
        NSString *string = [NSString stringWithFormat:@"%@ %ld%@%ld%@",@"剩余".localized,user.vip/60,@"小时".localized, user.vip%60,@"分钟".localized];
        self.timeLabel.text = string;
    }
    else{
        NSString *string = [NSString stringWithFormat:@"%@ %ld%@%ld%@",@"剩余".localized,user.vip/60/24,@"天".localized, user.vip/60%24,@"小时".localized];
        self.timeLabel.text = string;
    }
    
    if ([YQUserModel shared].chooseModel == nil) {
        [self.serviceBtn setTitle:@"请选择线路".localized forState:0] ;
        
//        [self.serviceBtn setTitle:user.service.name forState:0] ;
        self.countryImageView.image = [VFHomeModel getFlagImage:@""];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [QYCommonFuncation getServiceData:user.service.ID mainThird:NO];
        });
    }
//    else if ([YQUserModel shared].chooseModel) {
//        
//    }
    
    else {
        [self.serviceBtn setTitle:[YQUserModel shared].chooseModel.name forState:0] ;
        self.countryImageView.image = [VFHomeModel getFlagImage:[YQUserModel shared].chooseModel.name];
    }
    
    if (user.vip <= 0) {
        [[FCVPNManager sharedManager] stopVPN];
    }
    
    
    self.giftBtn.hidden = NO;
    switch (user.gift_status) {
        case 1:
            self.giftBtn.userInteractionEnabled = YES;
            self.giftBtn.alpha = 1;
            break;
        case 2:
            self.giftBtn.userInteractionEnabled = NO;
            self.giftBtn.alpha = 0.5;
            break;
        default:
            break;
    }
}





- (void)onVPNStatusChanged:(NSNotification *)sender
{
    NSInteger status = [sender.object integerValue];
    [self reloadBtnStatus:status];
}



- (IBAction)giftActiob:(UIButton *)sender {
    [VFGiftView showView:^(NSInteger code) {
        if (code == 1) {
            sender.userInteractionEnabled = NO;
            sender.alpha = 0.5;
            [self getUserData];
//            sender.enabled = NO;
        }
    }];
}

- (IBAction)refreshTimeAction:(UIButton *)sender {
    
    
    
    NSString *tips = nil;
    if (sender) {
        tips = @"正在刷新".localized;
    }
//
    if (![YQUserModel shared].user.isLogin) {

        return;
        
    }
    WeakSelf;
    [QYCommonFuncation getUserInfoWithString:tips block:^(NSInteger code) {
        if (code == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                YQUserModel *user = [YQUserModel shared].user;
                if (user.vip < 60) {
                    NSString *string = [NSString stringWithFormat:@"%@ % ld%@",@"剩余".localized,user.vip,@"分钟".localized];
                    weakSelf.timeLabel.text = string;
                }
                else if (user.vip < 60*24) {
                    NSString *string = [NSString stringWithFormat:@"%@ %ld%@%ld%@",@"剩余".localized,user.vip/60,@"小时".localized, user.vip%60,@"分钟".localized];
                    weakSelf.timeLabel.text = string;
                }
                else{
                    NSString *string = [NSString stringWithFormat:@"%@ %ld%@%ld%@",@"剩余".localized,user.vip/60/24,@"天".localized, user.vip/60%24,@"小时".localized];
                    weakSelf.timeLabel.text = string;
                }
                if (user.vip <= 0) {
                    [[FCVPNManager sharedManager] stopVPN];
                }
                
            });
        }
    }];
    
    
}
- (void)reloadUserData
{
    [self refreshTimeAction:nil];
}



- (IBAction)chooseServiceAction:(UIButton *)sender {
    
    
    
    if (self.status == 2) {
//        WeakSelf;
        [VFTipsView showView:@"提示".localized content:@"如需切换线路, 请先断开当前连接".localized leftBtn:@"取消".localized rightBtn:@"断开".localized block:^(NSInteger code) {
            if (code == 1) {
                [[FCVPNManager sharedManager] stopVPN];
//                [weakSelf.contactBtn closeVF];
//                VFMainServiceVC *vc = [VFMainServiceVC new];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
        return;
    }
    
    SSMainLineListVC *vc = [SSMainLineListVC new];
    [[YQUtils getCurrentVC].navigationController pushViewController:vc animated:YES];
    
    
}
- (IBAction)globalAction:(UIButton *)sender {
    
    
    //        let arr = [
//                "authscheme":"none",
//                "host":"5.199.130.48",
//                "obfs":"plain",
//                "obfs_param":"",
//                "ot_domain":"de1v3.dsjsapi.com",
//                "ot_enable": 1,
//                "ot_path":"/YThDuUzptCBx8UR7Wqv9/",
//                "ota": 0,
//                "password":"ClLqJtShwHMp",
//                "port": 443,
//                "protocol":"origin",
//                "protocol_param":"",
    //         ] as [String : Any]
    
    
    
    
    
}
- (IBAction)connectAction:(UIButton *)sender {
    
    YQUserModel *user = [YQUserModel shared].user;
    if (user.vip <= 0 && TEST_ING == false) {
        [YQUtils showCenterMessage:@"您的链接时间不足, 请充值".localized];
        return;
    }
    if ([YQUserModel shared].chooseModel == nil) {
        [YQUtils showCenterMessage:@"请选择线路".localized];
        return;
    }
//    [VPN switchVPN:nil isForce:false completion:^(NSError * _Nullable error) {
//    }];
    
    if ([FCVPNManager sharedManager].vpnStatus != FCVPNStatusON) {
        [self saveProxyData];
    }
    
    [[FCVPNManager sharedManager] switchVPNWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSString *message = error.localizedDescription.length > 0 ? error.localizedDescription : @"VPN启动失败".localized;
            [YQUtils showCenterMessage:message];
        }
    }];
//    [[FCVPNManager sharedManager] startVPN:@{} completeBlock:^(NSError * _Nonnull error) {
//            
//    }];
    
    
}


- (void)reloadBtnStatus:(NSInteger)status
{
    self.status = status;
    self.connectBtn.userInteractionEnabled = YES;
    if (status == 0) {
        self.statusLabel.text = @"未连接".localized;
        [self.connectBtn setTitle:@"一键加速".localized forState:0];
        [self.bgImageView3 stopRotate];
        [self.bgImageView2 stopRotate];
    }
    if (status == 1) {
        
        self.statusLabel.text = @"连接中".localized;
        [self.connectBtn setTitle:@"正在连接".localized forState:0];
        [self.bgImageView3 rotate360Degree:YES];
        [self.bgImageView2 rotate360Degree:YES];
        self.connectBtn.userInteractionEnabled = NO;
    }
    
    if (status == 2) {
        self.statusLabel.text = @"已连接".localized;
        [self.connectBtn setTitle:@"断开连接".localized forState:0];
        [self.bgImageView3 stopRotate];
        [self.bgImageView2 stopRotate];
    }
    
    if (status == 3) {
        self.statusLabel.text = @"断开中".localized;
        [self.connectBtn setTitle:@"正在断开".localized forState:0];
        [self.bgImageView3 rotate360Degree:YES];
        self.connectBtn.userInteractionEnabled = NO;
    }
    
    
    
}


- (void)setTitleViewUI
{
    SGPageTitleViewConfigure *pageConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    pageConfigure.titleSelectedColor = [UIColor whiteColor];
    pageConfigure.titleColor = [UIColor subTextColor];
    pageConfigure.indicatorColor = [UIColor appThemeColor];
    pageConfigure.titleFont = Font(16);
    pageConfigure.titleSelectedFont = [YQUtils systemMediumFontOfSize:16];
    pageConfigure.showBottomSeparator = NO;
    pageConfigure.indicatorStyle = SGIndicatorStyleCover;
//    pageConfigure.indicatorToBottomDistance = 5;
    pageConfigure.indicatorColor = [UIColor clearColor];
    pageConfigure.indicatorHeight = 40;
    pageConfigure.indicatorAdditionalWidth = 100;
//    pageConfigure.indicatorToBottomDistance = 2;
//    pageConfigure.indicatorCornerRadius = 2;
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake((ScreenWidth - 200) / 2.0, CGRectGetMaxY(self.progressBackView.frame) + 20, 200, 40) delegate:self titleNames:@[@"全局加速".localized,@"智能加速".localized] configure:pageConfigure];
    self.pageTitleView.backgroundColor = [UIColor subBackgroundColor];
    self.pageTitleView.cornerRadius = 12;
//    self.pageTitleView.borderColor = [UIColor appThemeColor];
   
    [self addSubview:self.pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.offset(200);
        make.height.offset(40);
        make.top.mas_equalTo(self.progressBackView.mas_bottom).offset(20);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pageTitleView.indicatorView addLiquidGlassView:12 glassColor:[[UIColor appThemeColor] colorWithAlphaComponent:0.8] shadowColor:[[UIColor appThemeColor] colorWithAlphaComponent:1]];
    });
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    self.isGlobal = selectedIndex == 0 ? YES : NO;
}



//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
//    if (self.touchAreaScale > 0) {
//        CGRect bounds = self.bounds;
//        CGFloat widthDelta = MAX(bounds.size.width * (self.touchAreaScale - 1), 0);
//        CGFloat heightDelta = MAX(bounds.size.height * (self.touchAreaScale - 1), 0);
//        bounds = CGRectInset(bounds, -widthDelta * 0.5, -heightDelta * 0.5);
//        return CGRectContainsPoint(bounds, point);
//    }
//    return [super pointInside:point withEvent:event];
//}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // 获取当前的缩放比例
    CGAffineTransform transform = self.transform;
    CGFloat scaleX = sqrt(transform.a * transform.a + transform.c * transform.c);
    CGFloat scaleY = sqrt(transform.b * transform.b + transform.d * transform.d);
    
    // 如果没有缩放，使用默认行为
    if (scaleX == 1.0 && scaleY == 1.0) {
        return [super pointInside:point withEvent:event];
    }
    
    // 将点击点转换到缩放前的坐标系
    CGPoint unscaledPoint = CGPointMake(point.x / scaleX, point.y / scaleY);
    
    // 检查是否有子视图能响应这个点
    for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
        CGPoint pointInSubview = [self convertPoint:unscaledPoint toView:subview];
        if ([subview pointInside:pointInSubview withEvent:event]) {
            return YES;
        }
    }
    
    // 如果没有子视图响应，检查点是否在原始边界内
    return CGRectContainsPoint(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), unscaledPoint);
}


@end
