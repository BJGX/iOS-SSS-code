//
//  VFLoginVC.m
//  VFProject
//


//

#import "VFLoginVC.h"
#import "HandleSignInWithAppleModel.h"
#import "VFMobileLoginVC.h"
#import "SGPagingView.h"
#import "UIView+LiquidGlass.h"
#import "UITextField+AreaCode.h"

@interface VFLoginVC ()<SGPageTitleViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *kfBtn;

@property (nonatomic, strong) SGPageTitleView *pageTitleView;

@end

@implementation VFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (TEST_ING) {
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isDebugEnvironment)];
//        tap.numberOfTapsRequired = 5;
//        [self.view addGestureRecognizer:tap];
//    }
//    self.view.backgroundColor = [UIColor mainTextColor];
    
    self.navTitle = @"登录";
    [self hiddenNavigationBarLeftButton];
    [self.numberTF setPlaceholderColor];
    [self.numberTF addCountryCodePicker];
    [self.passwordTF setPlaceholderColor];
    WeakSelf;
    [self.numberTF yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        if (textField.text.length >= 11 && weakSelf.pageTitleView.signBtnIndex == 0) {
            textField.text =  [textField.text substringToIndex:11];
        }
    }];
    CGRect frame = CGRectMake(20, CGRectGetMaxY(self.loginBtn.frame)+80, ScreenWidth - 40, 40);
    [self.codeLoginBtn addLightGlassView:12 blurDensity:1 distance:3];
    [self.kfBtn addLightGlassView:6 blurDensity:1 distance:3];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.codeLoginBtn addLiquidGlassBackgroundWithYcornerRadius:8 updateMode:SnapshotUpdateModeContinuous continuousInterval:0.016 blurScale:0 tintColor:[UIColor subBackgroundColor]];
//    });
    if (![DeviceHelper isiPadOnMac]) {
        [HandleSignInWithAppleModel signInWithAppleWithButtonRect:frame withSupView:self.backView success:^(ASAuthorization * _Nonnull authorization) {
            if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
                //
                ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
                NSString *userID = appleIDCredential.user;
                [self loginWithApple:userID];
                
                //                [weakSelf appleIDLoginWithUserID:userID AuthCode:authoCode AuthToken:identityToken];
            }
        } failure:^(NSError * _Nonnull err) {
            
        }];
    }
    [self setTitleViewUI];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [self.kfBtn addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}


- (void)move:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self.view];
    CGPoint _originalCenter = self.kfBtn.center;
    CGPoint newCenter = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y + translation.y);
    self.kfBtn.center = newCenter;
    [sender setTranslation:CGPointZero inView:self.view];
}

- (void)isDebugEnvironment
{
    BOOL isDebugEnvironment = [[NSUserDefaults standardUserDefaults] boolForKey:@"isDebugEnvironment"];
    NSString *title = isDebugEnvironment ? @"切换到正式服": @"切换到测试服";
    [YQAlert alertMessageOneAction:title sub:nil leftName:@"取消" rightName:@"切换" vc:self rightBlock:^{
        BOOL d = !isDebugEnvironment;
        [[NSUserDefaults standardUserDefaults] setBool:d forKey:@"isDebugEnvironment"];
    }];
}



- (IBAction)loginAction:(UIButton *)sender {
    
    if (self.numberTF.text.length != 11 && self.pageTitleView.signBtnIndex == 0) {
        [YQUtils showCenterMessage:@"请输入正确的手机号"];
        return;
    }
    
    
    if (![self.numberTF.text containsString:@"@"] && self.pageTitleView.signBtnIndex == 1) {
        [YQUtils showCenterMessage:@"请输入正确的邮箱"];
        return;
    }
    if (self.passwordTF.text.length < 6 && self.passwordTF.text.length > 11) {
        [YQUtils showCenterMessage:@"请输入6-11位密码"];
        return;
    }

    [self.view endEditing:YES];

    NSString *url = @"api/en/user/login";
    NSString *type = self.pageTitleView.signBtnIndex == 0 ? @"phone" : @"mail";
    NSDictionary *dic = @{type:self.numberTF.text,
                          @"password":self.passwordTF.text,
    };

    NSString *tips = @"正在登录";
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:tips andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            YQUserModel *user= [YQUserModel shared].user;
            if (user == nil) {
                user = [[YQUserModel alloc] init];
            }
            user.token = obj[@"data"][@"token"];
            user.isLogin = YES;
            [YQUserModel shared].user = user;
            
            [QYCommonFuncation getUserInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
        }
    
    }];
    
    
}
- (IBAction)otherLoginAction:(UIButton *)sender {
    VFMobileLoginVC *vc = (VFMobileLoginVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFMobileLoginVC"];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)youkeLoginAction:(UIButton *)sender {
    [self loginWithApple:nil];
}

- (IBAction)forgetAction:(UIButton *)sender {
    VFMobileLoginVC *vc = (VFMobileLoginVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFMobileLoginVC"];
    vc.type = 4;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)kefuAction:(UIButton *)sender {
    [QYCommonFuncation shouKefu];
}


- (void)loginWithApple:(NSString *)uid
{
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
            [QYCommonFuncation getUserInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
        }
        
    }];
}


- (void)setTitleViewUI
{
    SGPageTitleViewConfigure *pageConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    pageConfigure.titleSelectedColor = [UIColor appThemeColor];
    pageConfigure.titleColor = [UIColor subTextColor];
    pageConfigure.indicatorColor = [UIColor appThemeColor];
    pageConfigure.titleFont = Font(16);
    pageConfigure.titleSelectedFont = [YQUtils systemMediumFontOfSize:16];
    pageConfigure.showBottomSeparator = NO;
    pageConfigure.indicatorStyle = SGIndicatorStyleCover;
//    pageConfigure.indicatorToBottomDistance = 5;
    pageConfigure.indicatorColor = [UIColor clearColor];
    pageConfigure.indicatorHeight = 40;
    pageConfigure.indicatorAdditionalWidth = (ScreenWidth - 54)/2.0 - 60;
//    pageConfigure.indicatorToBottomDistance = 2;
//    pageConfigure.indicatorCornerRadius = 2;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(20, 70, ScreenWidth - 40, 45) delegate:self titleNames:@[@"手机登录".localized,@"邮箱登录".localized] configure:pageConfigure];
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    [self.backView addSubview:self.pageTitleView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageTitleView.clipsToBounds = NO;
        self.pageTitleView.layer.masksToBounds = NO;
        [self.pageTitleView.indicatorView addLightGlassView:8 blurDensity:1 distance:3];
    });
}


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
//    self.numberTF.text = @"";
    if (selectedIndex == 0) {
        self.numberTF.placeholder = @"请输入手机号".localized;
        self.numberTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.numberTF addCountryCodePicker];
    }
    if (selectedIndex == 1) {
        self.numberTF.placeholder = @"请输入邮箱".localized;
        self.numberTF.keyboardType = UIKeyboardTypeDefault;
        [self.numberTF remobeCode];
    }
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
