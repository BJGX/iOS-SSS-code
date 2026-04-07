//
//  VFContactView.m
//  VFProject
//


//

#import "VFContactView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+MXYImageView.h"
//#import "VFTestManger.h"
#import <WebKit/WebKit.h>
#import "SeriverModel.h"
#import "VFAES.h"


#define ShadowPortKey @"ShadowPort"


@interface VFContactView()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *contactBgView1;
@property (weak, nonatomic) IBOutlet UIImageView *contactBgView2;
@property (weak, nonatomic) IBOutlet UIImageView *contactBgView3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;



@property (nonatomic, strong) WKWebView *webView;






//MARK: - proxy
// PLAYER TO PLAY SILENCE IN BACKGROUND
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;


@property (nonatomic, assign) NSInteger pingTime;


@end

@implementation VFContactView

+ (void)closeVPN
{
//    [[VPNHelper shared] closeWithCompletion:^{
//            
//    }];
//
    [[QYSettingConfig shared] stopTimer];
    
    
}

+ (instancetype)initView
{
    return [[NSBundle mainBundle] loadNibNamed:VFContactView.className owner:nil options:nil].firstObject;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
//    // INIT AUDIO PLAYER, LOAD SOUND AS DATA (USE RAM FOR SPEED, FILE IS SUPER TINY)

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"silence" ofType:@"wav"]]
                                                  fileTypeHint:AVFileTypeWAVE
                                                         error:nil];
        // SET INFINITE LOOP
        self.audioPlayer.numberOfLoops = -1;
        // SET TO MUTE
        self.audioPlayer.volume = 0.00;
        
        [self.audioPlayer prepareToPlay];
        
//        [[VPNHelper shared] starProxy];
    });
    
//    [[VPNHelper shared] closeWithCompletion:^{
//            
//    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChooseModel) name:@"ChooseXianLu" object:nil];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            
//            startShadowsocks("127.0.0.1:1087", "mk1ghk002.fengchijs.info", "5995", "aes-256-gcm", "b4fd650c411a", "v2ray-plugin", "tls;path=/nbqjklsgtkm;host=mk1ghk002.fengchijs.info", false, "");
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                stopShadowsocksGo();
//                NSLog(@"============关闭===========");
//            });

        });
    });
    
}




- (void)reloadChooseModel
{
//    [self closeVF];
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        [self startV2Ray];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            stopShadowsocksGo();
//        });
//    });
    
    if (self.type >= 2) {
//        [self closeVF];
        [self contactActionVF];
    }
}


- (IBAction)contactAction:(UIButton *)sender {
    
    
    [self contactActionVF];
    
    if (self.type == 0) {
        
        if ([YQUserModel shared].user.vip <= 0 && ![QYSettingConfig shared].isReview) {
            [YQUtils showCenterMessage:@"您的VIP已过期, 请充值"];
            return;
        }
        
        self.type = 1;
        [self contactActionVF];
    }
    if (self.type == 2) {
        self.type = 0;
        [self closeVF];
//        stopShadowsocksGo();
    }
}

- (void)setType:(NSInteger)type
{
    _type = type;
    
    [self.contactBgView1 stopRotate];
    [self.contactBgView2 stopRotate];
    [self.contactBgView3 stopRotate];
    self.timeLabel.hidden = YES;
    self.contactBtn.userInteractionEnabled = YES;
    
    switch (type) {
        case 1:
            [self contactingType];
            break;
        case 3:
            [self contactingType];
            break;
        case 2:
            [self contactCompleteType];
            break;
            
        default:
            [self normalType];
            break;
    }
}

- (void)normalType
{
    self.contactBgView1.highlighted = NO;
    self.contactBgView2.highlighted = NO;
    self.contactBgView3.highlighted = NO;
    self.stateLabel.text = @"尚未连接";
    [self.contactBtn setTitle:@"点击连接" forState:0];
}

- (void)contactingType
{
    self.contactBgView1.highlighted = NO;
    self.contactBgView2.highlighted = YES;
    self.contactBgView3.highlighted = YES;
    
    [self.contactBgView1 rotate360Degree:YES];
    [self.contactBgView2 rotate360Degree:NO];
    [self.contactBgView3 rotate360Degree:YES];
    self.stateLabel.text = @"连接中";
    
    self.contactBtn.userInteractionEnabled = NO;
    [self.contactBtn setTitle:@"正在连接" forState:0];
    
}

