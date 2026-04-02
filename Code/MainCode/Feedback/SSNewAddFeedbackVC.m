//
//  SSNewAddFeedbackVC.m

//
//  Created by  on 2025/7/14.

//

#import "SSNewAddFeedbackVC.h"
#import "SSNewAddFeedbackHeader.h"

@interface SSNewAddFeedbackVC ()
@property (nonatomic, strong) SSNewAddFeedbackHeader *headerView;

@end

@implementation SSNewAddFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.mj_h = 500;
    self.navTitle = @"意见反馈";
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor subBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.headerView = [[NSBundle mainBundle] loadNibNamed:@"SSNewAddFeedbackHeader" owner:nil options:nil].firstObject;
        self.tableView.mj_h = self.headerView.mj_h;
        self.headerView.frame = CGRectMake(0, 0, ScreenWidth, self.headerView.mj_h);
        self.tableView.tableHeaderView = self.headerView;
    });
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)sureAction:(UIButton *)sender {
    NSDictionary *dic = [self.headerView getParams];
    if (dic == nil) {
        return;
    }
    NSString *url = @"api/en/mine/addFeedback";
    [YQNetwork requestMode:POST tailUrl:url params:dic showLoadString:@"正在上传" andBlock:^(id obj, NSInteger code) {
        if (code == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [YQUtils showCenterMessage:@"反馈成功"];
//            if (self.completeAdd) {
//                self.completeAdd();
//            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FeddbackRefresh" object:nil];
//            [self dismissViewControllerAnimated:YES completion:nil];
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
