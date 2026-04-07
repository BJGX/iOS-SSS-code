//
//  VFOldPhoneVC.m
//  VFProject
//


//

#import "VFOldPhoneVC.h"
#import "VFMobileLoginVC.h"
#import "UITextField+AreaCode.h"

@interface VFOldPhoneVC ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *phoneTF;

@end

@implementation VFOldPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle =  self.isMail ? @"更换邮箱" : @"更换手机";
    self.phoneTF.text = self.isMail ? [YQUserModel shared].user.mail :  [YQUserModel shared].user.phone;
    [self.codeTF setPlaceholderColor];
    [self.codeTF yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        if (textField.text.length >= 6) {
            textField.text =  [textField.text substringToIndex:6];
        }
    }];
    
    if (self.isMail == NO) {
        
    }
    // Do any additional setup after loading the view.
}
- (IBAction)sendAction:(UIButton *)sender {
    
    
    if (self.isMail) {
        NSString *url = @"api/en/user/sendEmailCode";
        //phone 手机号.
        //type 1：注册；2：登录. 3：更换手机 4：找回密码 5: 发送验证码
        NSDictionary *dic = @{@"mail":self.phoneTF.text, @"type":@(5)};
        [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在发送" andBlock:^(id obj, NSInteger code) {
            if (code == 1) {
                [sender startCountDown:60];
            }
            
        }];
        
        return;
    }
    
    NSString *url = @"api/en/user/sendCode";
    //phone 手机号.
    //type 1：注册；2：登录. 3：更换手机 4：找回密码 5: 发送验证码
    NSDictionary *dic = @{@"phone":self.phoneTF.text, @"type":@(5)};
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在发送" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [sender startCountDown:60];
        }
        
    }];
    
}
- (IBAction)nextActtion:(UIButton *)sender {
    

    if (self.codeTF.text.length != 6) {
        [YQUtils showCenterMessage:@"请输入正确的验证码"];
        return;
    }
    
    NSString *type = self.isMail == NO ? @"phone" : @"mail";
    NSString *url = @"api/en/user/codeJudge";
    NSDictionary *dic = @{type:self.phoneTF.text,
                          @"code":self.codeTF.text,
                          @"type":@"1"
                          
    };
    
    if (self.isMail == NO) {
        dic = @{type:self.phoneTF.text,
                @"code":self.codeTF.text,
                @"type":@"1",
                @"area_code":[YQUserModel shared].user.area_code
                              
        };
    }
    
    [self.view endEditing:YES];
    NSString *tips = @"正在验证";
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:tips andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            
            VFMobileLoginVC *vc = (VFMobileLoginVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFMobileLoginVC"];
            vc.type = 3;
            [self.navigationController pushViewController:vc animated:YES];
            
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
