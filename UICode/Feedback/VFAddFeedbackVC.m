//
//  VFAddFeedbackVC.m
//  VFProject
//


//

#import "VFAddFeedbackVC.h"
#import "UITextView+PlaceHolder.h"
#import "QYUploadImageManger.h"

@interface VFAddFeedbackVC ()
@property (nonatomic, strong) QYUploadImageManger *upload;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) UITextField *codeTF;
@end

@implementation VFAddFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self hiddenNavigationBar:YES];
    self.view.backgroundColor = [UIColor subBackgroundColor];
//    self.tableView.backgroundColor = [UIColor backGroundColor];
    [self setUI];
}

- (void)setUI
{
    UIView *backView = [UIView viewWithFrame:CGRectMake(10, 80, ScreenWidth - 20, ScreenHeight - 160) backgroundColor:[UIColor backGroundColor] superView:self.view];
    backView.cornerRadius = 15;
    
    [self.tableView removeFromSuperview];
    [backView addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 100, ScreenWidth-20, ScreenHeight - 160 - 200);
    
    
    UILabel *topLabel = [UILabel YQLabelWithString:@"提交新的反馈" textColor:[UIColor whiteColor] font:[YQUtils systemSemiboldFontOfSize:24] superView:backView];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithNormalImage:@"icon_f_close" selectedImage:@"icon_f_close" superView:backView btnClick:^(UIButton *btn) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    closeBtn.frame = CGRectMake(ScreenWidth - 65, 20, 30, 30);
//    closeBtn.centerY =
//    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(backView.mas_right).offset(-15);
//        make.centerX.mas_equalTo(topLabel);
//
//    }];
    
    UIView *line = [UIView viewWithFrame:CGRectZero backgroundColor:rgba(255, 255, 255, 0.5) superView:backView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
        make.top.mas_equalTo(topLabel.mas_bottom).offset(12);
    }];
    
    
    UIView *headerView = [UIView viewWithFrame:CGRectMake(0, 0, ScreenWidth-20, 530) backgroundColor:[UIColor clearColor]];

    
    UILabel *tips = [UILabel YQLabelWithString:@"反馈内容" textColor:[UIColor mainTextColor] font:Font(17) superView:headerView];
    tips.frame = CGRectMake(15, 15, 200, 17);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(tips.frame)+10, ScreenWidth-50, 200)];
    [headerView addSubview:textView];
    textView.font = Font(16);
    textView.textColor = [UIColor mainTextColor];
    textView.backgroundColor = [UIColor tableBackgroundColor];
    textView.cornerRadius = 5;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.placeholderColor = [UIColor subTextColor];
    textView.placeholder = @"若付款成功VIP时间未到账, 请提供App订单截图+支付成功截图, 以便优先处理";
    
    UILabel *label = [UILabel YQLabelWithString:@"上传图片(选填, 不超过3张)" textColor:[UIColor mainTextColor] font:Font(17) superView:headerView];
    
    label.frame = CGRectMake(15, CGRectGetMaxY(textView.frame)+20, 300, 17);
    
    
    
    QYUploadImageManger *upload = [[QYUploadImageManger alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame)+10, ScreenWidth - 50, 200)];
    upload.maxCount = 3;
    [headerView addSubview:upload];
    [upload showView:YES];
    self.upload = upload;
    
    UILabel *tips2 = [UILabel YQLabelWithString:@"验证码" textColor:[UIColor mainTextColor] font:Font(17) superView:headerView];
    
    tips2.frame = CGRectMake(15, CGRectGetMaxY(upload.frame)+20, 200, 17);
    
    UITextField *codeTF = [[UITextField alloc] init];
    codeTF.backgroundColor = [UIColor tableBackgroundColor];
    codeTF.placeholder = @"请输入右边的验证码";
    codeTF.cornerRadius = 5;
    codeTF.leftView = [UIView viewWithFrame:CGRectMake(0, 0, 10, 45) backgroundColor:[UIColor clearColor]];
    codeTF.leftViewMode = UITextFieldViewModeAlways;
    codeTF.keyboardType = UIKeyboardTypeNumberPad;
    [headerView addSubview:codeTF];
    [codeTF setPlaceholderColor];
    
    
    int code = arc4random() % 8000 + 1000;
    self.codeString = [NSString stringWithFormat:@"%d", code];
    UILabel *codeLabel = [UILabel YQLabelWithString:[NSString stringWithFormat:@"%d", code] textColor:[UIColor mainTextColor] font:Font(17) superView:headerView];
    codeLabel.cornerRadius = 5;
    codeLabel.backgroundColor = [UIColor tableBackgroundColor];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.width.offset(100);
        make.height.offset(45);
        make.top.mas_equalTo(tips2.mas_bottom).offset(10);
    }];
    
    [codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(codeLabel.mas_left).offset(-15);
        make.left.offset(15);
        make.height.offset(45);
        make.top.mas_equalTo(tips2.mas_bottom).offset(10);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithTitle:@"提交反馈" titleColor:[UIColor whiteColor] font:[YQUtils systemMediumFontOfSize:17] backgroundColor:[UIColor appThemeColor] superView:backView btnClick:^(UIButton *btn) {
        [self addAction];
    }];
    sureBtn.cornerRadius = 12;
    
//    [sureBtn setBackgroundImage:[UIImage imageNamed:@"icon_mine_btn1"] forState:0];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.left.offset(15);
        make.height.offset(45);
        make.bottom.mas_equalTo(backView.mas_bottom).offset(-15);
    }];
    self.tableView.tableHeaderView = headerView;
    self.textView = textView;
    self.codeTF = codeTF;
}


- (void)addAction
{
    NSString *url = @"api/en/mine/addFeedback";
    if (self.textView.text.length == 0) {
        [YQUtils showCenterMessage:@"请输入内容"];
        return;
    }
    
    if (![self.codeTF.text isEqualToString:self.codeString]) {
        [YQUtils showCenterMessage:@"验证码错误"];
        return;
    }
    
    NSString *images = [self.upload getImages];
    if (images == nil) {
        [YQUtils showCenterMessage:@"正在上传图片, 请稍后"];
        return;
    }
    
    NSDictionary *dic = @{@"content":self.textView.text,
                          @"imgs":images
    };
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在上传" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
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
