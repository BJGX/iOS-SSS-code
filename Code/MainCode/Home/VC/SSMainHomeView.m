
#import "SSMainHomeView.h"
#import "VFGiftView.h"
#import "VFMainServiceVC.h"
#import "VFTipsView.h"
#import "VFMainFeedBcakVC.h"
#import "VFHotVC.h"
#import "IAPManager.h"
#import "SSConnectBtn.h"
#import <SDCycleScrollView.h>
#import "ZScrollLabel.h"
#import <SingBox/Mobile.objc.h>
//#import "CHGlassmorphismView.h"

@interface SSMainHomeView ()
@property (nonatomic, strong) SDCycleScrollView *adView;

@property (nonatomic, strong) SSConnectBtn *contactBtn;
@end

@implementation SSMainHomeView


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadFrame];
}


- (void)reloadFrame
{
    CGFloat y = 0;
    if (![DeviceHelper isiPhone]) {
        y+=40;
    }
    
    CGFloat Height = 102;
    CGFloat w = 350;
    if (ScreenWidth < ScreenHeight && [DeviceHelper isiPad]) {
        w = ScreenWidth - 24;
        Height = w * 102 / 350.0;
    }
    
    self.adView.frame = CGRectMake((ScreenWidth - w)/2.0, PUB_NAVBAR_HEIGHT + 12 +y, w, Height);
    
    y += (Height + PUB_NAVBAR_HEIGHT + 34);
    self.contactBtn.frame = CGRectMake(0, y, ScreenWidth, 375);
}

- (void)updateLayoutForNewSize
{
    [self reloadFrame];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor backGroundColor];
    
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"icon_h_logo"];
    [self.navigationBar addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navigationBar);
        make.centerY.mas_equalTo(self.navigationBar.navTitleLabel);
    }];
    
//    [self getBannerData];
    
    
    CGFloat top = 0;
    
        if (![DeviceHelper isiPhone]) {
        top = 40;
        self.navigationBar.mj_y = top;
    }
    
    
    
    self.contactBtn = [[NSBundle mainBundle] loadNibNamed:SSConnectBtn.className owner:nil options:nil].firstObject;
    self.contactBtn.backgroundColor = [UIColor backGroundColor];
    
    
    CGFloat Height = 102;
    CGFloat w = 350;
    if (ScreenWidth < ScreenHeight && [DeviceHelper isiPad]) {
        w = ScreenWidth - 24;
        Height = w * 102 / 350.0;
    }
    
    CGFloat y = Height + PUB_NAVBAR_HEIGHT + 34 + top;
    self.contactBtn.frame = CGRectMake(0, y, ScreenWidth, 375);
    [self.view addSubview:self.contactBtn];
    
    
    if ([DeviceHelper isiPad]) {
        
        CGFloat w = ScreenWidth > ScreenHeight ? ScreenHeight : ScreenWidth;
        CGFloat scale = w / 820;
        self.contactBtn.transform = CGAffineTransformMakeScale(scale+0.3, scale+0.3);
        self.contactBtn.mj_y = y;
        self.contactBtn.touchAreaScale = scale+0.3;

    }
    
    
    [self hiddenNavigationBarLeftButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccesss) name:@"LoginSuccesss" object:nil];
    
    UIButton *rightBtn = [UIButton buttonWithNormalImage:@"icon_kefu" selectedImage:@"icon_kefu" superView:self.navigationBar btnClick:^(UIButton *btn) {
        VFMainFeedBcakVC *vc = [VFMainFeedBcakVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [rightBtn setTitle:@"工单反馈".localized forState:0];
    [rightBtn setTitleColor:[UIColor mainTextColor] forState:0];
    rightBtn.titleLabel.font = Font(14);
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(70);
        make.height.offset(35);
        make.centerY.mas_equalTo(self.navigationBar.navTitleLabel);
    }];
    [rightBtn layoutIfNeeded];
    rightBtn.upImageAndDownLableWithSpace = 5;
    [rightBtn sizeToFit];
    if ([YQUserModel shared].user.isLogin) {
        [self LoginSuccesss];
    }
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    WeakSelf;
    UIButton *LanguageBtn = [UIButton buttonWithNormalImage:@"icon_language_cn".localized selectedImage:@"icon_language_cn".localized superView:self.navigationBar btnClick:^(UIButton *btn) {
        [weakSelf changedLanguage];
    }];
    
    
//    [UIButton buttonWithNormalImage:@"icon_language_en".localized selectedImage:@"icon_language_en".localized superView:self.navigationBar btnClick:^(UIButton *btn) {
//        *btn) {
//            
//    }];
    
    
//    icon_language_cn
//    [UIButton buttonWithTitle:@"语言" titleColor:[UIColor mainTextColor] font:Font(15) backgroundColor:[UIColor clearColor] superView:self.navigationBar btnClick:^(UIButton
//    }];
    [LanguageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.width.offset(35);
        make.centerY.mas_equalTo(self.navigationBar.navTitleLabel);
    }];
    
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [YQNetwork foundHost];
        [YQNetwork testPing:nil];
    });
    
    
}