- (void)contactCompleteType
{
    self.contactBgView1.highlighted = YES;
    self.contactBgView2.highlighted = NO;
    self.contactBgView3.highlighted = NO;
    self.stateLabel.text = @"已连接";
    [self.contactBtn setTitle:@"点击断开" forState:0];
    self.timeLabel.hidden = NO;
    
    [[QYSettingConfig shared] setBlockCountDown:^(int count) {
        self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", count / 60 / 60, count / 60, count % 60];
        NSLog(@"time:%d",count);
        if ([YQUserModel shared].user.vip <= 0) {
            [YQUtils showCenterMessage:@"您的VIP已过期, 请充值"];
            
            self.type = 0;
            [self closeVF];
        }
        
        //
//        {
//            authscheme = "chacha20-ietf-poly1305";
//            host = "ssrr.chilines.me";
//            obfs = "tls1.2_ticket_auth";
//            "obfs_param" = "";
//            "ot_domain" = "ssrr.chilines.me";
//            "ot_enable" = 1;
//            "ot_path" = "/5mhk8LPOzXvjlAut/";
//            ota = 0;
//            password = ZpQaGb3trPHrcNtg;
//            port = 443;
//            protocol = "auth_aes128_md5";
//            "protocol_param" = "";
//        }
        
    }];
    [QYSettingConfig shared].countDown = -1;
}


- (void)backMusicModeAction:(BOOL)play
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    if (play) {
        [self.audioPlayer play];
    }
    else{
        [self.audioPlayer stop];
    }
}

- (void)contactActionVF
{
//    if ([[YQUserModel shared].user.service.ID length]  && [YQUserModel shared].chooseModel == nil) {
//        self.type = 3;
//        [QYCommonFuncation getServiceData:[YQUserModel shared].user.service.ID mainThird:NO];
//        
//        return;
//        
//    }
//    
//    
//    
//    else if ([YQUserModel shared].chooseModel == nil) {
//        self.type = 0;
//        [YQUtils showCenterMessage:@"请先选择路线"];
//        return;
//    }
    
    if (TEST_ING) {
        YQBaseModel *model = [YQBaseModel new];
          model.service_str = @"ssr://dHdiYW9mdjEuM2NpLnh5ejoyOTMwMTpvcmlnaW46bm9uZTpwbGFpbjpkVEZ5VWxkVWMzTk9kakJ3Lz9vYmZzcGFyYW09JnByb3RvcGFyYW09JnJlbWFya3M9ZEhkaVlXOW1kakV1TTJOcExuaDVlZyZncm91cD0mb3RfZW5hYmxlPTEmb3RfZG9tYWluPWRIZGlZVzltZGpFdU0yTnBMbmg1ZWcmb3RfcGF0aD1ZbUZ2WmkxdVp5MXFkQzE0Y0E";
        model.param_s = [VFAES aesDecrypt:model.service_str];
        [YQUserModel shared].chooseModel = model;
    }
    
    

//    [YQNetwork shared].pingCount = self.pingTime;
    [YQNetwork shared].pingCount = 1;
//    [self startV2Ray];
    
//    model.service_str = @"ssr://dHdiYW9mdjEuM2NpLnh5ejoyOTMwMTpvcmlnaW46bm9uZTpwbGFpbjpkVEZ5VWxkVWMzTk9kakJ3Lz9vYmZzcGFyYW09JnByb3RvcGFyYW09JnJlbWFya3M9ZEhkaVlXOW1kakV1TTJOcExuaDVlZyZncm91cD0mb3RfZW5hYmxlPTEmb3RfZG9tYWluPWRIZGlZVzltZGpFdU0yTnBMbmg1ZWcmb3RfcGF0aD1ZbUZ2WmkxdVp5MXFkQzE0Y0E";
    NSDictionary *param = @{
        @"authscheme":@"none",
        @"host": @"twbaofv1.3ci.xyz",
        @"obfs": @"plain",
        @"obfs_param": @"",
        @"ot_domain": @"twbaofv1.3ci.xyz",
        @"ot_enable": @1,
        @"ot_path": @"/YmFvZi1uZy1qdC14cA/",
        @"ota": @0,
        @"password": @"u1rRWTssNv0p",
        @"port": @29301,
        @"protocol": @"origin",
        @"protocol_param": @"",
    };
    
//    
//    NSDictionary *dic = [YQUserModel shared].chooseModel.param_s;
//    SeriverModel *model = [SeriverModel mj_objectWithKeyValues:dic];
//    NSDictionary *param = @{
//        @"authscheme":model.authscheme,
//        @"host": model.host,
//        @"obfs": model.obfs,
//        @"obfs_param": model.obfs_param,
//        @"ot_domain": model.ot_domain,
//        @"ot_enable": @(model.ot_enable),
//        @"ot_path": model.ot_path,
//        @"ota": @(model.ota),
//        @"password": model.password,
//        @"port": @(model.port),
//        @"protocol": model.protocol,
//        @"protocol_param": model.protocol_param,
//    };
//    

    
    WeakSelf;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        NSString *localPorts = @"123";
//        NSString *localPorts = [VFTestManger startSS];
//
//        NSString *ip = self.pingTime > 2 ? @"mk1ghk002.fengchijs.info" :  [YQUserModel shared].chooseModel.ip;
        
        NSString *ip = [YQUserModel shared].chooseModel.ip;
        
//        NSString *ip = @"wxw1000musliness009.chilines.xyz";
//        [[VPNHelper shared] openWith:ip pacType:[QYSettingConfig shared].isPacType == 1 ? NO : YES param:param completion:^(NSError * _Nullable error) {
//            NSLog(@"error======%@", error);
//            if (error == nil) {
////                self.type = 2;
//                self.stateLabel.text = @"插件启动中";
//                
//                
////                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
//                
////                [self testPing];
//                
//                
//            }
//            else{
//                [[QYSettingConfig shared]  stopTimer];
//                weakSelf.type = 0;
//            }
//            
//        }];
    }];
}

