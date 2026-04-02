//
//   QYSettingConfig.m
   

#import "QYSettingConfig.h"
//#import <WXApi.h>
#import "YQCache.h"
#import "SSSVPN-Swift.h"
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface QYSettingConfig()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger addTimer;
@end

@implementation QYSettingConfig

+ (QYSettingConfig*)shared{
    static dispatch_once_t pred;
    static QYSettingConfig *instance;
    dispatch_once(&pred, ^{
        instance = [[QYSettingConfig alloc] init];
        
        if (@available(iOS 13.0, *)) {
            instance.statusBarHeight = [UIApplication sharedApplication].windows.lastObject.windowScene.statusBarManager.statusBarFrame.size.height;;
        }
        else{
            instance.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        instance.openTipsType = [[YQCache getDataFromPlist:@"openTipsType"] integerValue];
        instance.isPacType = [[YQCache getDataFromPlist:@"isPacType"] integerValue];
    });
    return instance;
}

- (NSString *)collectString
{
    if (_collectString == nil) {
        _collectString = [YQCache getDataFromPlist:@"CollectServiceList"] ?: @"";
    }
    return _collectString;
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginCountDown) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)setCountDown:(int)countDown {
    _countDown = countDown;
    if (countDown > 0) {
        self.addTimer = -1;
        [self.timer setFireDate:[NSDate distantPast]];
    }
    if (countDown==-1) {
        _countDown = 0;
        self.addTimer = 1;
        [self.timer setFireDate:[NSDate distantPast]];
    }
    
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
    _countDown = 0;
}

- (void)beginCountDown
{
    _countDown += self.addTimer;
    if (self.blockCountDown) {
        self.blockCountDown(_countDown);
    }
    if (_countDown == 0) {
        [self stopTimer];
    }
}


- (void)setInNightMode:(BOOL)inNightMode
{
    _inNightMode = inNightMode;
    
    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    NSString *inNightModeSting = inNightMode == NO ? @"Day" : @"Night";
    NSInteger index = inNightMode == NO ? 0 : 1;
    [YQCache saveDataToPlist:@(index) key:@"inNightMode"];

    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle style = inNightMode
                ? UIUserInterfaceStyleDark
                : UIUserInterfaceStyleLight;

            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive &&
                    [scene isKindOfClass:[UIWindowScene class]]) {

                    UIWindowScene *windowScene = (UIWindowScene *)scene;
                    for (UIWindow *window in windowScene.windows) {
                        window.overrideUserInterfaceStyle = style;
                    }
                }
            }
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTabbar" object:nil];
}

- (void)setOpenTipsType:(NSInteger)openTipsType
{
    _openTipsType = openTipsType;
    NSInteger time = [YQUtils currentTimeStamp];
    [YQCache saveDataToPlist:@(time) key:@"SaveTipsTime"];
    [YQCache saveDataToPlist:@(openTipsType) key:@"openTipsType"];
}

- (BOOL)isShowTipsView
{
    
    if (self.openTipsType == 0) {
        return  YES;
    }
    
    NSInteger time = [YQUtils currentTimeStamp];
    NSInteger time2 = [[YQCache getDataFromPlist:@"SaveTipsTime"] integerValue];
    
    NSInteger count = time - time2;
    NSInteger day = 60*60*24;
    if (self.openTipsType == 1 && count/day<1) {
        return NO;
    }
    
    if (self.openTipsType == 2 && count/day/7<1) {
        return NO;
    }
    
    if (self.openTipsType == 3 && count/day/365<1) {
        return NO;
    }
    
    
    return YES;
}

- (void)setIsPacType:(NSInteger)isPacType
{
    _isPacType = isPacType;
    [YQCache saveDataToPlist:@(isPacType) key:@"isPacType"];
    
}



- (NSString *)openString
{
    if (self.openTipsType == 3) {
        return @"关闭";
    }
    if (self.openTipsType == 2) {
        return @"关闭一周";
    }
    if (self.openTipsType == 1) {
        return @"关闭一天";
    }
    return @"打开";
}




@end
