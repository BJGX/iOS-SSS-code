//
//  SSNewAddFeedbackVC.m

//
//  Created by  on 2025/7/14.

//

#import "SSNewAddFeedbackVC.h"
#import "SSNewAddFeedbackHeader.h"

@interface SSNewAddFeedbackVC ()
@property (nonatomic, strong) SSNewAddFeedbackHeader *headerView;
@property (nonatomic, strong) NSString *location;
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
    
    
    [YQNetwork requestWithOtherUrl:@"https://myip.ipip.net" host:@"https://myip.ipip.net" andBlock:^(id obj, NSInteger code) {
        if (code == 0) {
            NSString *location = [self extractLocationAdvanced:obj];
            self.location = location;
        }
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}


// 更通用的正则：匹配到第一个英文域名或运营商前
- (NSString *)extractLocationAdvanced:(NSString *)response {
    // 匹配"来自于："后面的内容，直到遇到：
    // 1. 点号（域名开始）
    // 2. 运营商关键词
    // 3. 多个连续空格后的内容
    NSString *pattern = @"来自于：\\s*([^\\n\\r]+?)(?:\\s*(?:[a-zA-Z]|电信|联通|移动|铁通|广电|vnpt|imcloud|sejong|petaexpress))";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:nil];
    NSTextCheckingResult *match = [regex firstMatchInString:response
                                                    options:0
                                                      range:NSMakeRange(0, response.length)];
    if (match && match.numberOfRanges >= 2) {
        NSString *location = [response substringWithRange:[match rangeAtIndex:1]];
        return [location stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    
    // 备选：直接提取所有中文字符（包括空格）
    pattern = @"[\\u4e00-\\u9fa5]+(?:\\s+[\\u4e00-\\u9fa5]+)*";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    match = [regex firstMatchInString:response options:0 range:NSMakeRange(0, response.length)];
    if (match) {
        return [response substringWithRange:match.range];
    }
    
    return nil;
}



- (IBAction)sureAction:(UIButton *)sender {
    NSDictionary *dic = [self.headerView getParams];
    if (dic == nil) {
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    if (self.location.length > 0) {
        params[@"location"] = self.location;
    }
    
    
    NSString *url = @"api/en/mine/addFeedback";
    [YQNetwork requestMode:POST tailUrl:url params:params showLoadString:@"正在上传" andBlock:^(id obj, NSInteger code) {
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