- (void)changedLanguage
{
    LanguageType type = [NPLanguageTool shared].languageType;
    
    NSString *info = @"Do you want to switch the language to chinese";
    if (type == LanguageTypeChinese) {
        info = @"是否切换语言为英文";
    }
    [VFTipsView showView:@"提示" content:info leftBtn:@"取消" rightBtn:@"确认" block:^(NSInteger code) {
        if (code == 1) {
//                [weakSelf hiddenAnimation];
            [[NPLanguageTool shared] setLanguage:type == LanguageTypeEnglish ? LanguageTypeChinese : LanguageTypeEnglish];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"switchLanguage" object:nil];
            
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
        
        CGFloat y = 0;
        if (![DeviceHelper isiPhone]) {
            y+=40;
        }
        
        
        CGFloat Height = 102;
        CGFloat w = 350;
        if (ScreenWidth < ScreenHeight) {
            w = ScreenWidth - 24;
            Height = w * 102 / 350.0;
        }

        
        self.adView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake((ScreenWidth - w)/2.0, PUB_NAVBAR_HEIGHT + 12 +y, w, Height) delegate:nil placeholderImage:[UIImage new]];
        self.adView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.adView];
        self.adView.cornerRadius = 10;
        
    }
    
    NSMutableArray *array = [NSMutableArray new];
    [model.banner enumerateObjectsUsingBlock:^(VFHomeModel  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.img];
    }];
    self.adView.imageURLStringsGroup = array;
    
    WeakSelf;
    [self.adView setClickItemOperationBlock:^(NSInteger currentIndex) {
        VFHomeModel *subModel = model.banner[currentIndex];
        if ([subModel.url isEqualToString:@"xinghuan://tab1"]) {
            weakSelf.tabBarController.selectedIndex = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTabbarIndex" object:@(1)];
        }
        else if ([subModel.url isEqualToString:@"xinghuan://tab2"]) {
            weakSelf.tabBarController.selectedIndex = 2;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedTabbarIndex" object:@(2)];
        }
        else{
            [YQUtils openUrl:subModel.url];
        }
        
    }];
    
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


- (void)getNoticeData
{
    NSString *url = @"api/en/mine/notice";
    [YQNetwork requestMode:POST tailUrl:url params:nil showLoadString:nil andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            VFHomeModel *model = [VFHomeModel mj_objectWithKeyValues:obj[@"data"]];
            if (model.content.length > 0) {
                CGFloat y = ScreenHeight <= 667 ? 0 : 20;
                ZScrollLabel *z = [[ZScrollLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contactBtn.frame) +  y, ScreenWidth - 40, 30)];
                [self.view addSubview:z];
                z.textColor = [UIColor redColor];
                z.font = Font(15);
                z.scrollDuration = 13;
                z.text = obj[@"data"][@"content"];
            }
            
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
