//
//  VFAccountVC.m
//  VFProject
//


//

#import "VFAccountVC.h"
#import "VFOldPhoneVC.h"
#import "VFBindMoblieVC.h"
#import "NPLanguageTool.h"
#import "VFTipsView.h"
@interface VFAccountVC ()
@property (nonatomic, strong) NSArray *infoArray;

@end

@implementation VFAccountVC


- (void)openLog
{
    NSURL *folderURL = [[SimpleLogger sharedLogger] openLogsFolder];
    
    if ([DeviceHelper isiPadOnMac]) {
        if (@available(iOS 14.0, *)) {
            [[UIApplication sharedApplication] openURL:folderURL options:@{} completionHandler:nil];
        }
        return;
    }

    
    
    NSArray *activityItems = @[folderURL];
       
       // 4. 创建并配置UIActivityViewController
       UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
       
       // 5. (可选) 排除某些活动类型
       activityVC.excludedActivityTypes = @[
           UIActivityTypeAddToReadingList,
           UIActivityTypeAssignToContact
       ];
    UIViewController *vc = [YQUtils getCurrentVC];
       // 6. 弹出分享视图
       // 在iPhone上建议使用presentViewController
       // 在iPad上需要设置popoverPresentationController的sourceView和sourceRect
       if ([DeviceHelper isiPad]) {
           // iPad需要以popover形式弹出
           activityVC.popoverPresentationController.sourceView = vc.view;
           activityVC.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(vc.view.bounds), CGRectGetMidY(vc.view.bounds), 0, 0);
           activityVC.popoverPresentationController.permittedArrowDirections = 0;
       }

    [vc presentViewController:activityVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *title = [YQUserModel shared].user.mail.length > 0 ?  @"更换邮箱" : @"更换手机";
    if ([YQUserModel shared].user.tourist == 1) {
        title = @"绑定账号";
    }
    self.navTitle = @"我的账号";
    NSArray *array = @[@"用户ID",
                       @"手机号码",
                       @"邀请人数",
                       @"剩余时长",
                       title,
                       @"语言",
//                       @"BUG反馈"
    ];
    [self.dataArray addObjectsFromArray:array];
    YQUserModel *user= [YQUserModel shared].user;
    
    NSString *time = @"0";
    if (user.vip < 60) {
        time = [NSString stringWithFormat:@"%@ %ld%@",@"剩余".localized, user.vip,@"分钟".localized];
    }
    else if (user.vip < 60*24) {
        time = [NSString stringWithFormat:@"%@ %ld%@",@"剩余".localized, user.vip/60,@"小时".localized];
    }
    else{        time = [NSString stringWithFormat:@"%@ %ld%@",@"剩余".localized, user.vip/60/24,@"天".localized];
    }
    LanguageType type = [NPLanguageTool shared].languageType;
    self.infoArray = @[user.ID ?: @"",
                       user.phone ?: @"",
                       user.invite ?: @"",
                       time,
                       @"",
                       type == LanguageTypeEnglish ? @"English" : @"中文",
//                       @"保存"
    ];
    
    
    CGFloat y = 15;
    if ([DeviceHelper isiPadOnMac]) {
        y += 20;
    }
    
    self.tableView.frame = CGRectMake(15, y + PUB_NAVBAR_HEIGHT , ScreenWidth - 30, self.infoArray.count * 55);
    self.tableView.cornerRadius = 12;
    self.view.backgroundColor = [UIColor subBackgroundColor];
    self.navigationBar.backgroundColor = [UIColor subBackgroundColor];
    
//    [[SimpleLogger sharedLogger] logWithLevel:LogLevelError category:@"123123" message:@"1231231"];
    WeakSelf;
    UIButton *deleteBtn = [UIButton buttonWithTitle:@"注销账号" titleColor:[UIColor subTextColor] font:Font(14) backgroundColor:[UIColor clearColor] superView:self.view btnClick:^(UIButton *btn) {
        
        
        [VFTipsView showView:@"是否注销账号" content:@"注销后,账号信息清空,如果有购买VIP, VIP时间也将清空,并且您将无法通过次账号登录" leftBtn:@"取消" rightBtn:@"注销" block:^(NSInteger code) {
            if (code == 1) {
              [QYSettingConfig shared].showLoginVC = NO;
                [YQUserModel loginOutUser];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    self.tabBarController.selectedIndex = 0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginOutUser" object:nil];
                });
            }
        }];
    }];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-20);
        make.height.offset(30);
        make.centerX.offset(0);
        make.width.offset(200);
    }];
    
    
    UILabel *openlogLabel = [UILabel YQLabelWithString:@"     " textColor:[UIColor clearColor] font:Font(12) superView:self.view];
    [openlogLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(200);
        make.height.offset(30);
        make.top.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLog)];
    tap.numberOfTapsRequired = 3;
    [openlogLabel addGestureRecognizer:tap];
    openlogLabel.userInteractionEnabled = YES;
    
    
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.tableView.separatorInset = uied
    
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor mainTextColor];
        cell.backgroundColor = [UIColor tabBarBackgroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UIImageView *rightImageView = [[UIImageView alloc] init];
//        [cell.contentView addSubview:rightImageView];
//        rightImageView.image = [UIImage imageNamed:@"icon_right_arrow"];
//        rightImageView.tag = 101;
//        
//        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(cell.contentView);
//            make.right.offset(-25);
//        }];
        
        UILabel *subLabel = [UILabel YQLabelWithString:@"" textColor:[UIColor subTextColor] font:Font(15) superView:cell.contentView];
        subLabel.tag = 100;
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView);
            make.right.offset(-25);
            make.height.offset(30);
        }];
        subLabel.backgroundColor = [UIColor clearColor];
        
        
    }
    
    UILabel *label = [cell.contentView viewWithTag:100];
    if (indexPath.row == 2 || indexPath.row == 4) {
//        [label mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.offset(-40);
//        }];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
//        [label mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.offset(-25);
//        }];
    }
    NSString *title = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@",title.localized];
    label.text = self.infoArray[indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        
        
        if ([YQUserModel shared].user.tourist == 1) {
            VFBindMoblieVC *vc = (VFBindMoblieVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFBindMoblieVC"];
            vc.isBind = YES;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        VFOldPhoneVC *vc = (VFOldPhoneVC *)[YQUtils returnStoryboardVC:@"Mine" vcName:@"VFOldPhoneVC"];
        vc.isMail = [YQUserModel shared].user.mail.length > 0 ? YES : NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (indexPath.row == 5) {
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
    
    if (indexPath.row == 6) {
        [[SimpleLogger sharedLogger] openLogsFolder];
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