- (void)closeVF
{
    
    [YQNetwork shared].pingCount = 0;
    if (self.type > 1) {
//        stopShadowsocksGo();
    }
    
    self.type = 0;
    [self backMusicModeAction:NO];
    [VFContactView closeVPN];
    [[QYSettingConfig shared] stopTimer];
}


- (void)startV2Ray
{
    
    
//    if (self.pingTime > 2) {
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//            startShadowsocks("127.0.0.1:1087", "mk1ghk002.fengchijs.info", "5995", "aes-256-gcm", "b4fd650c411a", "v2ray-plugin", "tls;path=/nbqjklsgtkm;host=mk1ghk002.fengchijs.info", false, "");
//
//        });
//
//        return;
//    }
    
//    [VFTestManger startV2ray];
//    [self startV2Plugin];
//    return;
    NSString *sting = [NSString stringWithFormat:@"%@:%@",@"127.0.0.1", @"1087"];
    char *temp = (char *)[sting cStringUsingEncoding:NSUTF8StringEncoding];

//
    YQBaseModel *model = [YQUserModel shared].chooseModel;

    char *addr = (char *)[model.ip cStringUsingEncoding:NSUTF8StringEncoding];

    char *port = (char *)[model.port cStringUsingEncoding:NSUTF8StringEncoding];
    char *encryption = (char *)[model.encryption cStringUsingEncoding:NSUTF8StringEncoding];
    char *password = (char *)[model.password cStringUsingEncoding:NSUTF8StringEncoding];
    
//    NSArray *array = [model.plugin_options componentsSeparatedByString:@";"];
//    if (array.count == 3) {
//        NSString *s = array[1];
//        NSString *r = [NSString stringWithFormat:@"%@;",s];
//        model.plugin_options = [model.plugin_options stringByReplacingOccurrencesOfString:r withString:@""];
//    }
//
    char *plugin_options = (char *)[model.plugin_options cStringUsingEncoding:NSUTF8StringEncoding];
    char *plugin = (char *)[model.plugin cStringUsingEncoding:NSUTF8StringEncoding];


    
    

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

//        startShadowsocks(temp, addr, port, encryption, password, plugin, plugin_options, false, addr);
//       char *newPort = startShadowsocks(temp, addr, port, encryption, password, plugin, plugin_options, true, "");
        
//        startShadowsocksv2(temp, addr, port, encryption, password, plugin, plugin_options, true, "newPort");
//
//        startV2rayShadowsocks("newPort", addr, port, plugin_options);

    });
//
    
//    if (self.webView == nil) {
//        WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(-100, 100, 400, 800)];
//        [self addSubview:web];
//        web.hidden = YES;
////        web.UIDelegate = self;
//        web.navigationDelegate = self;
//        self.webView = web;
//    }
    
}


- (void)testPing
{
    
    
//    [self startV2Ray];
//    return;
    self.stateLabel.text = @"正在连接网络";
    
    [YQNetwork testPing:^(id obj, NSInteger code) {

        if (code == 1 && self.type == 1) {
            [YQCache saveCache:obj[@"data"] key:@"api/en/mine/hot"];
            [[QYSettingConfig shared] stopTimer];
            self.type = 2;
            if (self.startAction) {
                self.startAction();
                [self backMusicModeAction:YES];
            }
        }
    }];
    WeakSelf;
    [[QYSettingConfig shared] setBlockCountDown:^(int count) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.stateLabel.text = [NSString stringWithFormat:@"正在连接网络 (%ds)",count];
        });
        
        
        NSLog(@"cout === %d", count);
        if (count == 0 && self.type != 2) {
            
//                exit(1);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf closeVF];
//                    stopShadowsocksGo();
                [YQAlert alertMessageOneAction:@"连接失败,是否重试" sub:nil leftName:@"稍后" rightName:@"重试" vc:nil rightBlock:^{
                    [[QYSettingConfig shared] stopTimer];
                    weakSelf.type = 1;
                    [weakSelf contactActionVF];
                }];
            });
        }
    }];
    
    [QYSettingConfig shared].countDown = 20;
    

}

@end
