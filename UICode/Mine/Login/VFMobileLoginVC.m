//
//  VFMobileLoginVC.m
//  VFProject
//


//

#import "VFMobileLoginVC.h"
#import "VFChangedPasswordVC.h"
#import "SGPagingView.h"
#import "UITextField+AreaCode.h"

@interface VFMobileLoginVC ()<SGPageTitleViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation VFMobileLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 1：注册；2：登录. 3：更换手机 4：找回密码 5: 发送验证码
    switch (self.type) {
        case 1:
            self.navTitle = @"注册";
            [self.loginBtn setTitle:@"注册".localized forState:0];
            break;
        case 2:
            self.navTitle = @"验证码登录";
            [self.loginBtn setTitle:@"登录".localized forState:0];
            break;
        case 3:
            self.navTitle = @"更换手机";
            [self.loginBtn setTitle:@"更换".localized forState:0];
            break;
        case 4:
            self.navTitle = @"找回密码";
            [self.loginBtn setTitle:@"下一步".localized forState:0];
            break;
            
        default:
            break;
    }
    
    
    [self setTitleViewUI];
    [self.phoneTF addCountryCodePicker];
    [self.phoneTF setPlaceholderColor];
    [self.codeTF setPlaceholderColor];
    WeakSelf;
    [self.phoneTF yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        if (textField.text.length >= 11 && weakSelf.pageTitleView.signBtnIndex == 0) {
            textField.text =  [textField.text substringToIndex:11];
        }
    }];
    [self.codeTF yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        if (textField.text.length >= 6) {
            textField.text =  [textField.text substringToIndex:6];
        }
    }];
    
    
}
- (IBAction)codeAction:(UIButton *)sender {
    
    
    if (self.pageTitleView.signBtnIndex == 1) {
        
        if (![self.phoneTF.text containsString:@"@"]) {
            [YQUtils showCenterMessage:@"请输入正确的邮箱号"];
            return;
        }
        
        NSString *url = @"api/en/user/sendEmailCode";
        //mail 邮箱号.
        //type 1：注册；2：登录. 3：更换邮箱 4：找回密码 5: 发送验证码
        NSDictionary *dic = @{@"mail":self.phoneTF.text, @"type":@(self.type)};
        [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在发送" andBlock:^(id obj, NSInteger code) {
            if (code == 1) {
                [sender startCountDown:60];
            }
            
        }];
        
        return;
    }
    
    
    if (self.phoneTF.text.length != 11) {
        [YQUtils showCenterMessage:@"请输入正确的手机号"];
        return;
    }
    NSString *url = @"api/en/user/sendCode";
    //phone 手机号.
    //type 1：注册；2：登录. 3：更换手机 4：找回密码 5: 发送验证码
    NSDictionary *dic = @{@"phone":self.phoneTF.text, @"type":@(self.type),@"area_code":self.phoneTF.selectedDialCode};
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在发送" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [sender startCountDown:60];
        }
        
    }];
    
    
}
- (IBAction)loginAction:(UIButton *)sender {
    if (self.type == 2) {
        [self login];
    }
    if (self.type == 4) {
        [self foundPassword];
    }
    if (self.type == 3) {
        [self updatePhone];
    }
}


- (void)updatePhone
{
    
    if (self.pageTitleView.signBtnIndex == 1) {
        
        if (![self.phoneTF.text containsString:@"@"]) {
            [YQUtils showCenterMessage:@"请输入正确的邮箱号"];
            return;
        }
        
        if (self.codeTF.text.length != 6) {
            [YQUtils showCenterMessage:@"请输入正确的验证码"];
            return;
        }
        NSString *url = @"api/en/user/updateEmail";
        NSDictionary *dic = @{@"old_mail":[YQUserModel shared].user.phone,
                              @"code":self.codeTF.text,
                              @"mail":self.phoneTF.text
                              
        };
        [self.view endEditing:YES];
        NSString *tips = @"正在更换";
        [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:tips andBlock:^(id obj, NSInteger code) {
            if (code == 1) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
            }
        
        }];
        
        return;
    }
    
    
    
    if (self.phoneTF.text.length != 11) {
        [YQUtils showCenterMessage:@"请输入正确的手机号"];
        return;
    }
    if (self.codeTF.text.length != 6) {
        [YQUtils showCenterMessage:@"请输入正确的验证码"];
        return;
    }
    NSString *url = @"api/en/user/updatePhone";
    NSDictionary *dic = @{@"old_phone":[YQUserModel shared].user.phone,
                          @"code":self.codeTF.text,
                          @"phone":self.phoneTF.text,
                          @"area_code":self.phoneTF.selectedDialCode
                          
                          
    };
    [self.view endEditing:YES];
    NSString *tips = @"正在更换";
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:tips andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
        }
    
    }];
}


- (void)login
{
    
    
    
    if (self.phoneTF.text.length != 11 && self.pageTitleView.signBtnIndex == 0) {
        [YQUtils showCenterMessage:@"请输入正确的手机号"];
        return;
    }
    
    
    if (![self.phoneTF.text containsString:@"@"] && self.pageTitleView.signBtnIndex == 1) {
        [YQUtils showCenterMessage:@"请输入正确的邮箱号"];
        return;
    }
    
    if (self.codeTF.text.length != 6) {
        [YQUtils showCenterMessage:@"请输入正确的验证码"];
        return;
    }
    
    
    NSString *type = self.pageTitleView.signBtnIndex == 0 ? @"phone" : @"mail";
    
    NSString *url = @"api/en/user/codeJudge";
    NSDictionary *dic = @{type:self.phoneTF.text,
                          @"code":self.codeTF.text,
                          @"type":@"2",
                          @"area_code":self.phoneTF.selectedDialCode
                          
    };
    if (self.pageTitleView.signBtnIndex == 1) {
        dic = @{type:self.phoneTF.text,
              @"code":self.codeTF.text,
              @"type":@"2",
        };
    }
    
    
    [self.view endEditing:YES];
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


- (void)foundPassword
{
    if (self.phoneTF.text.length != 11 && self.pageTitleView.signBtnIndex == 0) {
        [YQUtils showCenterMessage:@"请输入正确的手机号"];
        return;
    }
    
    
    if (![self.phoneTF.text containsString:@"@"] && self.pageTitleView.signBtnIndex == 1) {
        [YQUtils showCenterMessage:@"请输入正确的邮箱号"];
        return;
    }
    
    
    if (self.codeTF.text.length != 6) {
        [YQUtils showCenterMessage:@"请输入正确的验证码"];
        return;
    }
    
    NSString *type = self.pageTitleView.signBtnIndex == 0 ? @"phone" : @"mail";
    
    NSString *url = @"api/en/user/codeJudge";
    NSDictionary *dic = @{type:self.phoneTF.text,
                          @"code":self.codeTF.text,
                          @"type":@"1"
                          
    };
    [self.view endEditing:YES];
    NSString *tips = @"正在验证";
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:tips andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            VFChangedPasswordVC *vc = (VFChangedPasswordVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFChangedPasswordVC"];
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
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
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(20, PUB_NAVBAR_HEIGHT + 30, ScreenWidth - 40, 45) delegate:self titleNames:@[@"手机登录".localized,@"邮箱登录".localized] configure:pageConfigure];
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.pageTitleView];
    
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
        self.phoneTF.placeholder = @"请输入手机号".localized;
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        [self.phoneTF addCountryCodePicker];
    }
    if (selectedIndex == 1) {
        self.phoneTF.placeholder = @"请输入邮箱号".localized;
        self.phoneTF.keyboardType = UIKeyboardTypeDefault;
        [self.phoneTF remobeCode];
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
