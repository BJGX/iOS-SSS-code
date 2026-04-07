//
//  VFChangedPasswordVC.m
//  VFProject
//


//

#import "VFChangedPasswordVC.h"

@interface VFChangedPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *oldTF;
@property (weak, nonatomic) IBOutlet UITextField *onecNewTF;
@property (weak, nonatomic) IBOutlet UITextField *firstTF;
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@end

@implementation VFChangedPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"修改密码";
    if (self.type == 1) {
        self.oldTF.hidden = YES;
        self.lineView.hidden = YES;
    }
    
    [self.oldTF setPlaceholderColor];
    [self.onecNewTF setPlaceholderColor];
    [self.firstTF setPlaceholderColor];
    [self.firstTF yq_addTextFieldChangedAction:^(UITextField * _Nullable textField) {
        if (textField.text.length >= 11) {
            textField.text =  [textField.text substringToIndex:11];
        }
    }];

    
}


- (IBAction)sureAction:(UIButton *)sender {
    
    if (self.type == 1) {
        [self resetWord];
        return;
    }
    [self changed];
    
}

- (void)resetWord
{
    if (self.onecNewTF.text.length == 0) {
        [YQUtils showCenterMessage:self.onecNewTF.placeholder];
        return;
    }
    if (self.firstTF.text.length == 0) {
        [YQUtils showCenterMessage:self.firstTF.placeholder];
        return;
    }
    
    
    if (![self.firstTF.text isEqualToString:self.onecNewTF.text]) {
        [YQUtils showCenterMessage:@"两次密码不一致"];
        return;
    }
    
    
    NSString *url = @"api/en/user/editPass";
    NSDictionary *dic = @{@"reset":@"1",
                          @"newpass":self.firstTF.text
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在修改" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
}


- (void)changed
{
    
    if (self.oldTF.text.length == 0) {
        [YQUtils showCenterMessage:self.oldTF.placeholder];
        return;
    }
    if (self.onecNewTF.text.length == 0) {
        [YQUtils showCenterMessage:self.onecNewTF.placeholder];
        return;
    }
    if (self.firstTF.text.length == 0) {
        [YQUtils showCenterMessage:self.firstTF.placeholder];
        return;
    }
    
    
    if (![self.firstTF.text isEqualToString:self.onecNewTF.text]) {
        [YQUtils showCenterMessage:@"两次密码不一致"];
        return;
    }
    
    
    NSString *url = @"api/en/user/editPass";
    NSDictionary *dic = @{@"oldpass":self.oldTF.text,
                          @"newpass":self.firstTF.text
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在修改" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccesss" object:nil];
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
